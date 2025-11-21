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
        lsp_name = "ts_ls",
    }
}

M.setup = function()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "mdx",
        callback = function()
            vim.bo.commentstring = "{/* %s */}"
            vim.treesitter.language.register("markdown", "mdx")
        end,
    })
end

return M
