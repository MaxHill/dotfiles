---@type Language
local M = {}

M.lsps = {
    {
        lsp_name = "ziggy",
        config = {
            cmd = { "ziggy", "lsp" },
            root_dir = vim.loop.cwd(),
            flags = { exit_timeout = 1000 },
        }
    },
    {
        lsp_name = "ziggy_schema",
        config = {
            cmd = { "ziggy", "lsp", "--schema" },
            root_dir = vim.loop.cwd(),
            flags = { exit_timeout = 1000 },
        }
    }
}

M.parsers = {
    ziggy = {
        install_info = {
            url = vim.fn.expand('~/dotfiles/vendor/ziggy'),
            includes = { 'tree-sitter-ziggy/src' },
            files = { 'tree-sitter-ziggy/src/parser.c' },
            branch = 'main',
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
        },
        filetype = 'ziggy',
    },
    ziggy_schema = {
        install_info = {
            url = vim.fn.expand('~/dotfiles/vendor/ziggy'),
            files = { 'tree-sitter-ziggy-schema/src/parser.c' },
            branch = 'main',
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
        },
        filetype = 'ziggy-schema',
    }
}

return M