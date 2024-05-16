require("conform").setup({
	formatters_by_ft = {
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		sql = { "sql-formatter" },
		json = { "jq" },
		css = { "stylint" },
		javascript = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		["*"] = { "injected" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	options = {
		lang_to_ext = {
			bash = "sh",
			c_sharp = "cs",
			elixir = "exs",
			javascript = "js",
			typescript = "ts",
			julia = "jl",
			latex = "tex",
			markdown = "md",
			python = "py",
			ruby = "rb",
			rust = "rs",
			go = "go",
			teal = "tl",
		},
		-- Map of treesitter language to formatters to use
		-- (defaults to the value from formatters_by_ft)
		lang_to_formatters = {},
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
