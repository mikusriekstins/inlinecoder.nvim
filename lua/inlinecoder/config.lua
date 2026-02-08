-- Configuration management for inlinecoder
local M = {}

-- Default configuration
M.defaults = {
  api_url = "http://localhost:1234/v1/chat/completions",
  system_prompt = [[You are a code generation assistant. Your output must be ONLY raw code that can directly replace the selected text.

CRITICAL RULES:
- NO markdown formatting (no ```, no backticks)
- NO explanations or descriptions
- NO comments unless specifically requested
- NO language tags or labels
- ONLY output the exact code that should replace the selection

Return pure, executable code and nothing else.]],
  model = nil, -- Auto-detect from LM Studio
  temperature = 0.7,
  max_tokens = 2048,
}

-- Current configuration (will be set by setup)
M.current = vim.deepcopy(M.defaults)

-- Merge user configuration with defaults
function M.setup(opts)
  M.current = vim.tbl_deep_extend("force", M.defaults, opts or {})
  return M.current
end

-- Get current configuration
function M.get()
  return M.current
end

return M
