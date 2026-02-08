-- Add this to your lazy.nvim plugin configuration
-- Location: ~/.config/nvim/lua/plugins/inlinecoder.lua
-- Or add to your plugins table in init.lua

return {
  -- InlineCoder plugin
  dir = "/var/home/mikus/Development/inline-coder.nvim",  -- Use local development version
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    -- Setup the plugin
    require("inlinecoder").setup({
      -- Use your custom port
      api_url = "http://localhost:4040/v1/chat/completions",

      -- Optional: customize other settings
      temperature = 0.7,
      max_tokens = 2048,

      -- The system prompt now includes strong anti-markdown instructions
      -- Markdown code blocks are also automatically stripped from responses
      -- You can override the system_prompt here if you want different behavior
    })

    -- Create the command (since plugin/ dir isn't auto-sourced with lazy.nvim dir)
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
  end
}
