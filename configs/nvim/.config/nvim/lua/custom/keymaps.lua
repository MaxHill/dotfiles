local M = {}

local nmap = function(keys, func, desc)
  vim.keymap.set("n", keys, func, { desc = desc })
end

local vmap = function(keys, func, desc)
  vim.keymap.set({ "v", "x" }, keys, func, { desc = desc })
end

local nvmap = function(keys, func, desc)
  vim.keymap.set({ "n", "v", "x" }, keys, func, { desc = desc })
end

local ivmap = function(keys, func, desc)
  vim.keymap.set({ "v", "i" }, keys, func, { desc = desc })
end

M.global = function()
  -- Open related files
  nmap("<leader><space>c", function()
    require("custom.open-related-plugin").toggle ".*css$"
  end)
  nmap("<leader><space>t", function()
    require("custom.open-related-plugin").toggle ".*ts$"
  end)

  -- Quickfix
  nmap("]q", ":cn<CR>") -- next in quickfix list
  nmap("[q", ":cp<CR>") -- previous in quickfix list

  -- Copy/cut
  vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without yank" })
  nvmap("<leader>d", '"_d', "Delete without yank")
  nvmap("<leader>y", '"+y', "Copy to system clipboard")

  -- Move text
  vmap("J", ":m '>+1<CR>gv=gv", "Move selected up")
  vmap("K", ":m '<-2<CR>gv=gv", "Move selected down")

  -- Replace
  nmap("<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Replace word undeder cursor")

  -- Screen moving
  nmap("<C-u>", "<C-u>zz", "Center screen when going up")
  nmap("<C-d>", "<C-d>zz", "Center screen when going down")
  nmap("n", " nzz", "Center screen when moving through results")
  nmap("<C-d>", "<C-d>zz", "Center screen when going down")

  -- Tmux navigator
  nmap("<c-j> ", ":TmuxNavigateDown<CR>")
  nmap("<c-k>", ":TmuxNavigateUp<CR>")
  nmap("<c-h>", ":TmuxNavigateLeft<CR>")
  nmap("<c-l>", ":TmuxNavigateRight<CR>")

  -- Git Fugitive
  nmap("<leader>g", ":G <CR>")
  nmap("<leader>gp", ":G push<CR>")

  -- Ocaml
  -- nmap("<leader>opt", require("ocaml.mappings").dune_promote_file, "[O]caml [P]romote [T]est")
  -- vim.keymap.set("n", "<space>", require("ocaml.mappings").dune_promote_file, { buffer = 0 })
end

M.ocaml = function()
  nmap("<leader>out", require("ocaml.actions").update_interface_type, "[O]caml [U]pdate [T]ype")
  nmap("<leader>opt", require("ocaml.mappings").dune_promote_file, "[O]caml [P]romote [T]est")

  nmap("<leader>oi", function()
    require("custom.open-related-plugin").toggle ".*ts$"
  end)
end

M.harpoon_keymaps = function(harpoon)
  nmap("<leader>a", function()
    harpoon:list():add()
  end, "Add file to harpoon list")

  nmap("<leader>e", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, "Edit harpoon list")

  nmap("<leader>h", function()
    harpoon:list():select(1)
  end, "Navigate to file 1 in hapoon list")

  nmap("<leader>j", function()
    harpoon:list():select(2)
  end, "Navigate to file 2 in hapoon list")

  nmap("<leader>k", function()
    harpoon:list():select(3)
  end, "Navigate to file 3 in hapoon list")

  nmap("<leader>l", function()
    harpoon:list():select(4)
  end, "Navigate to file 4 in hapoon list")
end

M.lsp_keymaps = function(args)
  local builtin = require "telescope.builtin"
  local nmapBuf = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = args.bufnr, desc = desc })
  end
  nmapBuf("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
  nmapBuf("gr", builtin.lsp_references, "[G]oto [R]eferences")
  nmapBuf("gD", builtin.lsp_references, "[G]oto [R]eferences")
  nmapBuf("gD", vim.lsp.buf.declaration, "[G]oto [Declaration]")
  nmapBuf("gi", builtin.lsp_implementations, "[G]oto [I]mplementation")
  nmapBuf("gT", builtin.lsp_type_definitions, "[G]oto [T]ype definition")
  nmapBuf("gl", vim.diagnostic.open_float, "[G]et [L]ine diagnostics")
  -- nmapBuf("K", vim.lsp.buf.hover, "Hover Documentation")

  nmapBuf("<leader>f", vim.diagnostic.goto_prev) -- Was <leader>k before, replaced by harpoo,
  nmapBuf("<leader>d", vim.diagnostic.goto_next)
  nmapBuf("<leader>q", vim.diagnostic.setloclist, "Add to quickfix list")

  -- nmapBuf("<space>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmapBuf("<space>rn", "<Cmd>Lspsaga rename<cr>", "[R]e[n]ame")
  nmapBuf("<space>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  -- Lspsaga variations
  nmapBuf("K", "<Cmd>Lspsaga hover_doc<cr>", "Hover Documentation")
  nmapBuf("<leader>kk", "<Cmd>Lspsaga hover_doc ++keep<cr>", "Hover Documentation and keep it visible")

  -- nmapBuf("<leader>f", "<Cmd>Lspsaga diagnostic_jump_next<cr>") -- Was <leader>k before, replaced by harpoo,
  -- nmapBuf("<leader>d", "<Cmd>Lspsaga diagnostic_jump_prev<cr>")
end

M.telescope_keymaps = function(builtin)
  print "Registering keys"
  nmap("<leader>?", builtin.oldfiles, "[?] Find recently opened files")
  nmap("<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {})
  end, "[/] Fuzzily search in current buffer]")
  nmap("<leader>ft", builtin.git_files)
  nmap("<leader>sf", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.find_files(require("telescope.themes").get_dropdown {
      hidden = true,
      previewer = false,
    })
  end, "[S]earch [F]iles")

  nmap("<leader>SF", function()
    builtin.find_files { hidden = true }
  end, "[S]earch [F]iles")
  nmap("<leader>sh", builtin.help_tags, "[S]earch [H]elp")
  nmap("<leader>sm", builtin.marks, "[S]earch [M]arks")
  nvmap("<leader>sw", builtin.grep_string, "[S]earch current [W]ord")
  nmap("<leader>sg", builtin.live_grep, "[S]earch by [G]rep")
  nmap("<leader>sd", builtin.diagnostics, "[S]earch [D]iagnostics")
  nmap("<leader>st", builtin.treesitter, "[S]earch [T]reesitter")

  nmap("<leader>sN", function()
    builtin.find_files { hidden = true, cwd = os.getenv "NOTES_HOME" }
  end, "[S]earch [N]otes")

  nmap("<leader>sD", function()
    builtin.find_files { hidden = true, cwd = os.getenv "DOTFILES" }
  end, "[S]earch [D]otfiles")
end

M.cmp_keymaps = function(cmp)
  return {
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
    ["<C-y>"] = cmp.mapping(
      cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      },
      { "i", "c" }
    ),
  }
end

M.luasnip_keymaps = function(ls)
  vim.keymap.set({ "v", "i" }, "<c-k>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, { silent = true })

  vim.keymap.set({ "v", "i" }, "<c-j>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, { silent = true })

  vim.keymap.set({ "v", "i" }, "<c-l>", function()
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true })
end

M.treesitter = {
  select_keymaps = {
    -- You can use the capture groups defined in textobjects.scm
    ["aa"] = "@parameter.outer",
    ["ia"] = "@parameter.inner",
    ["am"] = "@function.outer",
    ["im"] = "@function.inner",
    ["ac"] = "@class.outer",
    ["ic"] = "@class.inner",
    ["cc"] = "@comment.outer",
  },
  move_keymaps = {
    goto_next_start = {
      ["]m"] = "@function.outer",
      ["]]"] = "@class.outer",
    },
    goto_next_end = {
      ["]M"] = "@function.outer",
      ["]["] = "@class.outer",
    },
    goto_previous_start = {
      ["[m"] = "@function.outer",
      ["[["] = "@class.outer",
    },
    goto_previous_end = {
      ["[M"] = "@function.outer",
      ["[]"] = "@class.outer",
    },
  },
}

return M
