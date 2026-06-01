---@type Language
local M = {}

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
    -- Markdown preview configuration
    vim.g.mkdp_auto_start = 0  -- Don't auto-start preview
    vim.g.mkdp_auto_close = 1  -- Auto-close preview when switching buffers
    vim.g.mkdp_refresh_slow = 0  -- Refresh on save or leaving insert mode (0 = real-time)
    vim.g.mkdp_theme = 'dark'  -- Use dark theme
    vim.g.mkdp_port = '8080'  -- Server port
    vim.g.mkdp_echo_preview_url = 1  -- Echo preview URL in command line
    
    -- Custom function to open browser on macOS
    vim.g.mkdp_browserfunc = 'g:OpenMarkdownPreview'
    
    -- Define the browser opening function (opens in Safari)
    vim.cmd([[
        function! g:OpenMarkdownPreview(url)
            execute 'silent !open -a Safari ' . shellescape(a:url) . ' &'
            redraw!
        endfunction
    ]])
    
    -- Set up markdown files
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "md" },
        callback = function(args)
            vim.bo.commentstring = "<!-- %s -->"
            
            -- Auto-wrap lines as you type
            vim.bo.textwidth = 75
            vim.bo.formatoptions = "tcqjn"  -- t: auto-wrap text, c: auto-wrap comments, q: allow formatting with gq, j: remove comment leader when joining, n: recognize numbered lists
            
            -- Markdown preview keymap
            vim.keymap.set("n", "<leader>x", ":MarkdownPreviewToggle<CR>", { buffer = true, desc = "Toggle markdown preview" })
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
            
            -- Markdown preview keymap (also available for mdx)
            vim.keymap.set("n", "<leader>x", ":MarkdownPreviewToggle<CR>", { buffer = true, desc = "Toggle markdown preview" })
        end,
    })
end

return M
