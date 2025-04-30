return {
  {
    "tjdevries/ocaml.nvim",
    build = function()
      require("ocaml").update()
    end,
    config = function()
      require("ocaml").setup()
    end,
  },
  "ledger/vim-ledger",
  "christoomey/vim-tmux-navigator", -- Navigate tmux splits seamlessly
  "tpope/vim-vinegar", -- keybindings and settings for netrw
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "chentoast/marks.nvim", -- show marks in the sidebar
  {
    "numToStr/Comment.nvim", -- comment using gc
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "kylechui/nvim-surround", -- Change/Update/Delete surrounding pairs
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {
        -- Configuration here, or leave empty to use defaults
      }
    end,
  },
}
