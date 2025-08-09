vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("user.options");

-- -----------------------------
-- Plugins
-- -----------------------------
vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/echasnovski/mini.surround" },
    { src = "https://github.com/echasnovski/mini.comment" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/Saghen/blink.cmp",                 version = '1.*' },
    -- LSP
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/Hoffs/omnisharp-extended-lsp.nvim" },

})
-- vim.pack.update();

-- Find
-- -----------------------------
require "mini.pick".setup()

-- Treesitter
-- -----------------------------
require("nvim-treesitter.configs").setup({
    modules = {},
    ensure_installed = { "lua", "c_sharp" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
    }
})

-- LSP
-- -----------------------------
require("omnisharp_extended")
require("mason").setup()
---@class LspConfig
---@field mason_name? string Name of the LSP package in Mason
---@field lsp_name string Name of the LSP server
---@field config? table LSP configuration table

---@class Language
---@field lsps? LspConfig[] List of LSP configurations for the

---@type Language
local lua = {
    lsps = {
        {
            mason_name = "lua-language-server",
            lsp_name = "lua_ls",
            config = {
                settings = {
                    Lua = {
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true)
                        }
                    }
                }
            }
        }
    }
}

---@type Language
local csharp = {
    lsps = {
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
}

---@type Language[]
local languages = { lua, csharp }

-- Global defaults for all servers
vim.lsp.config('*', {
    -- TODO: Remove csproj & sln here
    root_markers = { '.git', 'package.json', '*.csproj', '*.sln' },
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    on_attach = function(client, bufnr)
        -- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
        -- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
        -- "grr" is mapped in Normal mode to vim.lsp.buf.references()
        -- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
        -- "grt" is mapped in Normal mode to vim.lsp.buf.type_definition()
        -- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
        -- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "[G]et [L]ine diagnostics" })

        -- Show when LSP attaches
        print("LSP attached: " .. client.name)
    end,
})

function mason_install(name)
    if not require("mason-registry").is_installed(name) then
        vim.cmd("MasonInstall " .. name)
    end
end

-- Install and configure each language
-- TODO: Make defensive
for _, language in pairs(languages) do
    if type(language.lsps) == "table" then
        for _, lsp in pairs(language.lsps) or {} do
            if lsp.config then
                vim.lsp.config(lsp.lsp_name, lsp.config)
            end

            if lsp.mason_name then
                mason_install(lsp.mason_name)
            end

            vim.lsp.enable(lsp.lsp_name)
        end
    end
end

-- Completion
-- -----------------------------
require('blink.cmp').setup({
    keymap = {
        preset = 'default',
        -- Override any conflicting keymaps
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<C-y>'] = { 'select_and_accept' },
    },
    appearance = {
        use_nvim_cmp_as_default = false, -- Don't use nvim-cmp styling
    },
    completion = {
        accept = {
            auto_brackets = {
                enabled = true,
            },
        },
        menu = {
            draw = {
                treesitter = { "lsp" },
            },
        },
    },
})

-- Disable built-in completion sources
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.complete = ''

-- Disable omnifunc for all filetypes
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt_local.omnifunc = ""
    end,
})

-- Colors
-- -----------------------------
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- -----------------------------
-- Keymaps
-- -----------------------------
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')

-- Copy/cut
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d', { desc = "Delete to system clipboard" })

-- Move text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected down" })

-- Replace
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word undeder cursor" })

-- Screen moving
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center screen when going up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center screen when going down" })
vim.keymap.set("n", "n", " nzz", { desc = "Center screen when moving through results" })

-- Lsp
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

local pick = require('mini.pick')
vim.keymap.set('n', '<leader>sf', pick.builtin.files, { desc = "[S]earch [F]iles" })
vim.keymap.set('n', '<leader>sh', pick.builtin.help, { desc = "[S]earch [H]elp" })
vim.keymap.set('n', '<leader>sg', pick.builtin.grep_live, { desc = "[S]earch [G]rep" })
