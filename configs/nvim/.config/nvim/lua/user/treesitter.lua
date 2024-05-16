-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
--

require("nvim-treesitter.configs").setup({
	-- Enable autotag plugin
	autotag = {
		enable = true,
	},

	-- Add languages to be installed here that you want installed for treesitter
	ensure_installed = {
		"c",
		"cpp",
		"go",
		"lua",
		"vim",
		"python",
		"rust",
		"typescript",
		"help",
		"css",
		"markdown",
		"markdown_inline",
	},

	modules = {},

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing (or "all")
	ignore_install = {},

	highlight = { enable = true },
	indent = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-space>",
			node_incremental = "<c-space>",
			scope_incremental = "<c-s>",
			node_decremental = "<c-backspace>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["am"] = "@function.outer",
				["im"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["cc"] = "@comment.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = false, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>w"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>w"] = "@parameter.inner",
			},
		},
	},
})

require("nvim-treesitter.install").compilers = { "gcc", "clang" }
require("nvim-treesitter.parsers").get_parser_configs().just = {
	install_info = {
		url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
		files = { "src/parser.c", "src/scanner.cc" },
		branch = "main",
		use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
	},
	maintainers = { "@IndianBoy42" },
}
