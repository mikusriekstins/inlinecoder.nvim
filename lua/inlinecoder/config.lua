local M = {}

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
  max_tokens = 8192,

  context = {
    enabled = true,
    max_lines = 150,
    max_tokens_estimate = 600,

    include = {
      functions = true,
      classes = true,
      methods = true,
      types = true,
      imports = true,
      variables = false,
      comments = false,
    },

    prioritize_nearby = true,
    nearby_lines = 50,
    fallback_on_error = true,
    show_context_errors = false,
  },
}

M.options = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
  return M.options
end

function M.get()
  return M.options
end

return M
