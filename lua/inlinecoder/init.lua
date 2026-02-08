local M = {}

local config = require("inlinecoder.config")
local api = require("inlinecoder.api")
local ui = require("inlinecoder.ui")
local context = require("inlinecoder.context")

function M.setup(opts)
  config.setup(opts or {})
end

function M.generate_code()
  local selection = ui.get_visual_selection()
  local has_selection = selection ~= nil

  vim.ui.input({
    prompt = "Enter generation prompt: ",
  }, function(user_prompt)
    if not user_prompt or user_prompt == "" then
      vim.notify("InlineCoder: Cancelled", vim.log.levels.INFO)
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local cursor_line = cursor_pos[1] - 1

    -- Get context based on whether we have a selection or not
    local ctx
    if has_selection then
      ctx = context.extract_context(bufnr, {
        start_line = selection.start_line,
        end_line = selection.end_line,
      })
    else
      ctx = context.extract_context(bufnr, {
        start_line = cursor_line,
        end_line = cursor_line,
      })
    end

    -- Show indicator based on mode
    local cleanup_indicator
    if has_selection then
      cleanup_indicator = ui.show_generating_indicator(selection)
    else
      cleanup_indicator = ui.show_generating_indicator_at_cursor(cursor_line)
    end

    -- Call LLM with selection text (or empty string if no selection)
    local input_text = has_selection and selection.text or ""

    api.call_lm_studio(input_text, user_prompt, ctx, function(generated_code, err)
      cleanup_indicator()

      if err then
        if has_selection then
          ui.show_error_message(err, selection)
        else
          ui.show_error_message(err, nil)
        end
        return
      end

      -- Insert or replace based on whether we had a selection
      if has_selection then
        ui.replace_selection(generated_code, selection)
      else
        ui.insert_above_cursor(generated_code, cursor_line)
      end
      vim.notify("InlineCoder: Code generated successfully", vim.log.levels.INFO)
    end)
  end)
end

return M
