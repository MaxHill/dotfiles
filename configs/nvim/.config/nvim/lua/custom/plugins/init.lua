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
  "tpope/vim-fugitive", -- manage git from within vim
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "chentoast/marks.nvim", -- show marks in the sidebar
  {
    "numToStr/Comment.nvim", -- comment using gc
    config = function()
      require("Comment").setup()
    end,
  },
}
