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
    }
}

M.setup = function()
    local mason_utils = require("user.mason")
    
    -- Install prettier via Mason
    mason_utils.install("prettier")
    
    -- Helper function for prettier formatting
    local function format_with_prettier()
        local filepath = vim.fn.expand("%:p")
        local prettier_path = vim.fn.stdpath("data") .. "/mason/bin/prettier"
        local output = vim.fn.system({
            prettier_path,
            "--no-config",
            "--prose-wrap", "always",
            "--print-width", "75",
            "--write",
            filepath
        })
        if vim.v.shell_error == 0 then
            vim.cmd("edit!")
        else
            vim.notify("Prettier formatting failed: " .. output, vim.log.levels.ERROR)
        end
    end
    
    -- Set up markdown files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "md" },
        callback = function(args)
            vim.bo.commentstring = "<!-- %s -->"
            
            -- Auto-wrap lines as you type
            vim.bo.textwidth = 75
            vim.bo.formatoptions = "tcqjn"  -- t: auto-wrap text, c: auto-wrap comments, q: allow formatting with gq, j: remove comment leader when joining, n: recognize numbered lists
            
            -- Format with prettier manually
            vim.keymap.set('n', '<leader>lf', format_with_prettier, 
                { buffer = args.buf, desc = "Format markdown with prettier" })
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
            
            -- Format with prettier manually
            vim.keymap.set('n', '<leader>lf', format_with_prettier,
                { buffer = args.buf, desc = "Format mdx with prettier" })
        end,
    })
end

return M
