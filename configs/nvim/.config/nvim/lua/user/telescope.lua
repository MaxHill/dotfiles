-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    file_ignore_patterns = { ".git/", ".cache", ".DS_Store", "%.o", "%.out", "%.class",
      "%.pdf", "%.mkv", "%.mp4", "%.zip", 'node_modules' },
    vimgrep_arguments = {
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
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  pickers = {
    live_grep = {
      additional_args = function()
        return { "--hidden" }
      end
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
