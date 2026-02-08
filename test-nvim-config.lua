-- Minimal Neovim config to test InlineCoder
-- Run with: nvim -u test-nvim-config.lua test_example.py

-- Set up lazy.nvim bootstrap (if not already installed)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim with inlinecoder
require("lazy").setup({
  -- Plenary dependency
  {
    "nvim-lua/plenary.nvim",
  },

  -- InlineCoder (local development version)
  {
    dir = "/var/home/mikus/Development/inline-coder.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      -- Setup the plugin
      require("inlinecoder").setup({
        api_url = "http://localhost:4040/v1/chat/completions",
        temperature = 0.7,
        max_tokens = 2048,
        -- The improved system prompt is now the default, but you can override it here if needed
      })

      -- Create the command
      vim.api.nvim_create_user_command("InlineCoderGenerate", function()
        require("inlinecoder").generate_code()
      end, {
        range = true,
        desc = "Generate code with InlineCoder AI"
      })

      -- Add keybinding
      vim.keymap.set("v", "<leader>nc", ":InlineCoderGenerate<CR>", {
        desc = "Generate code with InlineCoder",
        silent = true,
      })

      print("✅ InlineCoder loaded! Try :InlineCoderGenerate in visual mode")
    end
  },
})

-- Basic settings for usability
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.mapleader = " "
