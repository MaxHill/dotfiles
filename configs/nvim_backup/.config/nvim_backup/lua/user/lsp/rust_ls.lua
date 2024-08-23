local M = {};

M.setup = function(on_attach, capabilities)
  require("rust-tools").setup({
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            enable = true,
            command = "clippy",
          },
          cargo = {
            allFeatures = true,
          },
        },
      },
    }
  })
end



return M
