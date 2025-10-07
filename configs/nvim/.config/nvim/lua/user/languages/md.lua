---@type Language
local M = {}

M.parsers = {
    supermd = {
        install_info = {
            url = vim.fn.expand('~/dotfiles/vendor/supermd'),
            includes = { 'tree-sitter/supermd/src' },
            files = {
                'tree-sitter/supermd/src/parser.c',
                'tree-sitter/supermd/src/scanner.c'
            },
            branch = 'main',
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
        },
        filetype = 'supermd',
    },
    supermd_inline = {
        install_info = {
            url = vim.fn.expand('~/dotfiles/vendor/supermd'),
            includes = { 'tree-sitter/supermd-inline/src' },
            files = {
                'tree-sitter/supermd-inline/src/parser.c',
                'tree-sitter/supermd-inline/src/scanner.c'
            },
            branch = 'main',
            generate_requires_npm = false,
            requires_generate_from_grammar = false,
        },
        filetype = 'supermd_inline',
    }
}

return M