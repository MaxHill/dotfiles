local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
	debug = false,
	sources = {
		-- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }), -- TODO: Change to use eslint
		diagnostics.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
		formatting.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
		code_actions.eslint_d.with({
			prefer_local = "node_modules/.bin",
		}),
		formatting.stylua,
	},
})
