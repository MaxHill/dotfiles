vim.g.mapleader = " "
vim.g.maplocalleader = " "
require("user.options")
require("user.types")

-- -----------------------------
-- Plugins
-- -----------------------------
vim.pack.add({
	{ src = "https://github.com/tahayvr/matteblack.nvim" },
	{ src = "https://github.com/echasnovski/mini.surround" },
	{ src = "https://github.com/echasnovski/mini.comment" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/danymat/neogen" },
	-- LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/Hoffs/omnisharp-extended-lsp.nvim" },
	-- Formatting
	{ src = "https://github.com/stevearc/conform.nvim" },
	-- DAP
	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/igorlfs/nvim-dap-view" },
	-- Dependencies
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	-- Telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	-- Harpoon 2
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	-- Tmux navigation
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
})
-- local packages
vim.cmd.packadd("netcoredbg-macOS-arm64.nvim") -- Vendored version with improvements
-- vim.pack.update();

-- Mini
require("mini.comment").setup()
require("mini.surround").setup({
	mappings = {
		replace = "sc", -- Replace surrounding, originally sr
	},
})

-- Neogen (documentation generator)
require("neogen").setup({
	enabled = true,
	languages = {
		typescript = {
			template = {
				annotation_convention = "jsdoc",
			},
		},
		javascript = {
			template = {
				annotation_convention = "jsdoc",
			},
		},
	},
})

vim.keymap.set("n", "<leader>dg", require("neogen").generate, { desc = "Generate documentation" })

-- Harpoon 2
local harpoon = require("harpoon")
harpoon:setup({})

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Add file to Harpoon" })
vim.keymap.set("n", "<leader>e", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)
vim.keymap.set("n", "<leader>h", function()
	harpoon:list():select(1)
end, { desc = "Select Harpoon item 1" })
vim.keymap.set("n", "<leader>j", function()
	harpoon:list():select(2)
end, { desc = "Select Harpoon item 2" })
vim.keymap.set("n", "<leader>k", function()
	harpoon:list():select(3)
end, { desc = "Select Harpoon item 3" })
vim.keymap.set("n", "<leader>l", function()
	harpoon:list():select(4)
end, { desc = "Select Harpoon item 4" })

-- Replace at specific harpoon positions
vim.keymap.set("n", "<leader>ah", function()
	harpoon:list():replace_at(1)
end, { desc = "Replace Harpoon item 1" })
vim.keymap.set("n", "<leader>aj", function()
	harpoon:list():replace_at(2)
end, { desc = "Replace Harpoon item 2" })
vim.keymap.set("n", "<leader>ak", function()
	harpoon:list():replace_at(3)
end, { desc = "Replace Harpoon item 3" })
vim.keymap.set("n", "<leader>al", function()
	harpoon:list():replace_at(4)
end, { desc = "Replace Harpoon item 4" })

-- Find
-- -----------------------------
require("telescope").setup({
	defaults = {
		-- Add any custom defaults here
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
	},
})
require("telescope").load_extension("fzf") -- Uncomment after building fzf-native

---@type Language[]
local languages = {
	require("user.languages.lua"),
	require("user.languages.csharp"),
	require("user.languages.go"),
	require("user.languages.typescript"),
	require("user.languages.astro"),
	require("user.languages.css"),
	require("user.languages.zig"),
	require("user.languages.ziggy"),
	require("user.languages.html"),
	require("user.languages.md"),
	require("user.languages.beancount"),
}

-- Setup languages
for _, language in pairs(languages) do
	if type(language.setup) == "function" then
		language.setup()
	end
end

-- Mason (needed for both LSP and formatters)
-- -----------------------------
require("mason").setup()
local mason_utils = require("user.mason")

-- Conform (Formatting)
-- -----------------------------
local conform = require("conform")

-- Build formatters_by_ft from language configs
local formatters_by_ft = {}
local custom_formatters = {}
local formatters_to_install = {} -- Set of unique formatter packages to install

for _, language in pairs(languages) do
	if type(language.formatters) == "table" and type(language.filetypes) == "table" then
		-- Collect unique formatters to install
		for _, formatter_config in ipairs(language.formatters) do
			if formatter_config.mason_name then
				formatters_to_install[formatter_config.mason_name] = true
			end

			-- Store custom formatter options
			if formatter_config.options then
				custom_formatters[formatter_config.name] = formatter_config.options
			end
		end

		-- Map formatters to filetypes
		local formatter_names = {}
		for _, formatter_config in ipairs(language.formatters) do
			table.insert(formatter_names, formatter_config.name)
		end

		for _, filetype in ipairs(language.filetypes) do
			formatters_by_ft[filetype] = formatter_names
		end
	end
end

-- Install unique formatters via Mason
for formatter_name, _ in pairs(formatters_to_install) do
	mason_utils.install(formatter_name)
end

conform.setup({
	formatters_by_ft = formatters_by_ft,
	formatters = custom_formatters,
	format_on_save = {
		timeout_ms = 1000,
		lsp_format = "fallback", -- Use LSP formatting as fallback
	},
	notify_on_error = true,
	notify_no_formatters = false, -- Less noisy for languages without formatters
})

-- Treesitter
-- -----------------------------
require("nvim-treesitter.configs").setup({
	modules = {},
	ensure_installed = {
		"lua",
		"c_sharp",
		"zig",
		"ziggy",
		"ziggy_schema",
		"superhtml",
		"astro",
		"markdown",
		"markdown_inline",
		"jsdoc",
	},
	sync_install = false,
	auto_install = true,
	ignore_install = {},
	highlight = {
		enable = true,
	},
})

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

-- Install and configure each language's parsers
for _, language in pairs(languages) do
	if type(language.parsers) == "table" then
		for name, config in pairs(language.parsers) do
			parser_config[name] = config
		end
	end
end

vim.filetype.add({
	extension = {
		mdx = "mdx",
		shtml = "superhtml",
		ziggy = "ziggy",
		["ziggy-schema"] = "ziggy_schema",
		zon = "zon",
		beancount = "beancount",
		bean = "beancount",
	},
})

-- LSP
-- -----------------------------
-- Global defaults for all servers
function on_attach(client, bufnr)
	-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
	-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
	-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
	-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
	-- "grt" is mapped in Normal mode to vim.lsp.buf.type_definition()
	-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
	-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code action" })
	vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "[G]et [L]ine diagnostics" })

	-- Show when LSP attaches
	print("LSP attached: " .. client.name)
end

vim.lsp.config("*", {
	root_markers = { ".git", "package.json" },
	capabilities = (function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
		return capabilities
	end)(),
	on_attach = on_attach,
})

-- Install and configure each language
for _, language in pairs(languages) do
	if type(language.lsps) == "table" then
		for _, lsp in pairs(language.lsps) do
			if lsp.config then
				lsp.config.on_attach = on_attach
				vim.lsp.config(lsp.lsp_name, lsp.config)
			else
				vim.lsp.config(lsp.lsp_name, { on_attach = on_attach })
			end

			if lsp.mason_name then
				mason_utils.install(lsp.mason_name)
			end

			vim.lsp.enable(lsp.lsp_name)
		end
	end
end

-- Completion
-- -----------------------------
require("blink.cmp").setup({
	keymap = {
		preset = "default",
		-- Override any conflicting keymaps
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
		["<C-y>"] = { "select_and_accept" },
	},
	appearance = {
		use_nvim_cmp_as_default = false, -- Don't use nvim-cmp styling
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		menu = {
			draw = {
				treesitter = { "lsp" },
			},
		},
	},
	fuzzy = {
		prebuilt_binaries = {
			force_version = "v1.6.0", -- specify exact version here
		},
	},
})

-- Disable built-in completion sources
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.complete = ""
vim.opt.shortmess:append("c")

-- Disable omnifunc for all filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.omnifunc = ""
	end,
})

-- Dap
-- -----------------------------
local dap = require("dap")
local dap_view = require("dap-view")
dap_view.setup({
	windows = {
		terminal = {
			hide = { "coreclr" }, -- Don't hide for any adapters
		},
	},
})

dap.defaults.fallback.external_terminal = {
	command = "/usr/bin/open",
	args = { "-a", "Terminal" },
}

dap.listeners.before.attach.dapui_config = function()
	dap_view.open()
end
dap.listeners.before.launch.dapui_config = function()
	dap_view.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dap_view.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dap_view.close()
end

vim.keymap.set("n", "<leader>du", function()
	dap_view.toggle()
end)
vim.keymap.set("n", "<space>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_over)
vim.keymap.set("n", "<space>dC", dap.run_to_cursor)
vim.keymap.set("n", "<space>dT", dap.terminate)

vim.keymap.set("n", "<leader>dw", function()
	dap_view.add_expr(vim.fn.expand("<cword>"))
end)

vim.keymap.set("n", "<leader>df", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.api.nvim_buf_get_option(buf, "filetype")
		if ft == "dap-view" then
			local current_height = vim.api.nvim_win_get_height(win)
			local max_height = vim.o.lines - 2
			if current_height >= max_height - 5 then
				vim.cmd("wincmd =")
			else
				vim.api.nvim_win_set_height(win, max_height)
			end
			return
		end
	end
end)

require("netcoredbg-macOS-arm64").setup(require("dap"))

-- Snippets
-- -----------------------------
local ls = require("luasnip")
ls.setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets/" } })

vim.keymap.set({ "i", "s" }, "<C-k>", function()
	print("LuaSnip keymap triggered!")
	if ls.expand_or_jumpable() then
		print("Expanding...")
		ls.expand_or_jump()
	else
		print("Nothing to expand")
	end
end, { desc = "Expand snippet" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end, { silent = true })

-- Navigate choices
vim.keymap.set({ "i", "s" }, "<C-c>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })

-- Colors
-- -----------------------------
vim.cmd.packadd("matteblack.nvim")
require("matteblack").colorscheme()

vim.cmd(":hi statusline guibg=NONE")

-- -----------------------------
-- Keymaps
-- -----------------------------
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")

-- Copy/cut
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d', { desc = "Delete to system clipboard" })

-- Move text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected down" })

-- Replace
vim.keymap.set(
	"n",
	"<leader>rw",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word undeder cursor" }
)

-- Screen moving
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center screen when going up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center screen when going down" })
vim.keymap.set("n", "n", " nzz", { desc = "Center screen when moving through results" })

vim.keymap.set("n", "-", ":Ex<CR>", { desc = "Center screen when moving through results" })

-- Lsp
vim.keymap.set("n", "<leader>lf", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format buffer" })

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", telescope.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", telescope.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sg", telescope.live_grep, { desc = "[S]earch [G]rep" })
vim.keymap.set("n", "<leader>sp", telescope.builtin, { desc = "[S]earch [P]ickers" })
vim.keymap.set("n", "<leader>/", telescope.lsp_document_symbols, { desc = "Search symbols in current file" })
vim.keymap.set("n", "<leader>sd", function()
	telescope.find_files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "[S]earch [D]irectory of current file" })

--  ------------------------------------------------------------------------
--  Autocommands
--  ------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight yanked selection
local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 70,
		})
	end,
})
