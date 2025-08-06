return {
  {
    "IndianBoy42/tree-sitter-just", -- Syntax highlighting for justfiles
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-lua/plenary.nvim" },
    build = ":TSUpdate",
    lazy = false,
    config = function()
      local configs = require "nvim-treesitter.configs"

      configs.setup {
        ensure_installed = {
          "c",
          "cpp",
          "go",
          "lua",
          "vim",
          "python",
          "rust",
          "typescript",
          "javascript",
          "css",
          "markdown",
          "markdown_inline",
        },
        auto_install = true,
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = require("custom.keymaps").treesitter.select_keymaps,
          },
          move = vim.tbl_deep_extend("keep", {
            enable = true,
            set_jumps = false, -- whether to set jumps in the jumplist,
          }, require("custom.keymaps").treesitter.move_keymaps),
          swap = vim.tbl_deep_extend("keep", {
            enable = true,
            set_jumps = false, -- whether to set jumps in the jumplist,
          }, require("custom.keymaps").treesitter.move_keymaps),
        },
      }

      require("nvim-treesitter.install").compilers = { "gcc", "clang" }
      require("nvim-treesitter.parsers").get_parser_configs().just = {
        install_info = {
          url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
          use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
        },
        maintainers = { "@IndianBoy42" },
      }
    end,
  },
}
