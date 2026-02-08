# InlineCoder

AI-assisted code generation plugin for Neovim using local LM Studio.

## Features

- Generate code using local LLM via LM Studio
- Automatic context extraction using Treesitter (functions, classes, types, imports)
- Visual feedback during generation
- Configurable and extensible

## Requirements

- Neovim 0.9+
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [LM Studio](https://lmstudio.ai/) running locally

## Installation

### lazy.nvim

```lua
{
  "mikusriekstins/inlinecoder.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("inlinecoder").setup()
  end
}
```

### packer.nvim

```lua
use {
  "mikusriekstins/inlinecoder.nvim",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    require("inlinecoder").setup()
  end
}
```

## Usage

1. Start LM Studio and load a model
2. Select code in visual mode
3. Run `:InlineCoderGenerate`
4. Enter your prompt
5. Generated code replaces your selection

## Configuration

```lua
require("inlinecoder").setup({
  api_url = "http://localhost:1234/v1/chat/completions",
  model = nil,  -- Auto-detect
  temperature = 0.7,
  max_tokens = 8192,

  context = {
    enabled = true,
    max_lines = 150,
    max_tokens_estimate = 600,
  },
})
```

To disable context extraction:

```lua
require("inlinecoder").setup({
  context = { enabled = false }
})
```

## Context Extraction

The plugin automatically extracts relevant code from your file using Treesitter to improve code generation. Supports JavaScript, TypeScript, JSX, TSX, Python, and Lua.

Context extraction gracefully falls back if Treesitter is unavailable.

## License

MIT
