local M = {}

local ns_id = vim.api.nvim_create_namespace("inlinecoder_progress")

function M.get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local start_line = start_pos[2] - 1
  local start_col = start_pos[3] - 1
  local end_line = end_pos[2] - 1
  local end_col = end_pos[3]

  local mode = vim.fn.visualmode()
  if mode == 'V' then
    start_col = 0
    local line_content = vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1] or ""
    end_col = #line_content
  else
    end_col = end_col
  end

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

function M.replace_selection(new_text, range)
  if not new_text or new_text == "" then
    vim.notify("No code to insert", vim.log.levels.WARN)
    return
  end

  local new_lines = vim.split(new_text, "\n", { plain = true })

  vim.api.nvim_buf_set_text(
    0,
    range.start_line,
    range.start_col,
    range.end_line,
    range.end_col,
    new_lines
  )
end

function M.show_generating_indicator(range)
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  local extmark_id = vim.api.nvim_buf_set_extmark(0, ns_id, range.start_line, range.start_col, {
    virt_text = {{"% Generating code %", "IncSearch"}},
    virt_text_pos = "overlay",
    hl_mode = "combine",
    priority = 100,
  })

  return function()
    pcall(vim.api.nvim_buf_del_extmark, 0, ns_id, extmark_id)
  end
end

function M.show_error_message(message, range)
  vim.notify("InlineCoder: " .. message, vim.log.levels.ERROR)

  if range then
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    vim.api.nvim_buf_set_extmark(0, ns_id, range.start_line, range.start_col, {
      virt_text = {{message, "ErrorMsg"}},
      virt_text_pos = "eol",
      priority = 100,
    })

    vim.defer_fn(function()
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end, 3000)
  end
end

return M
