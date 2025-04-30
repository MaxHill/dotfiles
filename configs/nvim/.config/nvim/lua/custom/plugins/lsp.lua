return {

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      -- Auto formatting
      "stevearc/conform.nvim",

      -- Schema information
      "b0o/SchemaStore.nvim",

      -- Helper functions
      "nvimdev/lspsaga.nvim",

      -- c# dotnet
      { "Hoffs/omnisharp-extended-lsp.nvim" },
      { "OrangeT/vim-csharp" },
    },
    config = function()
      require("neodev").setup {}

      local capabilities = nil
      if pcall(require, "cmp_nvim_lsp") then
        capabilities = require("cmp_nvim_lsp").default_capabilities()
      end

      local lspconfig = require "lspconfig"

      local servers = {
        bashls = true,
        gopls = true,
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" }, -- Optional if using neodev
              },
            },
          },
        },
        rust_analyzer = true,
        templ = true,
        cssls = true,
        svelte = true,
        gleam = {
          manual_install = true,
        },

        -- Probably want to disable formatting for this lang server
        ts_ls = true,

        ocamllsp = {
          manual_install = true,
          settings = {
            codelens = { enable = true },
            inlayHints = { enable = true },
          },

          filetypes = {
            "ocaml",
            "ocaml.interface",
            "ocaml.menhir",
            "ocaml.cram",
          },
        },

        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        marksman = true,
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },

        clangd = {
          init_options = { clangdFileStatus = true },
          filetypes = { "c" },
        },

        omnisharp = {
          cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", ".git"),
          handlers = {
            ["textDocument/definition"] = function(...)
              return require("omnisharp_extended").handler(...)
            end,
          },
          -- keys = require("custom.keymaps").omnisharp(),
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
        },
      }

      -- Install servers
      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        "js-debug-adapter",
        "stylua",
        "lua_ls",
        "markdownlint-cli2",
        "svelte-language-server",
        "csharpier", -- c#
        "netcoredbg", --c#
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      -- Setup servers
      for name, config in pairs(servers) do
        if config == true then
          config = {}
        end
        config = vim.tbl_deep_extend("force", {}, {
          capabilities = capabilities,
        }, config)

        lspconfig[name].setup(config)
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"

          require("lspsaga").setup {}

          local filetype = vim.bo[bufnr].filetype

          if filetype == "cs" then
            require("custom.keymaps").lsp_keymaps_csharp(args)
          else
            require("custom.keymaps").lsp_keymaps(args)
          end

          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end
        end,
      })

      -- Auto formatting Setup
      local conform = require "conform"
      conform.setup {
        formatters_by_ft = {
          cs = { "csharpier" },
          lua = { "stylua" },
          javascript = { { "prettierd", "prettier" } },
          rust = { "rustfmt" },
          sql = { "sleek" },
          ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
          ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        },
        formatters = {
          sleek = {
            command = "sleek",
            -- args = { "", "-" },
          },
          csharpier = {
            command = "dotnet-csharpier",
            args = { "--write-stdout" },
          },
          ["markdown-toc"] = {
            condition = function(_, ctx)
              for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                if line:find "<!%-%- toc %-%->" then
                  return true
                end
              end
            end,
          },
          ["markdownlint-cli2"] = {
            condition = function(_, ctx)
              local diag = vim.tbl_filter(function(d)
                return d.source == "markdownlint"
              end, vim.diagnostic.get(ctx.buf))
              return #diag > 0
            end,
          },
        },
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          require("conform").format { bufnr = args.buf, lsp_fallback = true, quiet = true }
        end,
      })
    end,
  },
}
