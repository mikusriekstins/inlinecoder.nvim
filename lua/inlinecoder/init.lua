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

  if not selection then
    vim.notify("InlineCoder: Please select code first", vim.log.levels.WARN)
    return
  end

  vim.ui.input({
    prompt = "Enter generation prompt: ",
  }, function(user_prompt)
    if not user_prompt or user_prompt == "" then
      vim.notify("InlineCoder: Cancelled", vim.log.levels.INFO)
      return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local ctx = context.extract_context(bufnr, {
      start_line = selection.start_line,
      end_line = selection.end_line,
    })

    local cleanup_indicator = ui.show_generating_indicator(selection)

    api.call_lm_studio(selection.text, user_prompt, ctx, function(generated_code, err)
      cleanup_indicator()

      if err then
        ui.show_error_message(err, selection)
        return
      end

      ui.replace_selection(generated_code, selection)
      vim.notify("InlineCoder: Code generated successfully", vim.log.levels.INFO)
    end)
  end)
end

return M
