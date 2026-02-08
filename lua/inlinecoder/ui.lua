-- UI and visual selection handling
local M = {}

-- Namespace for extmarks
local ns_id = vim.api.nvim_create_namespace("inlinecoder_progress")

-- Get the current visual selection
function M.get_visual_selection()
  -- Get mark positions
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1 -- Convert to 0-indexed
  local start_col = start_pos[3] - 1
  local end_line = end_pos[2] - 1
  local end_col = end_pos[3] -- Keep 1-indexed for now

  -- Handle visual line mode (entire lines selected)
  local mode = vim.fn.visualmode()
  if mode == 'V' then
    -- Line-wise visual mode: select entire lines
    start_col = 0
    local line_content = vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1] or ""
    end_col = #line_content
  else
    -- Character-wise or block visual mode: use exact positions
    -- end_col from getpos is 1-indexed and inclusive, but we need it 0-indexed for nvim_buf_get_text
    -- In character-wise mode, getpos gives us the position of the last character, we want one past it
    -- Actually for nvim_buf_get_text, the end is exclusive, so we don't subtract 1
    end_col = end_col -- Already correct for exclusive end
  end

  -- Get the selected text
  local lines = vim.api.nvim_buf_get_text(0, start_line, start_col, end_line, end_col, {})

  if #lines == 0 or (#lines == 1 and lines[1] == "") then
    return nil
  end

  return {
    lines = lines,
    start_line = start_line,
    start_col = start_col,
    end_line = end_line,
    end_col = end_col,
    text = table.concat(lines, "\n")
  }
end

-- Replace the selection with new text
function M.replace_selection(new_text, range)
  if not new_text or new_text == "" then
    vim.notify("No code to insert", vim.log.levels.WARN)
    return
  end

  -- Split the new text into lines
  local new_lines = vim.split(new_text, "\n", { plain = true })

  -- Replace the text in the buffer
  vim.api.nvim_buf_set_text(
    0,
    range.start_line,
    range.start_col,
    range.end_line,
    range.end_col,
    new_lines
  )
end

-- Show generating indicator at the selection
function M.show_generating_indicator(range)
  -- Clear any existing marks first
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  -- Create virtual text overlay
  local extmark_id = vim.api.nvim_buf_set_extmark(0, ns_id, range.start_line, range.start_col, {
    virt_text = {{"% Generating code %", "IncSearch"}},
    virt_text_pos = "overlay",
    hl_mode = "combine",
    priority = 100,
  })

  -- Return cleanup function
  return function()
    pcall(vim.api.nvim_buf_del_extmark, 0, ns_id, extmark_id)
  end
end

-- Show error message
function M.show_error_message(message, range)
  -- Show notification
  vim.notify("InlineCoder: " .. message, vim.log.levels.ERROR)

  -- Optionally show inline error
  if range then
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    vim.api.nvim_buf_set_extmark(0, ns_id, range.start_line, range.start_col, {
      virt_text = {{message, "ErrorMsg"}},
      virt_text_pos = "eol",
      priority = 100,
    })

    -- Clear after 3 seconds
    vim.defer_fn(function()
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end, 3000)
  end
end

return M
