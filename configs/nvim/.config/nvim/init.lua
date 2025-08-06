vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -----------------------------
-- Plugins
-- -----------------------------
vim.pack.add({
    { src = "https://github.com/vague2k/vague.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/echasnovski/mini.surround" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/Saghen/blink.cmp",               version = '1.*' },
})
-- vim.pack.update();

-- Find
-- -----------------------------
require "mini.pick".setup()

-- Treesitter
-- -----------------------------
require("nvim-treesitter.configs").setup({
    modules = {},
    ensure_installed = { "svelte", "javascript", "lua" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
    }
})

-- LSP
-- -----------------------------
require("mason").setup()

vim.lsp.enable({
    "lua_ls",
    "typescript",
    "emmetls",
    "gopls",
    "rust_analyzer",
    "cssls",
    "svelte",
    "gleam",
    "ts_ls",
    "marksman",
    "emmet_ls", -- TODO: settings
    "omnisharp" -- TODO: settings
})
-- TODO: Mason ensure_installed


vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
})

-- Completion
-- -----------------------------
require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    -- Override any conflicting keymaps
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide' },
    ['<C-y>'] = { 'select_and_accept' },
  },
  appearance = {
    use_nvim_cmp_as_default = false, -- Don't use nvim-cmp styling
  },
  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    menu = {
      draw = {
        treesitter = { "lsp" },
      },
    },
  },
})

-- Disable built-in completion sources
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.complete = ''

-- Disable omnifunc for all filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.omnifunc = ""
  end,
})

-- Colors
-- -----------------------------
require "vague".setup({ transparent = true })
vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")

-- -----------------------------
-- Keymaps
-- -----------------------------
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

-- Copy/cut
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete without yank" })
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d', { desc = "Delete to system clipboard" })

-- Move text
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected up" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected down" })

-- Replace
vim.keymap.set("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word undeder cursor" })

-- Screen moving
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Center screen when going up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center screen when going down" })
vim.keymap.set("n", "n", " nzz", { desc = "Center screen when moving through results" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Center screen when going down" })

-- Lsp
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

local pick = require('mini.pick')
vim.keymap.set('n', '<leader>sf', pick.builtin.files, { desc = "[S]earch [F]iles" })
vim.keymap.set('n', '<leader>sh', pick.builtin.help, { desc = "[S]earch [H]elp" })
vim.keymap.set('n', '<leader>sg', pick.builtin.grep_live, { desc = "[S]earch [G]rep" })
