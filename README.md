# InlineCoder

AI-assisted code generation plugin for Neovim using local LM Studio.

## Features

- 🤖 Generate code using local LLM via LM Studio
- ✨ Visual feedback during generation
- ⚙️ Configurable API endpoint and prompts
- 🔄 Replace selected code with AI suggestions
- 🎯 Simple and focused workflow

## Requirements

- Neovim 0.8+
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) (dependency)
- [LM Studio](https://lmstudio.ai/) running locally with a model loaded

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "mikusriekstins/inlinecoder.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    require("inlinecoder").setup({
      -- Optional: customize configuration
      api_url = "http://localhost:1234/v1/chat/completions",
    })
  end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "mikusriekstins/inlinecoder.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("inlinecoder").setup()
  end
}
```

### Manual Installation

```bash
cd ~/.local/share/nvim/site/pack/plugins/start/
git clone https://github.com/mikusriekstins/inlinecoder.nvim
```

Then add to your `init.lua`:

```lua
require("inlinecoder").setup()
```

## Usage

1. **Start LM Studio** and load a model
2. **Select code** in visual mode (v, V, or Ctrl-V)
3. **Run command**: `:InlineCoderGenerate`
4. **Enter prompt**: Describe what you want to change
5. **Wait**: Visual feedback shows "% Generating code %"
6. **Review**: Generated code replaces your selection

### Example Workflow

```lua
-- Select these lines in visual mode
function add(a, b)
  return a + b
end
```

Run `:InlineCoderGenerate` and enter prompt: "add type hints and docstring"

Result:
```lua
--- Add two numbers together
--- @param a number First number
--- @param b number Second number
--- @return number Sum of a and b
function add(a, b)
  return a + b
end
```

## Configuration

Default configuration:

```lua
require("inlinecoder").setup({
  -- LM Studio API endpoint
  api_url = "http://localhost:1234/v1/chat/completions",

  -- System prompt (controls LLM behavior)
  system_prompt = "You are a code generation assistant. Generate ONLY code without explanations, comments, or markdown formatting. Return pure, executable code that can directly replace the selected text.",

  -- Model name (nil = auto-detect)
  model = nil,

  -- Temperature for generation (0.0 - 1.0)
  temperature = 0.7,

  -- Maximum tokens to generate
  max_tokens = 2048,
})
```

### Custom System Prompt Example

```lua
require("inlinecoder").setup({
  system_prompt = [[You are a senior software engineer. Generate clean, idiomatic code.
Only output code - no explanations, no markdown, no comments.
The code must be production-ready and follow best practices.
Use modern language features and handle errors appropriately.]],
})
```

## Keybindings

Add to your `init.lua`:

```lua
-- Visual mode: Generate code
vim.keymap.set("v", "<leader>nc", ":InlineCoderGenerate<CR>", {
  desc = "Generate code with InlineCoder",
  silent = true,
})

-- Alternative binding
vim.keymap.set("v", "<leader>ai", ":InlineCoderGenerate<CR>", {
  desc = "AI code generation",
  silent = true,
})
```

## LM Studio Setup

1. Download and install [LM Studio](https://lmstudio.ai/)
2. Download a code-capable model (e.g., CodeLlama, DeepSeek Coder, Qwen Coder)
3. Load the model in LM Studio
4. Start the local server (default: http://localhost:1234)
5. Verify the server is running by visiting http://localhost:1234/v1/models

## Troubleshooting

### "plenary.nvim not found"
Install plenary.nvim as a dependency:
```bash
cd ~/.local/share/nvim/site/pack/plugins/start/
git clone https://github.com/nvim-lua/plenary.nvim
```

### "Connection error: Is LM Studio running?"
- Ensure LM Studio is running
- Verify a model is loaded in LM Studio
- Check the local server is started (default port 1234)
- Verify the `api_url` in your config matches LM Studio's server address

### "LM Studio returned empty code"
- Try a different model (some models may not follow instructions well)
- Adjust the `system_prompt` to be more explicit
- Check LM Studio's console for errors

### "Request timed out"
- The model may be too slow for your hardware
- Try a smaller/faster model
- Increase timeout in `lua/inlinecoder/api.lua` (line 47: `timeout = 30000`)

### Generated code includes markdown formatting
Update your system prompt to be more explicit:
```lua
require("inlinecoder").setup({
  system_prompt = "Return ONLY raw code. No markdown, no backticks, no explanations. Just pure code.",
})
```

## Tips

- **Undo**: Press `u` if you don't like the generated code
- **Iterate**: Select the generated code and run again with a different prompt
- **Be specific**: More detailed prompts yield better results
  - ❌ "improve this"
  - ✅ "add error handling and logging"
- **Context matters**: Include surrounding code in your selection for better context

## Example Prompts

- "add error handling"
- "add type hints and docstrings"
- "refactor to use async/await"
- "optimize for performance"
- "add input validation"
- "convert to TypeScript"
- "add comprehensive unit tests"
- "make this more readable"

## Future Features

Planned enhancements:
- Automatic codebase context injection
- Streaming responses with incremental updates
- Model selection UI
- Generation history
- Custom context configuration per project
- LSP integration for better type awareness

## Contributing

Contributions welcome! Please open issues or pull requests on GitHub.

## License

MIT License - see LICENSE file for details

## Credits

Built with:
- [Neovim](https://neovim.io/)
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [LM Studio](https://lmstudio.ai/)
