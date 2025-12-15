---@type Language
local M = {}

M.parsers = {
    mdx = {
        install_info = {
            url = "https://github.com/pynappo/tree-sitter-mdx",
            files = { "src/parser.c", "src/scanner.c" },
            branch = "main",
        },
        filetype = "mdx",
    }
}

M.lsps = {
    {
        mason_name = "marksman",
        lsp_name = "marksman",
        config = {
            filetypes = { "markdown", "md", "mdx" }
        }
    },
    {
        lsp_name = "ts_ls",  -- For mdx JSX support
    },
    {
        mason_name = "vale-ls",
        lsp_name = "vale_ls",
        config = {
            filetypes = { "markdown", "md", "mdx" }
        }
    }
}

M.filetypes = { "markdown", "md", "mdx" }

M.formatters = {
    {
        name = "prettier",
        mason_name = "prettier",
        options = {
            prepend_args = { "--prose-wrap", "always", "--print-width", "75" }
        }
    }
}

M.setup = function()
    -- Set up markdown files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "md" },
        callback = function(args)
            vim.bo.commentstring = "<!-- %s -->"
            
            -- Auto-wrap lines as you type
            vim.bo.textwidth = 75
            vim.bo.formatoptions = "tcqjn"  -- t: auto-wrap text, c: auto-wrap comments, q: allow formatting with gq, j: remove comment leader when joining, n: recognize numbered lists
        end,
    })
    
    -- Set up mdx files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "mdx",
        callback = function(args)
            vim.bo.commentstring = "{/* %s */}"
            vim.treesitter.language.register("markdown", "mdx")
            
            -- Auto-wrap lines as you type
            vim.bo.textwidth = 75
            vim.bo.formatoptions = "tcqjn"
        end,
    })
end

return M
