-- LSP settings.
local M = {}

-- Fix for marks getting removed
M.LspFormatBuffer = function()
  local marks = {}
  local letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  for i = 1, #letters do
    local letter = letters:sub(i, i)
    local markLocation = vim.api.nvim_buf_get_mark(0, letter)
    marks[letter] = markLocation;
  end

  vim.lsp.buf.format({}, 5000)

  for i = 1, #letters do
    local letter = letters:sub(i, i)
    local markLocation = marks[letter];
    local linenr = markLocation[1]
    if (linenr ~= 0) then
      vim.api.nvim_command("" .. linenr .. "mark " .. letter)
    end
  end
end

--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    local marks = {}
    local letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    for i = 1, #letters do
      local letter = letters:sub(i, i)
      local markLocation = vim.api.nvim_buf_get_mark(bufnr, letter)
      marks[letter] = markLocation;
    end

    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end

    for i = 1, #letters do
      local letter = letters:sub(i, i)
      local markLocation = marks[letter];
      local linenr = markLocation[1]
      if (linenr ~= 0) then
        vim.api.nvim_command("" .. linenr .. "mark " .. letter)
      end
    end
  end, { desc = 'Format current buffer with LSP' })
end

-- Add signs for gutter
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = { 'rust_analyzer', 'tsserver', 'lua_ls', 'gopls' }


-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  ensure_installed = servers,
}

-- Install Language servers
-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Attach mason managed servers
mason_lspconfig.setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- Default handler (optional)
    require('lspconfig')[server_name].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end,

  -- Manual config of LSPs

  -- Setup rust tools
  ["rust_analyzer"] = function()
    require('user.lsp.rust_ls').setup(on_attach, capabilities);
  end,

  -- Setup sumneko_lua
  ["lua_ls"] = function()
    require('user.lsp.lua_ls').setup(on_attach, capabilities);
  end,

  ["stylelint_lsp"] = function()
    require("lspconfig").stylelint_lsp.setup({
      filetypes = { "css", "scss" },
      root_dir = require("lspconfig").util.root_pattern("package.json", ".git"),
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        autoFixOnFormat = true,
        autoFixOnSave = true
      },
    });
  end,


  require 'lspconfig'.sourcekit.setup {
    cmd = { '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp' }
  }
})

-- Turn on lsp status information
require('fidget').setup()

return M
