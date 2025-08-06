return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim", -- ensure mason dap integration
      "Cliffback/netcoredbg-macOS-arm64.nvim",
      { dir = "~/code/work/netcoredbg-macOS-arm64.nvim/" },
    },
    event = "VeryLazy",
    config = function()
      local dap = require "dap"

      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "DapStopped", linehl = "DebugLineHL", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🔶", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "⚠️", texthl = "DapBreakpoint", linehl = "", numhl = "" }
      )

      local ui = require "dapui"

      dap.set_log_level "TRACE"
      print(vim.fn.stdpath "cache" .. "/dap.log")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()

      -- C# part
      require("netcoredbg-macOS-arm64").setup(require "dap")

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

      --  ------------------------------------------------------------------------
      --  GO
      --  ------------------------------------------------------------------------
      dap.adapters.go = function(callback, config)
        local handle
        local pid_or_err
        local port = 38697
        handle, pid_or_err = vim.loop.spawn("dlv", {
          args = { "dap", "-l", "127.0.0.1:" .. port },
          detached = true,
        }, function(code)
          handle:close()
          print("Delve exited with exit code: " .. code)
        end)
        -- Wait for delve to start
        vim.defer_fn(function()
          -- Connect to delve via TCP
          callback { type = "server", host = "127.0.0.1", port = port }
        end, 100)
      end

      dap.configurations.go = {
        {
          type = "go",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug Test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "go",
          name = "Debug Package",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

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
