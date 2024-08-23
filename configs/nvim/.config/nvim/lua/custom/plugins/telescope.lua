return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("telescope").setup {
        extensions = {
          fzf = {},
          wrap_results = true,
        },
        defaults = {
          file_ignore_patterns = {
            ".git/",
            ".cache",
            ".DS_Store",
            "%.o",
            "%.out",
            "%.class",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
            "node_modules",
          },
          ripgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--ignore-file",
            ".gitignore",
          },
        },
        pickers = {
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
      }

      pcall(require("telescope").load_extension, "fzf")

      require("custom.keymaps").telescope_keymaps(require "telescope.builtin")
    end,
  },
}
