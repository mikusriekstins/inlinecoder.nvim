local M = {}
local queries = require("inlinecoder.queries")

-- Extract context from the current buffer using Treesitter
-- @param bufnr number: Buffer number
-- @param selection_range table: { start_line, end_line } (1-indexed)
-- @return table|nil: { context_text, stats } or nil if context disabled/unavailable
function M.extract_context(bufnr, selection_range)
  local config = require("inlinecoder.config")
  local cfg = config.options.context

  -- Early exit if context is disabled
  if not cfg.enabled then
    return nil
  end

  -- Wrap everything in pcall for graceful error handling
  local success, result = pcall(function()
    -- Get Treesitter parser
    local parser = M.get_parser(bufnr)
    if not parser then
      if cfg.show_context_errors then
        vim.notify("Treesitter parser not available for this buffer", vim.log.levels.WARN)
      end
      return nil
    end

    -- Get the syntax tree
    local tree = parser:parse()[1]
    if not tree then
      return nil
    end

    local root = tree:root()
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

    -- Check if language is supported
    if not queries.is_supported(filetype) then
      if cfg.show_context_errors then
        vim.notify("Context extraction not supported for " .. filetype, vim.log.levels.WARN)
      end
      return nil
    end

    -- Extract all relevant nodes
    local items = {}
    local include_cfg = cfg.include

    -- Map of context types to their include flag
    local context_types = {
      functions = include_cfg.functions,
      classes = include_cfg.classes,
      methods = include_cfg.methods,
      types = include_cfg.types,
      imports = include_cfg.imports,
      exports = false, -- Exports are extracted with imports
    }

    for context_type, should_include in pairs(context_types) do
      if should_include then
        local query_str = queries.get_query(filetype, context_type)
        if query_str then
          local extracted = M.query_nodes(bufnr, root, query_str, context_type)
          for _, item in ipairs(extracted) do
            table.insert(items, item)
          end
        end
      end
    end

    -- If no items extracted, return empty context
    if #items == 0 then
      return {
        context_text = "",
        stats = { total_items = 0, total_lines = 0 }
      }
    end

    -- Calculate relevance scores
    for _, item in ipairs(items) do
      item.score = M.calculate_relevance_score(item, selection_range, cfg)
    end

    -- Sort by relevance (highest first)
    table.sort(items, function(a, b)
      return a.score > b.score
    end)

    -- Enforce token budget
    local filtered_items = M.enforce_token_budget(items, cfg.max_tokens_estimate, cfg.max_lines)

    -- Format context block
    local context_text = M.format_context_block(filtered_items)

    return {
      context_text = context_text,
      stats = {
        total_items = #filtered_items,
        total_lines = M.count_lines(context_text),
        original_items = #items,
      }
    }
  end)

  if not success then
    if cfg.show_context_errors then
      vim.notify("Context extraction failed: " .. tostring(result), vim.log.levels.ERROR)
    end
    if cfg.fallback_on_error then
      return nil
    else
      error(result)
    end
  end

  return result
end

-- Get Treesitter parser for buffer
-- @param bufnr number: Buffer number
-- @return table|nil: Parser object or nil if unavailable
function M.get_parser(bufnr)
  local success, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not success or not parser then
    return nil
  end
  return parser
end

-- Execute a Treesitter query and extract nodes
-- @param bufnr number: Buffer number
-- @param root table: Root node of syntax tree
-- @param query_str string: Treesitter query string
-- @param context_type string: Type of context being extracted
-- @return table: List of extracted items
function M.query_nodes(bufnr, root, query_str, context_type)
  local items = {}
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

  -- Parse the query
  local success, query = pcall(vim.treesitter.query.parse, filetype, query_str)
  if not success or not query then
    return items
  end

  -- Execute query
  for id, node, _ in query:iter_captures(root, bufnr, 0, -1) do
    local capture_name = query.captures[id]

    -- Only process definition nodes (not just names)
    if capture_name:match("%.definition$") or capture_name == "import" or capture_name == "export" or capture_name == "require" then
      local start_row, start_col, end_row, end_col = node:range()
      local text = vim.treesitter.get_node_text(node, bufnr)

      -- Try to find the name capture for this definition
      local name = nil
      if capture_name ~= "import" and capture_name ~= "export" and capture_name ~= "require" then
        -- Look for a name capture among child nodes
        for name_id, name_node, _ in query:iter_captures(node, bufnr, start_row, end_row + 1) do
          local name_capture = query.captures[name_id]
          if name_capture:match("%.name$") then
            name = vim.treesitter.get_node_text(name_node, bufnr)
            break
          end
        end
      end

      table.insert(items, {
        type = context_type,
        name = name,
        text = text,
        start_line = start_row + 1, -- Convert to 1-indexed
        end_line = end_row + 1,
        start_col = start_col,
        end_col = end_col,
      })
    end
  end

  return items
end

-- Calculate relevance score for a context item
-- @param item table: Extracted context item
-- @param selection_range table: { start_line, end_line }
-- @param cfg table: Context configuration
-- @return number: Relevance score (higher = more relevant)
function M.calculate_relevance_score(item, selection_range, cfg)
  local sel_start = selection_range.start_line
  local sel_end = selection_range.end_line
  local item_start = item.start_line
  local item_end = item.end_line

  -- Check if item overlaps with selection
  if item_start <= sel_end and item_end >= sel_start then
    return 10.0 -- Overlapping = highest priority
  end

  -- Calculate distance from selection
  local distance
  if item_end < sel_start then
    distance = sel_start - item_end
  else
    distance = item_start - sel_end
  end

  -- Apply nearby prioritization
  if cfg.prioritize_nearby and distance <= cfg.nearby_lines then
    -- Score decreases linearly with distance
    return 5.0 * (1 - distance / cfg.nearby_lines)
  end

  -- Far away items get low score
  return 0.5
end

-- Enforce token/line budget by removing lowest-scored items
-- @param items table: List of items sorted by relevance
-- @param max_tokens number: Maximum estimated tokens
-- @param max_lines number: Maximum total lines
-- @return table: Filtered list of items
function M.enforce_token_budget(items, max_tokens, max_lines)
  local filtered = {}
  local total_lines = 0
  local total_tokens_estimate = 0

  for _, item in ipairs(items) do
    local item_lines = item.end_line - item.start_line + 1
    local item_tokens_estimate = #item.text / 4 -- Rough estimate: 4 chars per token

    -- Check if adding this item would exceed budgets
    if total_lines + item_lines <= max_lines and
       total_tokens_estimate + item_tokens_estimate <= max_tokens then
      table.insert(filtered, item)
      total_lines = total_lines + item_lines
      total_tokens_estimate = total_tokens_estimate + item_tokens_estimate
    else
      -- Budget exceeded, stop adding items
      break
    end
  end

  return filtered
end

-- Format context items into LLM-friendly text
-- @param items table: List of context items
-- @return string: Formatted context block
function M.format_context_block(items)
  if #items == 0 then
    return ""
  end

  -- Group items by type
  local grouped = {}
  for _, item in ipairs(items) do
    if not grouped[item.type] then
      grouped[item.type] = {}
    end
    table.insert(grouped[item.type], item)
  end

  -- Format each group
  local sections = {}
  table.insert(sections, "# Relevant code context from current file:\n")

  -- Type headers with nice formatting
  local type_headers = {
    imports = "# Imports:",
    exports = "# Exports:",
    types = "# Type Definitions:",
    classes = "# Classes:",
    functions = "# Functions:",
    methods = "# Methods:",
  }

  -- Order of sections
  local section_order = { "imports", "exports", "types", "classes", "functions", "methods" }

  for _, section_type in ipairs(section_order) do
    local group = grouped[section_type]
    if group and #group > 0 then
      table.insert(sections, type_headers[section_type])

      for _, item in ipairs(group) do
        -- Add name comment if available
        if item.name then
          table.insert(sections, "# " .. item.name)
        end
        table.insert(sections, item.text)
        table.insert(sections, "") -- Empty line between items
      end
    end
  end

  return table.concat(sections, "\n")
end

-- Count lines in a string
-- @param text string: Text to count lines in
-- @return number: Number of lines
function M.count_lines(text)
  local count = 1
  for _ in text:gmatch("\n") do
    count = count + 1
  end
  return count
end

return M
