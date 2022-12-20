-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local keymaps = require('user.keymaps').cmp_keymaps

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = keymaps(cmp, luasnip),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}
