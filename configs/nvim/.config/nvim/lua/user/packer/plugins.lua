local M = {}

M.plugins = function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path'
    }, }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  use 'nvim-treesitter/nvim-treesitter-context' -- Context for treesitter

  -- Git related plugins
  use 'tpope/vim-fugitive' -- manage git from within vim
  use 'ThePrimeagen/git-worktree.nvim' -- manage git worktrees from within vim

  -- Netrw
  use 'tpope/vim-vinegar' -- keybindings and settings for netrw

  -- Colorscheme
  use { "catppuccin/nvim", as = "catppuccin" }

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  -- use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use 'tpope/vim-surround' -- Change surronunding char from ex " to '
  use 'christoomey/vim-tmux-navigator' -- Navigate tmux splits seamlessly
  use 'ThePrimeagen/harpoon' -- File navigation
  use 'chentoast/marks.nvim' -- show marks in the sidebar


  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
end

return M
