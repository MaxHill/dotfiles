-- [[ Setting options ]]
-- See `:help vim.o`

--Remap [space] as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

vim.o.showmode = true -- Always show what mode we're currently editing in

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true -- Use hybrid line numbers

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 100
vim.wo.signcolumn = 'yes'

vim.o.colorcolumn = "81" -- Highlight to column to see 80 char mark

-- indent with 4 tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false -- Don't wrap lines
vim.o.laststatus = 3 -- Use 1 global statusline for all splits
vim.g.netrw_banner = 0 -- Don't show netrw header
vim.g.netrw_browse_split = 0 -- Don't use split for netrw
vim.opt.termguicolors = true -- Better color support
vim.opt.scrolloff = 8 -- Keep 8 lines on top when scrolling up / down

vim.opt.swapfile = false -- Don't use swap files
vim.opt.backup = false -- Don't backup with swap files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Save undo history here
vim.opt.undofile = true -- Do save undo history


