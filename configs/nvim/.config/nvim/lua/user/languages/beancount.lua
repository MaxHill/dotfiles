require("user.types")

---@type Language
local M = {}

M.lsps = {
    {
        mason_name = "beancount-language-server",
        lsp_name = "beancount",
        config = {
            filetypes = { "beancount" },
            root_markers = { "main.beancount", "main.bean", ".git" },
        }
    }
}

M.filetypes = { "beancount" }

M.formatters = {
    {
        name = "bh",  -- beanhub-cli formatter command
        mason_name = "beanhub-cli",
    }
}

return M
