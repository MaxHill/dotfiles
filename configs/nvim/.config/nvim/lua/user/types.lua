---@class LspConfig
---@field mason_name? string Name of the LSP package in Mason
---@field lsp_name string Name of the LSP server
---@field config? table LSP configuration table

---@class FormatterConfig
---@field name string The name of the formatter
---@field mason_name? string Name of the formatter package in Mason
---@field options? table Custom options/overrides for the formatter (maps to conform's formatter config)

---@class Language  
---@field lsps? LspConfig[] List of LSP configurations for the language
---@field formatters? FormatterConfig[] List of formatter configurations for the language
---@field filetypes? string[] Filetypes this language applies to (for conform mapping)
---@field setup? function Optional setup function to run for this language
---@field parsers? table Optional treesitter parsers
---@field dap_layout? integer Preferred DAP UI layout (1=console, 2=repl). Defaults to 1 if not specified.
