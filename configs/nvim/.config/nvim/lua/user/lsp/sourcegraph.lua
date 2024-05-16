local M = {}

M.setup = function(on_attach, capabilities)
	-- Sourcegraph configuration. All keys are optional
	require("sg").setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

return M
