require("user.types")

---@type Language
local M = {}

M.lsps = {
    {
        -- TypeScript LSP for Node.js/Vite/esbuild projects
        mason_name = "typescript-language-server",
        lsp_name = "ts_ls",
        config = {
            single_file_support = false,
            root_markers = { "tsconfig.json", "package.json", "jsconfig.json" },
            root_dir = function(bufnr, on_dir)
                -- Check if this is a Deno project
                local is_deno = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) ~= nil
                if is_deno then
                    -- This is a Deno project, don't use ts_ls
                    return nil
                end
                
                -- Not a Deno project, find Node.js root
                local root = vim.fs.root(bufnr, { "tsconfig.json", "package.json", "jsconfig.json" })
                return root and on_dir(root)
            end,
        }
    },
    {
        -- Deno LSP - only for projects with explicit deno.json
        lsp_name = "denols",
        config = {
            single_file_support = false,
            root_markers = { "deno.json", "deno.jsonc" },
            root_dir = function(bufnr, on_dir)
                -- Only attach if this IS a Deno project
                local is_deno = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" }) ~= nil
                if not is_deno then
                    return nil
                end
                
                -- Find Deno root
                local root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
                return root and on_dir(root)
            end,
        }
    },
    {
        mason_name = "svelte-language-server",
        lsp_name = "svelte"
    }
}

M.filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "svelte" }

M.formatters = {
    {
        name = "deno_fmt",
        options = {
            command = "deno",
            args = { "fmt", "--line-width=100", "--unstable-component", "-" },
            stdin = true,
        }
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
