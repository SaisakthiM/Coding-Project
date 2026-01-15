return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end },
      { "<F6>", function() require("dap").step_over() end },
      { "<F7>", function() require("dap").step_into() end },
      { "<F8>", function() require("dap").step_out() end },
      { "<F9>", function() require("dap").toggle_breakpoint() end },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      
      -- Setup UI
      dapui.setup()
      require("nvim-dap-virtual-text").setup()
      
      -- Auto open/close UI
      dap.listeners.after.event_initialized["dapui_config"] = dapui.open
      dap.listeners.before.event_terminated["dapui_config"] = dapui.close
      dap.listeners.before.event_exited["dapui_config"] = dapui.close
      
      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "DapStoppedLine", numhl = "" })
      
      -- Python
      dap.adapters.python = {
        type = "executable",
        command = "python3",
        args = { "-m", "debugpy.adapter" },
      }
      dap.configurations.python = {{
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = "python3",
      }}
      
      -- Node.js
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
      dap.configurations.javascript = {{
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      }}
      dap.configurations.typescript = dap.configurations.javascript
      
      -- C/C++/Rust
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }
      local c_config = {{
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      }}
      dap.configurations.c = c_config
      dap.configurations.cpp = c_config
      dap.configurations.rust = c_config
      
      -- Go
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }
      dap.configurations.go = {{
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}",
      }}
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mason.nvim", "nvim-dap" },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      ensure_installed = {
        "python", "codelldb", "js-debug-adapter", "delve",
      },
      automatic_installation = true,
    },
  },
}
