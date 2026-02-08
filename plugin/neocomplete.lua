-- Auto-loaded plugin initialization
-- This file is automatically loaded by Neovim

-- Create user command
vim.api.nvim_create_user_command("InlineCoderGenerate", function()
  require("inlinecoder").generate_code()
end, {
  range = true,
  desc = "Generate code with InlineCoder AI"
})

-- Optional: Suggested visual mode keymap (users can override)
-- Uncomment to enable default keybinding
-- vim.keymap.set("v", "<leader>nc", ":InlineCoderGenerate<CR>", {
--   desc = "Generate code with InlineCoder",
--   silent = true,
-- })
