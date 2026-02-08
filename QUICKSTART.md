# InlineCoder Quick Start

Get up and running with InlineCoder in 5 minutes.

## 1. Install Dependencies

Make sure you have plenary.nvim installed:

```lua
-- In your Neovim config (init.lua or lazy.nvim spec)
{
  "nvim-lua/plenary.nvim"
}
```

## 2. Install InlineCoder

```lua
{
  "path/to/inlinecoder",  -- or "username/inlinecoder" when published
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("inlinecoder").setup()
  end
}
```

Or manually:
```bash
cd ~/.local/share/nvim/site/pack/plugins/start/
git clone <your-repo-url> inline-coder.nvim
```

## 3. Setup LM Studio

1. Download [LM Studio](https://lmstudio.ai/)
2. Download a code model (recommended: DeepSeek Coder, CodeLlama, or Qwen Coder)
3. Load the model
4. Click "Start Server" (should start on http://localhost:1234)

## 4. Configure InlineCoder (Optional)

Add to your Neovim config:

```lua
require("inlinecoder").setup({
  api_url = "http://localhost:1234/v1/chat/completions",
})
```

## 5. Add Keybinding (Recommended)

```lua
vim.keymap.set("v", "<leader>nc", ":InlineCoderGenerate<CR>", {
  desc = "Generate code with AI",
  silent = true,
})
```

## 6. Test It!

1. Open any code file in Neovim
2. Select a few lines in visual mode (press `v` and move cursor)
3. Press `<leader>nc` (or run `:InlineCoderGenerate`)
4. Enter a prompt like: "add error handling"
5. Watch as your code is transformed!

## First Test Example

Create a file `test.py`:

```python
def divide(a, b):
    return a / b
```

1. Select the entire function in visual mode
2. Run `:InlineCoderGenerate`
3. Enter prompt: "add error handling for division by zero"
4. Press Enter
5. See "% Generating code %" appear
6. Your code should be replaced with error handling

## Common Issues

**"plenary.nvim not found"**
- Install plenary.nvim first

**"Connection error"**
- Make sure LM Studio is running
- Check that the server is started (green indicator in LM Studio)
- Verify URL matches (default: http://localhost:1234)

**"Empty response"**
- The model might not be good at following instructions
- Try a different model in LM Studio
- Adjust the system prompt to be more explicit

## Next Steps

- Read [EXAMPLES.md](EXAMPLES.md) for more use cases
- Read [README.md](README.md) for full documentation
- Customize your system prompt for your coding style
- Experiment with different models in LM Studio

## Quick Reference

**Command:** `:InlineCoderGenerate`

**Visual Mode Workflow:**
1. `v` - Enter visual mode
2. Select code with movement keys
3. `:InlineCoderGenerate` or `<leader>nc`
4. Enter your prompt
5. Wait for generation
6. `u` to undo if needed

**Good Prompts:**
- "add type hints"
- "add error handling"
- "add docstring"
- "optimize this"
- "add logging"
- "refactor to async"

**Configuration:**
```lua
require("inlinecoder").setup({
  api_url = "http://localhost:1234/v1/chat/completions",
  temperature = 0.7,  -- 0.0 = deterministic, 1.0 = creative
  max_tokens = 2048,  -- max length of output
})
```

That's it! You're ready to use AI-assisted code generation in Neovim.
