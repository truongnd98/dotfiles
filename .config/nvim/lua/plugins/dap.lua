-- Debug adapter cho Go (delve) và Rust (codelldb).
-- Rust: `<leader>md` (:RustLsp debuggables) tự build target rồi gọi vào đây.
-- Go:   `<leader>dt` debug test gần con trỏ, `<leader>dc` chạy/tiếp tục.
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        opts = {
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.35 },
                { id = "breakpoints", size = 0.15 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              size = 46,
              position = "left",
            },
            {
              elements = {
                { id = "repl", size = 0.5 },
                { id = "console", size = 0.5 },
              },
              size = 12,
              position = "bottom",
            },
          },
          floating = { border = "rounded" },
        },
        config = function(_, opts)
          local dap, dapui = require("dap"), require("dapui")
          dapui.setup(opts)

          dap.listeners.after.event_initialized["dapui"] = function()
            dapui.open({})
          end
          -- Không auto-close khi terminated: giữ lại scopes/stack để đọc
          -- state cuối cùng sau khi chương trình thoát.
          dap.listeners.before.event_exited["dapui"] = function()
            vim.notify("DAP: session exited", vim.log.levels.INFO)
          end
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          virt_text_pos = "eol",
          commented = true,
          -- Rust hay có value dài (Vec/HashMap dump), cắt bớt cho đỡ vỡ layout.
          display_callback = function(variable)
            local value = variable.value:gsub("%s+", " ")
            if #value > 60 then
              value = value:sub(1, 57) .. "..."
            end
            return " " .. variable.name .. " = " .. value
          end,
        },
      },
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP: toggle breakpoint" },
      {
        "<leader>dB",
        function()
          vim.ui.input({ prompt = "Breakpoint condition: " }, function(cond)
            if cond and cond ~= "" then
              require("dap").set_breakpoint(cond)
            end
          end)
        end,
        desc = "DAP: conditional breakpoint",
      },
      {
        "<leader>dp",
        function()
          vim.ui.input({ prompt = "Log point message: " }, function(msg)
            if msg and msg ~= "" then
              require("dap").set_breakpoint(nil, nil, msg)
            end
          end)
        end,
        desc = "DAP: log point",
      },
      { "<leader>dx", function() require("dap").clear_breakpoints() end, desc = "DAP: clear breakpoints" },
      { "<leader>dc", function() require("dap").continue() end, desc = "DAP: continue / start" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "DAP: run to cursor" },
      { "<leader>di", function() require("dap").step_into() end, desc = "DAP: step into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "DAP: step over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "DAP: step out" },
      { "<leader>dk", function() require("dap").up() end, desc = "DAP: up stack frame" },
      { "<leader>dj", function() require("dap").down() end, desc = "DAP: down stack frame" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "DAP: run last" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "DAP: toggle REPL" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "DAP: terminate" },
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "DAP: toggle UI" },
      { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, mode = { "n", "v" }, desc = "DAP: eval" },
      {
        "<leader>dh",
        function() require("dap.ui.widgets").hover() end,
        mode = { "n", "v" },
        desc = "DAP: hover variable",
      },
      {
        "<leader>df",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "DAP: frames",
      },
    },
    config = function()
      local dap = require("dap")

      -- Dấu breakpoint: mặc định là chữ `B`/`●` khó phân biệt trạng thái.
      local signs = {
        DapBreakpoint = { text = "󰻃", texthl = "DiagnosticError" },
        DapBreakpointCondition = { text = "󰋗", texthl = "DiagnosticWarn" },
        DapLogPoint = { text = "󰛿", texthl = "DiagnosticInfo" },
        DapStopped = { text = "󰁕", texthl = "DiagnosticOk", linehl = "Visual" },
        DapBreakpointRejected = { text = "󰅚", texthl = "DiagnosticHint" },
      }
      for name, opts in pairs(signs) do
        vim.fn.sign_define(name, opts)
      end

      -- codelldb: rustaceanvim dùng adapter riêng cho `:RustLsp debuggables`,
      -- đăng ký thêm ở đây để `dap.continue()` / launch.json chạy được với Rust & C/C++.
      local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
      if vim.fn.executable(codelldb) == 1 then
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb,
            args = { "--port", "${port}" },
          },
        }
      end

      -- `.vscode/launch.json` của project được nvim-dap đọc tự động khi
      -- `continue()` chạy - không cần load_launchjs (đã deprecated).
    end,
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    opts = {
      delve = {
        -- detached=false trên macOS: delve chạy trong cùng process group,
        -- tránh trường hợp process con còn sống sau khi thoát Neovim.
        detached = false,
        build_flags = { "-gcflags=all=-N -l" }, -- tắt optimize/inline để step chuẩn
      },
      dap_configurations = {
        {
          type = "go",
          name = "Attach to remote (:2345)",
          mode = "remote",
          request = "attach",
        },
      },
    },
    config = function(_, opts)
      require("dap-go").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("dap-go.keymaps", { clear = true }),
        pattern = "go",
        callback = function(ev)
          vim.keymap.set("n", "<leader>dt", function()
            require("dap-go").debug_test()
          end, { buffer = ev.buf, desc = "DAP: debug nearest Go test" })
          vim.keymap.set("n", "<leader>dT", function()
            require("dap-go").debug_last_test()
          end, { buffer = ev.buf, desc = "DAP: debug last Go test" })
        end,
      })
    end,
  },
}
