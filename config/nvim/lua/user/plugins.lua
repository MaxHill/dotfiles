local cmd = vim.cmd
local fn = vim.fn

local plugLoad = fn["functions#PlugLoad"]
local plugInstallMissing = fn["functions#PlugInstallMissing"]
local plugBegin = fn["plug#begin"]
local plugEnd = fn["plug#end"]

plugLoad()
plugInstallMissing()
plugBegin("~/.config/nvim/plugged")

-- NOTE: the argument passed to Plug has to be wrapped with single-quotes

cmd([[Plug 'nvim-lua/plenary.nvim']]) -- Useful lua functions used ny lots of plugins
cmd([[Plug 'nvim-lua/popup.nvim']]) -- An implementation of the Popup API from vim in Neovim
--cmd([[Plug 'windwp/nvim-autopairs']]) -- Automatically pair (), "" end more
cmd([[Plug 'nvim-telescope/telescope.nvim']]) -- Fuzzy finder
-- cmd([[Plug 'kyazdani42/nvim-tree.lua']]) -- Tree explorer (replaces nerdtree)
cmd([[Plug 'kyazdani42/nvim-web-devicons']]) -- Icons for nvim-tree
cmd([[Plug 'windwp/nvim-ts-autotag']]) -- Automatically pair HTML elements

cmd([[Plug 'christoomey/vim-tmux-navigator']]) -- Navigate tmux splits seamlessly
cmd([[Plug 'ThePrimeagen/harpoon']]) -- File navigation

-- easy commenting
cmd([[Plug 'numToStr/Comment.nvim']]) -- Easier commenting

-- change surronding pairs for example "ex" -> 'ex'
cmd([[Plug 'tpope/vim-surround']])

-- Colorscheme
cmd([[Plug 'shaunsingh/nord.nvim']])
-- cmd([[Plug 'EdenEast/nightfox.nvim' " Vim-Plug]])
-- cmd([[Plug 'folke/tokyonight.nvim', { 'branch': 'main' }]])
-- cmd([[Plug 'arcticicestudio/nord-vim']])

-- F#
cmd([[Plug 'adelarsq/neofsharp.vim']])

-- Completeion
cmd([[Plug 'hrsh7th/nvim-cmp']]) -- The completion plugin
cmd([[Plug 'hrsh7th/cmp-buffer']]) -- buffer completions
cmd([[Plug 'hrsh7th/cmp-path']]) -- path completions
cmd([[Plug 'hrsh7th/cmp-cmdline']]) -- cmdline completions
cmd([[Plug 'saadparwaiz1/cmp_luasnip']]) -- snippet completions
cmd([[Plug 'hrsh7th/cmp-nvim-lsp']]) -- lsp support for cmp

-- snippets
cmd([[Plug 'L3MON4D3/LuaSnip']]) --snippet engine
cmd([[Plug 'rafamadriz/friendly-snippets']]) -- a bunch of snippets to use

-- LSP
cmd([[Plug 'neovim/nvim-lspconfig']]) -- enable LSP
cmd([[Plug 'jose-elias-alvarez/null-ls.nvim']]) -- for formatters and linters
cmd([[Plug 'jose-elias-alvarez/nvim-lsp-ts-utils']]) -- Utils for typescript

-- Treesitter
cmd([[Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}]]) -- enable LSP
cmd([[Plug 'nvim-treesitter/nvim-treesitter-context']]) -- Show function name as top row
cmd([[Plug 'JoosepAlviste/nvim-ts-context-commentstring']]) -- enable LSP

-- Diagnostics
cmd([[Plug 'dstein64/vim-startuptime']]) -- Check what takes time during startup

plugEnd()
