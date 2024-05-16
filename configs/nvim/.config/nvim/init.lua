require("user.options")

-- Packages
require("user.packer")
require("user.neodev") -- Must be before lsp
require("user.lsp")
require("user.treesitter")
require("user.snippets") -- Must be before cmp
require("user.cmp")
require("user.telescope")
require("user.marks")
require("user.comment")
require("user.lualine")
require("user.worktrees")
require("user.mini_surround")
require("user.conform")

require("user.auto-commands")

-- keymaps
require("user.keymaps")

vim.cmd.colorscheme("catppuccin-macchiato")
