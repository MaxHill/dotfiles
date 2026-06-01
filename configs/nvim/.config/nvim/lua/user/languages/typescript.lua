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
                local file_path = vim.api.nvim_buf_get_name(bufnr)
                
                -- Check if this is a Deno project
                local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
                
                if deno_root then
                    -- In a project with deno.json - check if file is in build/ or is a build script
                    local rel_path = file_path:sub(#deno_root + 2) -- +2 to skip the trailing slash
                    local is_build_file = rel_path:match("^build/") or rel_path == "dev.ts" or rel_path == "build.ts"
                    
                    if is_build_file then
                        -- This is a Deno build file, don't use ts_ls
                        return nil
                    end
                end
                
                -- Not a Deno file, find Node.js root
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
                local file_path = vim.api.nvim_buf_get_name(bufnr)
                
                -- Find Deno root
                local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
                if not deno_root then
                    return nil
                end
                
                -- Only attach to build scripts (build/, dev.ts, build.ts)
                local rel_path = file_path:sub(#deno_root + 2) -- +2 to skip the trailing slash
                local is_build_file = rel_path:match("^build/") or rel_path == "dev.ts" or rel_path == "build.ts"
                
                if not is_build_file then
                    -- Not a Deno build file, don't use denols
                    return nil
                end
                
                return on_dir(deno_root)
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
