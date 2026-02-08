# Getting Started with InlineCoder

Welcome! This guide will get you up and running with InlineCoder in just a few minutes.

## What is InlineCoder?

InlineCoder is a Neovim plugin that uses AI to help you write code. Select some code, describe what you want to change, and let the AI do the work!

**Privacy First**: Everything runs locally on your machine using LM Studio. No data is sent to the cloud.

## Quick Install

### Option 1: Automatic Installation (Recommended)

```bash
# Clone the repository
git clone <repository-url> inlinecoder
cd inlinecoder

# Run the installer
./install.sh
```

The installer will:
- Install inlinecoder to your Neovim plugins directory
- Check for and optionally install plenary.nvim
- Give you next steps

### Option 2: Manual Installation

```bash
# Clone to Neovim's plugin directory
git clone <repository-url> ~/.local/share/nvim/site/pack/plugins/start/inlinecoder

# Clone plenary.nvim dependency
git clone https://github.com/nvim-lua/plenary.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/plenary.nvim
```

## Setup LM Studio

1. **Download**: Get [LM Studio](https://lmstudio.ai/) for your OS
2. **Install**: Follow the installation wizard
3. **Download a Model**: 
   - Open LM Studio
   - Go to the "Discover" tab
   - Search for "DeepSeek Coder" or "CodeLlama"
   - Download a model (recommend 7B or 13B size)
4. **Load the Model**:
   - Go to "Chat" tab
   - Select your downloaded model from the dropdown
5. **Start Server**:
   - Click "Start Server" in the toolbar
   - Default URL: http://localhost:1234
   - Keep LM Studio running while using InlineCoder

## First Use

### 1. Open Neovim

```bash
nvim test_example.py
```

### 2. Select Code

Use visual mode to select code:
- Press `v` for character-wise visual mode
- Press `V` for line-wise visual mode
- Move cursor to select the code you want to modify

### 3. Run InlineCoder

```vim
:InlineCoderGenerate
```

Or set up a keybinding (recommended):

```lua
-- Add to your init.lua
vim.keymap.set("v", "<leader>nc", ":InlineCoderGenerate<CR>", {
  desc = "Generate code with AI",
  silent = true,
})
```

Then just press `<leader>nc` in visual mode!

### 4. Enter Your Prompt

You'll see: `Enter generation prompt:`

Type what you want to do, for example:
- "add error handling"
- "add type hints and docstring"
- "refactor to use async/await"

### 5. Wait for Generation

You'll see: `% Generating code %`

This usually takes 5-30 seconds depending on your hardware and model.

### 6. Review the Result

The AI-generated code will replace your selection. If you don't like it:
- Press `u` to undo
- Try again with a different prompt

## Example Walkthrough

Let's transform a simple function:

**Original code:**
```python
def divide(a, b):
    return a / b
```

**Steps:**
1. Open the file in Neovim
2. Select the entire function (press `V` then move down)
3. Run `:InlineCoderGenerate`
4. Enter: "add error handling for division by zero"
5. Wait for generation
6. See the result:

```python
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b
```

## Configuration (Optional)

Add to your Neovim config (`~/.config/nvim/init.lua`):

```lua
require("inlinecoder").setup({
  -- LM Studio API URL (change if using different port)
  api_url = "http://localhost:1234/v1/chat/completions",
  
  -- Control randomness (0.0 = deterministic, 1.0 = creative)
  temperature = 0.7,
  
  -- Maximum length of generated code
  max_tokens = 2048,
  
  -- Custom system prompt (optional)
  system_prompt = "You are a helpful code assistant. Generate only code, no explanations.",
})

-- Recommended keybinding
vim.keymap.set("v", "<leader>nc", ":InlineCoderGenerate<CR>", {
  desc = "Generate code with AI",
  silent = true,
})
```

## Common Issues

### "plenary.nvim not found"

Install plenary.nvim:
```bash
git clone https://github.com/nvim-lua/plenary.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/plenary.nvim
```

### "Connection error: Is LM Studio running?"

Make sure:
1. LM Studio is open
2. A model is loaded (selected in the dropdown)
3. The server is started (green indicator in LM Studio)
4. The URL matches (default: http://localhost:1234)

### Generated code includes markdown formatting

Try a more explicit system prompt:
```lua
require("inlinecoder").setup({
  system_prompt = "Return ONLY raw code. No markdown, no backticks, no explanations.",
})
```

### "Request timed out"

The model might be too large for your hardware. Try:
- A smaller model (7B instead of 13B)
- Closing other applications
- Being more concise in your prompt

## Tips for Best Results

1. **Be Specific**: Instead of "improve this", say "add input validation and logging"
2. **Include Context**: Select surrounding code for better understanding
3. **Iterate**: Generate once, then select and refine with another prompt
4. **Use Good Models**: DeepSeek Coder, CodeLlama, and Qwen Coder work well
5. **Experiment**: Try different prompts to see what works best

## Example Prompts

- "add type hints and docstring"
- "add comprehensive error handling"
- "refactor to use async/await"
- "add unit tests using pytest"
- "optimize for performance"
- "add logging at each step"
- "make this more readable"
- "extract this into a separate function"

## Learn More

- **README.md**: Full documentation and features
- **QUICKSTART.md**: Detailed 5-minute guide
- **EXAMPLES.md**: Many examples with before/after code
- **IMPLEMENTATION.md**: Technical details and architecture
- **PROJECT_SUMMARY.md**: Complete project overview

## Need Help?

1. Check the troubleshooting sections in README.md
2. Review EXAMPLES.md for usage patterns
3. Open an issue on GitHub

## What's Next?

Now that you have InlineCoder running:

1. **Practice**: Try it on different types of code
2. **Experiment**: Test various prompts to see what works
3. **Customize**: Adjust the configuration to your workflow
4. **Share**: Tell other developers about it!

Happy coding with AI! 🚀
