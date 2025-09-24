require("user.types")

---@type Language
local M = {}

require("omnisharp_extended")

M.lsps = {
    {
        mason_name = "omnisharp",
        lsp_name = "omnisharp",
        config = {
            cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
            root_markers = { "*.csproj", "*.sln", ".git" },
            filetypes = { "cs" },
            handlers = {
                ["textDocument/definition"] = function(...)
                    return require("omnisharp_extended").definition_handler(...)
                end,
                ["textDocument/typeDefinition"] = function(...)
                    return require("omnisharp_extended").type_definition_handler(...)
                end,
                ["textDocument/references"] = function(...)
                    return require("omnisharp_extended").references_handler(...)
                end,
                ["textDocument/implementation"] = function(...)
                    return require("omnisharp_extended").implementation_handler(...)
                end,
            },
            init_options = {
                useModernNet = true,
            },
            settings = {
                FormattingOptions = {
                    EnableEditorConfigSupport = true,
                    OrganizeImports = true,
                },
                MsBuild = {
                    LoadProjectsOnDemand = false,
                },
                RoslynExtensionsOptions = {
                    EnableAnalyzersSupport = true,
                    EnableImportCompletion = true,
                    AnalyzeOpenDocumentsOnly = false,
                },
                Sdk = {
                    IncludePrereleases = true,
                }
            }
        }
    }
}

return M;
