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

M.setup = function()
    local mason_utils = require("user.mason")
    mason_utils.install("js-debug-adapter")
    
    local dap = require("dap")
    
    dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = {
                vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
                "${port}"
            },
        }
    }

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact", "astro" }) do
        dap.configurations[language] = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Astro Dev Server",
                runtimeExecutable = "${workspaceFolder}/node_modules/.bin/astro",
                runtimeArgs = {"dev"},
                rootPath = "${workspaceFolder}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
            },
        }
    end
end

return M;
