# InlineCoder Test Checklist

Use this checklist to verify InlineCoder is working correctly.

## Pre-Flight Checks

- [ ] Neovim 0.8+ installed (`nvim --version`)
- [ ] Plugin symlinked to `~/.local/share/nvim/site/pack/plugins/start/inlinecoder`
- [ ] plenary.nvim installed
- [ ] LM Studio downloaded and installed
- [ ] A code model downloaded in LM Studio (e.g., DeepSeek Coder, CodeLlama)
- [ ] Model loaded in LM Studio (selected from dropdown)
- [ ] LM Studio server running (green indicator, http://localhost:1234)

## Installation Tests

### Test 1: Plugin Loads
```vim
:lua print(vim.inspect(package.loaded["inlinecoder"]))
```
**Expected**: Should show a table, not `nil`

### Test 2: Command Exists
```vim
:InlineCoderGenerate
```
**Expected**: Should show "Please select code first" warning (since nothing is selected)

### Test 3: Module Requires Work
```vim
:lua require("inlinecoder")
```
**Expected**: No errors

### Test 4: Setup Function Works
```vim
:lua require("inlinecoder").setup()
```
**Expected**: No errors

## Functional Tests

### Test 5: Basic Code Generation

1. Open test file:
   ```bash
   nvim /var/home/mikus/Development/inline-coder.nvim/test_example.py
   ```

2. Select the `add` function (lines 4-5):
   - Press `V` to enter visual line mode
   - Move down to select both lines

3. Run: `:InlineCoderGenerate`

4. Enter prompt: `add type hints and docstring`

5. **Expected Results**:
   - [ ] Prompt appears asking for input
   - [ ] "% Generating code %" appears after entering prompt
   - [ ] Indicator disappears after generation
   - [ ] Code is replaced with new version
   - [ ] Success notification appears

### Test 6: Error Handling (No Selection)

1. In normal mode (not visual mode), run:
   ```vim
   :InlineCoderGenerate
   ```

2. **Expected**: Warning message "Please select code first"

### Test 7: User Cancellation

1. Select some code in visual mode
2. Run `:InlineCoderGenerate`
3. Press `<Esc>` or leave prompt empty
4. **Expected**: "Cancelled" message, no changes to code

### Test 8: LM Studio Connection Error

1. Stop LM Studio server (click "Stop Server")
2. Select some code
3. Run `:InlineCoderGenerate`
4. Enter a prompt
5. **Expected**:
   - [ ] Error notification appears
   - [ ] Message mentions connection error
   - [ ] Generating indicator is cleared
   - [ ] Code is unchanged

### Test 9: Undo Functionality

1. Select some code
2. Generate new code
3. Press `u` to undo
4. **Expected**: Original code is restored

### Test 10: Custom Configuration

1. Add to your config:
   ```lua
   require("inlinecoder").setup({
     temperature = 0.3,
     max_tokens = 1024,
   })
   ```
2. Reload config: `:source ~/.config/nvim/init.lua`
3. Verify it works with the new settings
4. **Expected**: No errors, generation still works

## Real-World Tests

### Test 11: Python Type Hints

**Before:**
```python
def calculate_total(items):
    return sum(item['price'] for item in items)
```

**Prompt:** "add type hints and docstring"

**Expected**: Should add proper type hints and a docstring

### Test 12: Error Handling

**Before:**
```python
def read_file(filename):
    with open(filename) as f:
        return f.read()
```

**Prompt:** "add error handling with try/except"

**Expected**: Should add try/except block

### Test 13: Async Conversion

**Before:**
```python
def fetch_data(url):
    import requests
    return requests.get(url).json()
```

**Prompt:** "convert to async with aiohttp"

**Expected**: Should convert to async function

## Edge Cases

### Test 14: Large Selection

1. Select 20-30 lines of code
2. Generate with a simple prompt like "add comments"
3. **Expected**: Should work (might take longer)

### Test 15: Single Line Selection

1. Select just one line of code
2. Generate with a prompt
3. **Expected**: Should work

### Test 16: Empty Line Selection

1. Select empty lines
2. Try to generate
3. **Expected**: Should show error or handle gracefully

## Configuration Tests

### Test 17: Custom System Prompt

```lua
require("inlinecoder").setup({
  system_prompt = "Return ONLY code. No explanations. No markdown.",
})
```

**Expected**: Code generation should work with new prompt

### Test 18: Different API URL (if using different port)

```lua
require("inlinecoder").setup({
  api_url = "http://localhost:5000/v1/chat/completions",
})
```

**Expected**: Should connect to different port (if LM Studio is on that port)

## Troubleshooting Tests

### Test 19: Check Plenary

```vim
:lua print(vim.inspect(package.loaded["plenary"]))
```

**Expected**: Should show a table (plenary is loaded)

### Test 20: Check LM Studio Connection Manually

```bash
curl http://localhost:1234/v1/models
```

**Expected**: Should return JSON with available models

## Performance Tests

### Test 21: Response Time

1. Time a typical generation
2. **Expected**:
   - Small model (7B): 5-15 seconds
   - Medium model (13B): 15-30 seconds
   - Large model (30B+): 30-60+ seconds

### Test 22: Multiple Generations

1. Generate code
2. Select the result
3. Generate again with a different prompt
4. **Expected**: Should work multiple times without issues

## Cleanup

After testing, if you want to remove the plugin:

```bash
# Remove symlink
rm ~/.local/share/nvim/site/pack/plugins/start/inlinecoder

# Or keep it if you like it! 😊
```

## Quick Debug Commands

If something isn't working, try these:

```vim
" Check if plugin directory exists
:lua print(vim.fn.isdirectory(vim.fn.stdpath('data') .. '/site/pack/plugins/start/inlinecoder'))

" Check loaded modules
:lua print(vim.inspect(package.loaded))

" Check for errors
:messages

" Reload the plugin
:lua package.loaded["inlinecoder"] = nil
:lua require("inlinecoder")
```

## Success Criteria

✅ All 22 tests pass
✅ No error messages in `:messages`
✅ Code generation works consistently
✅ Error handling is graceful
✅ Undo works properly

If all tests pass, InlineCoder is working perfectly! 🎉
