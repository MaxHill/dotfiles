return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim", -- ensure mason dap integration
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      dap.set_log_level "TRACE"
      print(vim.fn.stdpath "cache" .. "/dap.log")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()

      -- NETCOREDBG (C#) SETUP
      if not dap.adapters["netcoredbg"] then
        dap.adapters["netcoredbg"] = {
          type = "executable",
          command = "/Users/8717/.local/share/nvim/mason/bin/netcoredbg",
          args = { "--interpreter=vscode" },
          options = {
            detached = false,
          },
        }
      end

      for _, lang in ipairs { "cs", "fsharp", "vb" } do
        if not dap.configurations[lang] then
          dap.configurations[lang] = {
            {
              type = "netcoredbg",
              name = "Launch file",
              request = "launch",
              program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
              end,
              cwd = "${workspaceFolder}",
              stopAtEntry = true,
            },
            {
              type = "netcoredbg",
              name = "Attach to process",
              request = "attach",
              processId = function()
                local project_name = vim.fn.input("Project name: ", "")
                return vim.fn.input("Process ID: ", vim.fn.system("pgrep " .. project_name), "file")
              end,
            },
          }
        end
      end

      -- JS/TS/Svelte (via js-debug-adapter)
      local js_debug_path = vim.fn.stdpath "data" .. "/mason/bin/js-debug-adapter"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = js_debug_path,
          args = { "${port}" },
        },
      }

      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = js_debug_path,
          args = { "${port}" },
        },
      }

      for _, lang in ipairs { "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" } do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome to debug client",
            url = "http://localhost:5173",
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            sourceMapPathOverrides = {
              ["webpack:///./~/*"] = "${workspaceFolder}/node_modules/*",
              ["webpack:///./*"] = "${workspaceFolder}/*",
              ["vite:///*"] = "${workspaceFolder}/*",
              ["http://localhost:5173/*"] = "${workspaceFolder}/*",
              ["localhost꞉5173/*"] = "${workspaceFolder}/*", -- handles encoded colon
            },
          },
        }
      end

      require("custom.keymaps").dap(dap)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
