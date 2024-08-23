local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Format on save
-- local format_on_save_group = augroup("FormatOnSave", {})
-- autocmd("BufWritePre", {
-- 	group = format_on_save_group,
-- 	pattern = "*",
-- 	callback = require('user.lsp').LspFormatBuffer,
-- })

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

--
-- Close netrw with ctrl+n
-- local netrw_group = augroup("netrwGroup", {})
-- autocmd("FileType", {
-- 	group = netrw_group,
-- 	pattern = "netrw",
-- 	callback = require("user.keymaps").closeNetrwIfOpen,
-- })
