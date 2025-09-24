require("user.types")

---@type Language
local M = {}

M.lsps = {
    {
        mason_name = "css-lsp",
        lsp_name = "cssls"
    },
    {
        mason_name = "css-variables-language-server",
        lsp_name = "css_variables"
    }
}

return M;
