local M = {}
local config = require("inlinecoder.config")

local function strip_markdown(text)
  if not text then return text end

  -- Remove markdown code blocks with language specifier: ```language\n...\n```
  text = text:gsub("```%w*\n(.-)```", "%1")

  -- Remove markdown code blocks without language: ```\n...\n```
  text = text:gsub("```\n(.-)```", "%1")

  -- Remove inline code blocks at start/end: ```...```
  text = text:gsub("^```(.-)```$", "%1")

  -- Trim leading/trailing whitespace
  text = text:gsub("^%s+", ""):gsub("%s+$", "")

  return text
end

function M.call_lm_studio(selected_code, user_prompt, context_data, callback)
  local cfg = config.get()

  local messages = {
    {
      role = "system",
      content = cfg.system_prompt
    }
  }

  if context_data and context_data.context_text and context_data.context_text ~= "" then
    table.insert(messages, {
      role = "system",
      content = context_data.context_text
    })
  end

  table.insert(messages, {
    role = "user",
    content = string.format("Replace this code:\n```\n%s\n```\n\nWith: %s", selected_code, user_prompt)
  })

  local payload = {
    messages = messages,
    temperature = cfg.temperature,
    max_tokens = cfg.max_tokens,
    stream = false
  }

  if cfg.model then
    payload.model = cfg.model
  end

  local ok, curl = pcall(require, "plenary.curl")
  if not ok then
    callback(nil, "plenary.nvim not found. Please install it first.")
    return
  end

  curl.post(cfg.api_url, {
    body = vim.fn.json_encode(payload),
    headers = {
      ["Content-Type"] = "application/json",
    },
    timeout = 30000,
    callback = vim.schedule_wrap(function(response)
      if not response then
        callback(nil, "No response from LM Studio. Is it running?")
        return
      end

      if response.status ~= 200 then
        local error_msg = string.format("LM Studio error (HTTP %d): %s",
          response.status,
          response.body or "Unknown error")
        callback(nil, error_msg)
        return
      end

      local ok_decode, result = pcall(vim.fn.json_decode, response.body)
      if not ok_decode then
        callback(nil, "Invalid JSON response from LM Studio")
        return
      end

      if not result.choices or not result.choices[1] or not result.choices[1].message then
        callback(nil, "Unexpected response format from LM Studio")
        return
      end

      local generated_code = result.choices[1].message.content

      if not generated_code or generated_code == "" then
        callback(nil, "LM Studio returned empty code")
        return
      end

      generated_code = strip_markdown(generated_code)

      if not generated_code or generated_code == "" then
        callback(nil, "LM Studio returned empty code after cleaning")
        return
      end

      callback(generated_code, nil)
    end),
    on_error = vim.schedule_wrap(function(err)
      local error_msg = string.format("Connection error: %s. Is LM Studio running at %s?",
        tostring(err),
        cfg.api_url)
      callback(nil, error_msg)
    end)
  })
end

return M
