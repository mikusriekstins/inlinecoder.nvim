# InlineCoder Examples

This document contains practical examples of using InlineCoder for various code generation tasks.

## Basic Examples

### Adding Error Handling

**Before:**
```python
def read_file(filename):
    with open(filename) as f:
        return f.read()
```

**Prompt:** "add error handling with try/except"

**After:**
```python
def read_file(filename):
    try:
        with open(filename) as f:
            return f.read()
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found")
        return None
    except IOError as e:
        print(f"Error reading file: {e}")
        return None
```

### Adding Type Hints

**Before:**
```python
def calculate_total(items):
    return sum(item['price'] * item['quantity'] for item in items)
```

**Prompt:** "add type hints and docstring"

**After:**
```python
def calculate_total(items: list[dict[str, float]]) -> float:
    """Calculate the total cost of items.

    Args:
        items: List of dictionaries with 'price' and 'quantity' keys

    Returns:
        Total cost as a float
    """
    return sum(item['price'] * item['quantity'] for item in items)
```

### Refactoring to Async

**Before:**
```python
def fetch_data(url):
    response = requests.get(url)
    return response.json()
```

**Prompt:** "convert to async with aiohttp"

**After:**
```python
async def fetch_data(url):
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()
```

## Language-Specific Examples

### JavaScript/TypeScript

**Before:**
```javascript
function processUser(user) {
    return {
        name: user.name,
        age: user.age
    }
}
```

**Prompt:** "convert to TypeScript with interfaces"

**After:**
```typescript
interface User {
    name: string;
    age: number;
}

interface ProcessedUser {
    name: string;
    age: number;
}

function processUser(user: User): ProcessedUser {
    return {
        name: user.name,
        age: user.age
    }
}
```

### Go

**Before:**
```go
func divide(a, b int) int {
    return a / b
}
```

**Prompt:** "add error handling for division by zero"

**After:**
```go
func divide(a, b int) (int, error) {
    if b == 0 {
        return 0, fmt.Errorf("cannot divide by zero")
    }
    return a / b, nil
}
```

### Rust

**Before:**
```rust
fn read_config() -> Config {
    let contents = std::fs::read_to_string("config.toml").unwrap();
    toml::from_str(&contents).unwrap()
}
```

**Prompt:** "use proper Result error handling"

**After:**
```rust
fn read_config() -> Result<Config, Box<dyn std::error::Error>> {
    let contents = std::fs::read_to_string("config.toml")?;
    let config = toml::from_str(&contents)?;
    Ok(config)
}
```

## Advanced Use Cases

### Adding Logging

**Before:**
```python
def process_data(data):
    cleaned = clean_data(data)
    transformed = transform_data(cleaned)
    return validate_data(transformed)
```

**Prompt:** "add logging at each step"

**After:**
```python
def process_data(data):
    logging.info(f"Processing {len(data)} items")
    cleaned = clean_data(data)
    logging.debug(f"Cleaned data: {len(cleaned)} items remaining")
    transformed = transform_data(cleaned)
    logging.debug(f"Transformed data shape: {transformed.shape}")
    result = validate_data(transformed)
    logging.info("Data processing complete")
    return result
```

### Optimizing Performance

**Before:**
```python
def find_duplicates(items):
    duplicates = []
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            if items[i] == items[j]:
                duplicates.append(items[i])
    return duplicates
```

**Prompt:** "optimize using set for O(n) complexity"

**After:**
```python
def find_duplicates(items):
    seen = set()
    duplicates = set()
    for item in items:
        if item in seen:
            duplicates.add(item)
        else:
            seen.add(item)
    return list(duplicates)
```

### Adding Unit Tests

**Before:**
```python
def is_palindrome(s):
    return s == s[::-1]
```

**Prompt:** "generate pytest unit tests"

**After:**
```python
import pytest

def test_is_palindrome_simple():
    assert is_palindrome("racecar") == True
    assert is_palindrome("hello") == False

def test_is_palindrome_empty():
    assert is_palindrome("") == True

def test_is_palindrome_single_char():
    assert is_palindrome("a") == True

def test_is_palindrome_case_sensitive():
    assert is_palindrome("Racecar") == False
```

## Configuration Tips

### For Clean Code Generation

```lua
require("inlinecoder").setup({
  system_prompt = [[You are an expert programmer focused on clean, maintainable code.
Generate ONLY code without explanations.
Follow these principles:
- Use descriptive variable names
- Keep functions small and focused
- Add error handling where appropriate
- Follow language idioms and best practices
- Include type hints where the language supports them
Output raw code only, no markdown formatting.]],
})
```

### For Minimal Output

```lua
require("inlinecoder").setup({
  system_prompt = "Output ONLY executable code. No comments, no explanations, no markdown. Just raw code that can replace the selection.",
  temperature = 0.3, -- Lower temperature for more consistent output
})
```

### For Creative Solutions

```lua
require("inlinecoder").setup({
  temperature = 0.9, -- Higher temperature for more creative solutions
  max_tokens = 4096, -- Allow longer outputs
})
```

## Workflow Tips

1. **Start Small**: Select a small function first to test the model's understanding
2. **Iterate**: If the output isn't perfect, select it and run again with a refined prompt
3. **Use Specific Prompts**: Instead of "improve", say "add input validation and logging"
4. **Context Matters**: Include surrounding code in your selection for better context
5. **Undo is Your Friend**: Press `u` immediately if you don't like the result

## Prompt Templates

Good prompt patterns that work well:

- "add [feature] with [technology/pattern]"
- "refactor to use [pattern/technology]"
- "optimize for [metric]"
- "add [type] error handling"
- "convert to [language/style]"
- "add comprehensive [type] tests"
- "make this more [quality]"
- "extract [component] into separate function"

## Troubleshooting Examples

If the output includes markdown:
```lua
-- Try a more forceful system prompt
system_prompt = "CRITICAL: Return ONLY raw code. Absolutely NO markdown, NO backticks, NO explanations. Pure code only."
```

If the output doesn't follow instructions:
```lua
-- Try a different model or adjust temperature
temperature = 0.2  -- More deterministic
-- Or try a more instruction-focused model in LM Studio
```

If the output is too verbose:
```lua
max_tokens = 1024  -- Limit output length
system_prompt = "Be concise. Generate minimal code that solves the requirement."
```
