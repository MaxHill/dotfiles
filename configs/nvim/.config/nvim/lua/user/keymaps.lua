-- Exported
local M = {}

-- Helpers
local nmap = function(keys, func, desc)
	vim.keymap.set('n', keys, func, { desc = desc })
end

local vmap = function(keys, func, desc)
	vim.keymap.set({ "v", "x" }, keys, func, { desc = desc })
end

local nvmap = function(keys, func, desc)
	vim.keymap.set({ "n", "v", "x" }, keys, func, { desc = desc })
end

local ivmap = function(keys, func, desc)
	vim.keymap.set({ "v", "i" }, keys, func, { desc = desc })
end

-- Keymaps
vmap("<leader>ef",
	require("user.extract-file").extract_selection_to_file,
	"Extract current selection to a new file")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
nvmap("<leader>d", '"_d', "Delete without yank")
nvmap("<leader>y", '"+y', "Copy to system clipboard")

vmap("J", ":m '>+1<CR>gv=gv", "Move selected up")
vmap("K", ":m '<-2<CR>gv=gv", "Move selected down")

--nmap("<Leader><space>", ":nohlsearch<cr>", "Remove search highlighting")
nmap("<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace word undeder cursor")
nmap("<C-u>", "<C-u>zz", "Center screen when going up")
nmap("<C-d>", "<C-d>zz", "Center screen when going down")
nmap("n", " nzz", "Center screen when moving through results")
nmap("<C-d>", "<C-d>zz", "Center screen when going down")

-- Netrw
-- nmap("<->", ":Explore<cr>")
-- Close netrw with ctrl+n
-- (This runs in an autocmd user.auto-commands)
-- M.closeNetrwIfOpen = function()
-- 	vim.keymap.set('n', '<c-n>', ":Rexplore<CR>", { buffer = 0, desc = 'LSP: Signature Documentation' })
-- end

-- Snippets
local ls = require "luasnip"
ivmap("<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump();
	end
end, { silent = true })

ivmap("<c-j>", function()
	if ls.jumpable(-1) then
		ls.jump(-1);
	end
end, { silent = true })

ivmap("<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1);
	end
end, { silent = true })

--nmap("<leader>w", "<cmd>source ~/.config/nvim/lua/user/snippets/init.lua")

-- Tmux navigator
nmap("<c-j> ", ":TmuxNavigateDown<CR>")
nmap("<c-k>", ":TmuxNavigateUp<CR>")
nmap("<c-h>", ":TmuxNavigateLeft<CR>")
nmap("<c-l>", ":TmuxNavigateRight<CR>")

-- Harpoon
nmap("<leader>a", require("harpoon.mark").add_file)
nmap("<leader>e", require("harpoon.ui").toggle_quick_menu)

nmap("<leader>h", function() require("harpoon.ui").nav_file(1) end)
nmap("<leader>j", function() require("harpoon.ui").nav_file(2) end)
nmap("<leader>k", function() require("harpoon.ui").nav_file(3) end)
nmap("<leader>l", function() require("harpoon.ui").nav_file(4) end)
nmap("<leader>;", function() require("harpoon.ui").nav_file(5) end)

-- Git Fugitive
nmap("<leader>g", ":G <CR>")
nmap("<leader>gp", ":G push<CR>")

-- Git Worktrees
nmap("<leader>wl", require('telescope').extensions.git_worktree.git_worktrees, "List worktrees")
nmap("<leader>wa", require('telescope').extensions.git_worktree.create_git_worktree, "Create worktree")

-- Telescope
nmap('<leader>?', require('telescope.builtin').oldfiles, '[?] Find recently opened files')
nmap('<leader><space>', require('telescope.builtin').buffers, '[ ] Find existing buffers')
nmap('<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {})
end, '[/] Fuzzily search in current buffer]')

nmap('<leader>sf', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').find_files(require('telescope.themes').get_dropdown {
		hidden = true,
		previewer = false,
	})
end, '[S]earch [F]iles')

nmap('<leader>SF', function()
	require('telescope.builtin').find_files({ hidden = true })
end, '[S]earch [F]iles')
nmap('<leader>sh', require('telescope.builtin').help_tags, '[S]earch [H]elp')
nmap('<leader>sm', require('telescope.builtin').marks, '[S]earch [M]arks')
nvmap('<leader>sw', require('telescope.builtin').grep_string, '[S]earch current [W]ord')
nmap('<leader>sg', require('telescope.builtin').live_grep, '[S]earch by [G]rep')
nmap('<leader>sd', require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics')
nmap('<leader>st', require('telescope.builtin').treesitter, '[S]earch [T]reesitter')

nmap('<leader>sn', function()
	require('telescope.builtin').find_files({ hidden = true, cwd = os.getenv("NOTES_HOME") })
end, '[S]earch [N]otes')

nmap('<leader>sD', function()
	require('telescope.builtin').find_files({ hidden = true, cwd = os.getenv("DOTFILES") })
end, '[S]earch [D]otfiles')

-- Treesitter
-- lua/user/treesitter.lua

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local nmapBuf = function(keys, func, desc)
			if desc then
				desc = 'LSP: ' .. desc
			end

			vim.keymap.set('n', keys, func, { buffer = ev.bufnr, desc = desc })
		end

		nmapBuf('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		nmapBuf('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

		nmapBuf('gd', require("telescope.builtin").lsp_definitions, '[G]oto [D]efinition')
		nmapBuf('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
		nmapBuf('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
		nmapBuf('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
		-- nmapBuf('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
		nmapBuf('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

		nmapBuf("gl", vim.diagnostic.open_float, '[G]et [L]ine diagnostics')
		nmapBuf("<leader>f", vim.diagnostic.goto_prev) -- Was <leader>k before, replaced by harpoo,
		nmapBuf("<leader>d", vim.diagnostic.goto_next)
		nmapBuf("<leader>q", vim.diagnostic.setloclist, 'Add to quickfix list')

		nmapBuf('K', vim.lsp.buf.hover, 'Hover Documentation')
		-- nmapBuf('<C-h>', vim.lsp.buf.signature_help, 'Signature Documentation')
		vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help,
			{ buffer = ev.bufnr, desc = 'LSP: Signature Documentation' })
	end,
})

M.cmp_keymaps = function(cmp, _luasnip)
	return cmp.mapping.preset.insert {
		['<C-d>'] = cmp.mapping.scroll_docs(4),
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-y>'] = cmp.mapping.confirm {
			select = true,
		},
	}
end


return M
