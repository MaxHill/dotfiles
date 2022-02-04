local opts = { noremap = true, silent = true }

-- Exported
local M = {}

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

-- Modes
local function all(k, c)
	keymap("n", k, c, opts) --   normal_mode = "n"
	keymap("i", k, c, opts) --   insert_mode = "i"
	keymap("v", k, c, opts) --   visual_mode = "v"
	keymap("x", k, c, opts) --   visual_block_mode = "x"
	keymap("t", k, c, opts) --   term_mode = "t"
	-- keymap("c", k, c, opts) --   command_mode = "c"
end
local function normal(k, c)
	keymap("n", k, c, opts)
end
local function insert(k, c)
	keymap("n", k, c, opts)
end
local function visual(k, c)
	keymap("n", k, c, opts)
end

local function normalBuf(bufnr, k, c)
	vim.api.nvim_buf_set_keymap(bufnr, "n", k, c, opts) -- Doesn't work in a local variable fro some reason
end

--Remap , as leader key
keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Normal mode
-- --------------------------
normal("<Leader><space>", ":nohlsearch<cr>")
normal("<c-j> ", "<c-w>j")
normal("<c-k>", "<c-w>k")
normal("<c-h>", "<c-w>h")
normal("<c-l>", "<c-w>l")

-- telescope
normal(
	"<c-p>",
	"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>"
)
normal("<leader>g", "<cmd>lua require('telescope.builtin').live_grep()<cr>")

-- Nvim-tree
normal("<c-n>", ":NvimTreeToggle<cr>")

-- All modes
-- --------------------------
all("<up>", "<Nop>")
all("<down>", "<Nop>")
all("<left>", "<Nop>")
all("<right>", "<Nop>")

-- LSP

M.lsp_keymaps = function(bufnr)
	normalBuf(bufnr, "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	normalBuf(bufnr, "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	normalBuf(bufnr, "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	normalBuf(bufnr, "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	normalBuf(bufnr, "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	normalBuf(bufnr, "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
	normalBuf(bufnr, "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>')
	normalBuf(bufnr, "gl", '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>')
	normalBuf(bufnr, "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>')
	normalBuf(bufnr, "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>")
	vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

-- CMP
M.cmp_mapping = function(cmp, luasnip, check_backspace)
	return {
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expandable() then
				luasnip.expand()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif check_backspace() then
				fallback()
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	}
end

return M
