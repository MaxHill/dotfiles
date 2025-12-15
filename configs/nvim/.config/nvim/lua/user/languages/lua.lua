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

M.filetypes = { "lua" }

M.formatters = {
    {
        name = "stylua",
        mason_name = "stylua",
    }
}

return M;
