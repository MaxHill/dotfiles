vim.g.mapleader = " "

vim.o.number = true -- Show line numbers
vim.o.relativenumber = true -- Make line numbers relative

vim.o.hlsearch = false -- Don't highlight search
vim.o.incsearch = true -- Show search matches live during type

vim.o.inccommand = "split" -- Show command and replace inline

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true 
vim.o.smartcase = true


vim.o.colorcolumn = "81" -- Highlight to column to see 80 char mark

-- indent with 4 tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false -- Don't wrap lines

vim.o.laststatus = 2 -- 1: Show statusline only if multiple files open, 2: always show statuslin, 3: Use 1 global statusline for all splits
vim.g.netrw_banner = 0 -- Don't show netrw header
vim.g.netrw_browse_split = 0 -- Don't use split for netrw
vim.opt.scrolloff = 15 -- Keep 8 lines on top when scrolling up / down

vim.o.swapfile = false -- Don't use swap files
vim.opt.backup = false -- Don't backup with swap files
vim.opt.undodir = os.getenv "HOME" .. "/.vim/undodir" -- Save undo history here
vim.opt.undofile = true -- Save undo history
vim.opt.termguicolors = true -- Better color support
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"


