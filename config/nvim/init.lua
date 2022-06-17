require("user.plugins")
require("user.options")
require("user.keymaps")
require("user.cmp")
require("user.lsp")
require("user.treesitter")
require("user.autopairs")
require("user.comment")
require("user.nvim-tree")
require("user.telescope")
-- require("user.snippets")

-- Colorscheme
vim.cmd("colorscheme nord")
vim.cmd("highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080")
vim.cmd("highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6")
vim.cmd("highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6")
vim.cmd("highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE")
vim.cmd("highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE")
vim.cmd("highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE")
vim.cmd("highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0")
vim.cmd("highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0")
vim.cmd("highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4")

-- Give a little bit of focus to the active window
vim.cmd("augroup BgHighlight  \
  autocmd! \
    autocmd WinEnter * set colorcolumn=80 \
    autocmd WinLeave * set colorcolumn=0 \
  augroup END \
")

vim.cmd("highlight Normal ctermfg=145 ctermbg=none guifg=#ABB2BF guibg=none")
