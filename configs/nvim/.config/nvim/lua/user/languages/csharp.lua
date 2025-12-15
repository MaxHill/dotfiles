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

M.filetypes = { "cs" }

M.formatters = {
    {
        name = "csharpier",
        mason_name = "csharpier",
    }
}

local function find_project_root()
    local current_dir = vim.fn.expand('%:p:h')
    while current_dir ~= '/' do
        if vim.fn.glob(current_dir .. '/*.csproj') ~= '' or vim.fn.glob(current_dir .. '/*.sln') ~= '' then
            return current_dir
        end
        current_dir = vim.fn.fnamemodify(current_dir, ':h')
    end
    return vim.fn.getcwd()  -- fallback to cwd if not found
end

-- DAP keymap override for C# files
vim.api.nvim_create_autocmd("FileType", {
    pattern = "cs",
    callback = function()
        vim.keymap.set("n", "<leader>dc", function()
            local dap = require('dap')
            local cwd = find_project_root()
            local output = {}
            vim.fn.jobstart({"dotnet", "build"}, {
                cwd = cwd,
                on_stdout = function(_, data)
                    if data then
                        for _, line in ipairs(data) do
                            if line ~= "" then table.insert(output, line) end
                        end
                    end
                end,
                on_stderr = function(_, data)
                    if data then
                        for _, line in ipairs(data) do
                            if line ~= "" then table.insert(output, line) end
                        end
                    end
                end,
                on_exit = function(_, code)
                    if code == 0 then
                        dap.continue()
                    else
                        vim.notify("Build failed:\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
                    end
                end
            })
        end, { buffer = true, desc = "Build and continue debugging (C#)" })
    end
})

return M;
