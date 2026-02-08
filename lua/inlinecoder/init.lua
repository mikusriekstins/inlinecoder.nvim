-- Main inlinecoder module
local M = {}

local config = require("inlinecoder.config")
local api = require("inlinecoder.api")
local ui = require("inlinecoder.ui")

-- Setup function for user configuration
function M.setup(opts)
  config.setup(opts or {})
end

-- Main code generation function
function M.generate_code()
  -- Get the visual selection
  local selection = ui.get_visual_selection()

  if not selection then
    vim.notify("InlineCoder: Please select code first", vim.log.levels.WARN)
    return
  end

  -- Request user prompt
  vim.ui.input({
    prompt = "Enter generation prompt: ",
  }, function(user_prompt)
    -- Check if user cancelled
    if not user_prompt or user_prompt == "" then
      vim.notify("InlineCoder: Cancelled", vim.log.levels.INFO)
      return
    end

    -- Show generating indicator
    local cleanup_indicator = ui.show_generating_indicator(selection)

    -- Call LM Studio API
    api.call_lm_studio(selection.text, user_prompt, function(generated_code, err)
      -- Always clear the indicator first
      cleanup_indicator()

      if err then
        -- Show error
        ui.show_error_message(err, selection)
        return
      end

      -- Replace selection with generated code
      ui.replace_selection(generated_code, selection)

      -- Show success message
      vim.notify("InlineCoder: Code generated successfully", vim.log.levels.INFO)
    end)
  end)
end

return M
