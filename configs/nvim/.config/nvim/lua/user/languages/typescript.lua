require("user.types")

---@type Language
local M = {}

M.lsps = {
    {
        mason_name = "typescript-language-server",
        lsp_name = "ts_ls",
    },
    {
        mason_name = "svelte-language-server",
        lsp_name = "svelte"
    }
}

return M;
