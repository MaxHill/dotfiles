---@type Language
local M = {}

M.lsps = {
    {
        mason_name = "astro-language-server",
        lsp_name = "astro",
    }
}

M.filetypes = { "astro" }

M.formatters = {
    {
        name = "prettier",
        mason_name = "prettier",
    }
}

return M