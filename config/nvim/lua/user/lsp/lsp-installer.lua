-- local nvim_lsp = require("lspconfig")
-- local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
-- if not status_ok then
--   return
-- end
--
-- -- Register a handler that will be called for all installed servers.
-- -- Alternatively, you may also register handlers on specific server instances instead (see example below).
-- lsp_installer.on_server_ready(function(server)
--   local opts = {
--     on_attach = require("user.lsp.handlers").on_attach,
--     capabilities = require("user.lsp.handlers").capabilities,
--   }
--
--   if server.name == "jsonls" then
--     local jsonls_opts = require("user.lsp.settings.jsonls")
--     opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
--   end
--
--   if server.name == "fsautocomplete" then
--     opts.cmd = { "/Users/maxhill/.dotnet/tools/fsautocomplete", "--background-service-enabled" }
--   end
--
--   if server.name == "tsserver" then
--     opts.root_dir = nvim_lsp.util.root_pattern("package.json")
--   end
--
--   if server.name == "ionide" then
--     print("hello from ionide")
--     opts.single_file_support = true
--   end
--
--   if server.name == "sumneko_lua" then
--     local sumneko_opts = require("user.lsp.settings.sumneko-lua")
--     opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
--   end
--
--   -- This setup() function is exactly the same as lspconfig's setup function.
--   -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
--   server:setup(opts)
-- end)
--

local nvim_lsp = require("lspconfig")
local on_attach = require("user.lsp.handlers").on_attach
local capabilities = require("user.lsp.handlers").capabilities

nvim_lsp.sumneko_lua.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.fsautocomplete.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/Users/maxhill/.dotnet/tools/fsautocomplete", "--background-service-enabled" },
})

nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	root_dir = nvim_lsp.util.root_pattern("package.json"),
})

nvim_lsp.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.tailwindcss.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.astro.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.emmet_ls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})
