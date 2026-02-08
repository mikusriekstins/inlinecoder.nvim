local M = {}

M.language_queries = {
  javascript = {
    functions = [[
      (function_declaration
        name: (identifier) @function.name) @function.definition

      (variable_declarator
        name: (identifier) @function.name
        value: (arrow_function)) @function.definition

      (variable_declarator
        name: (identifier) @function.name
        value: (function_expression)) @function.definition

      (method_definition
        name: (property_identifier) @method.name) @method.definition
    ]],

    classes = [[
      (class_declaration
        name: (identifier) @class.name) @class.definition
    ]],

    imports = [[
      (import_statement) @import
    ]],

    exports = [[
      (export_statement) @export
    ]],
  },

  typescript = {
    functions = [[
      (function_declaration
        name: (identifier) @function.name) @function.definition

      (variable_declarator
        name: (identifier) @function.name
        value: (arrow_function)) @function.definition

      (variable_declarator
        name: (identifier) @function.name
        value: (function_expression)) @function.definition

      (method_definition
        name: (property_identifier) @method.name) @method.definition
    ]],

    classes = [[
      (class_declaration
        name: (identifier) @class.name) @class.definition
    ]],

    imports = [[
      (import_statement) @import
    ]],

    exports = [[
      (export_statement) @export
    ]],

    types = [[
      (type_alias_declaration
        name: (type_identifier) @type.name) @type.definition

      (interface_declaration
        name: (type_identifier) @interface.name) @interface.definition
    ]],
  },

  python = {
    functions = [[
      (function_definition
        name: (identifier) @function.name) @function.definition
    ]],

    classes = [[
      (class_definition
        name: (identifier) @class.name) @class.definition
    ]],

    imports = [[
      (import_statement) @import
      (import_from_statement) @import
    ]],
  },

  lua = {
    functions = [[
      (function_declaration
        name: (identifier) @function.name) @function.definition

      (assignment_statement
        (variable_list
          name: (identifier) @function.name)
        (expression_list
          value: (function_definition))) @function.definition
    ]],

    imports = [[
      (function_call
        name: (identifier) @_require (#eq? @_require "require")
        arguments: (arguments (string) @module)) @require
    ]],
  },
}

-- JSX and TSX use the same queries as their base languages
M.language_queries.javascriptreact = M.language_queries.javascript
M.language_queries.typescriptreact = M.language_queries.typescript

-- Get queries for a specific language and context type
-- @param lang string: Language name (e.g., "javascript", "python")
-- @param context_type string: Type of context (e.g., "functions", "classes")
-- @return string|nil: Query string or nil if not found
function M.get_query(lang, context_type)
  local lang_queries = M.language_queries[lang]
  if not lang_queries then
    return nil
  end
  return lang_queries[context_type]
end

-- Get all available context types for a language
-- @param lang string: Language name
-- @return table: List of available context types
function M.get_available_types(lang)
  local lang_queries = M.language_queries[lang]
  if not lang_queries then
    return {}
  end

  local types = {}
  for context_type, _ in pairs(lang_queries) do
    table.insert(types, context_type)
  end
  return types
end

-- Check if a language is supported
-- @param lang string: Language name
-- @return boolean: True if language has queries defined
function M.is_supported(lang)
  return M.language_queries[lang] ~= nil
end

return M
