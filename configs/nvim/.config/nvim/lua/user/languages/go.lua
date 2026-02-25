require("user.types")

---@type Language
local M = {}

-- Prefer REPL layout for Go debugging
M.dap_layout = 2

M.lsps = {
    {
        mason_name = "gopls",
        lsp_name = "gopls",
    }
}

M.filetypes = { "go" }

M.formatters = {
    {
        name = "gofmt",
        -- gofmt is bundled with Go, no Mason package needed
    }
}

return M
