require("user.types")

---@type Language
local M = {}

M.lsps = {
    {
        mason_name = "lua-language-server",
        lsp_name = "lua_ls",
        config = {
            settings = {
                Lua = {
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            }
        }
    }
}

return M;
