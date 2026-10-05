-- Test runner chung cho Go và Rust.
-- Go:   neotest-golang (chạy qua gotestsum, hỗ trợ subtest + coverage).
-- Rust: adapter đi kèm rustaceanvim (hiểu `#[test]`, `#[tokio::test]`, cargo-nextest).
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
      "mrcjkb/rustaceanvim",
    },
    keys = {
      { "<leader>nr", function() require("neotest").run.run() end, desc = "Test: run nearest" },
      { "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: run file" },
      { "<leader>na", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: run all" },
      { "<leader>nl", function() require("neotest").run.run_last() end, desc = "Test: run last" },
      { "<leader>nS", function() require("neotest").run.stop() end, desc = "Test: stop" },
      {
        "<leader>nd",
        function() require("neotest").run.run({ strategy = "dap", suite = false }) end,
        desc = "Test: debug nearest",
      },
      { "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Test: toggle summary" },
      {
        "<leader>no",
        function() require("neotest").output.open({ enter = true, auto_close = true }) end,
        desc = "Test: show output",
      },
      { "<leader>nO", function() require("neotest").output_panel.toggle() end, desc = "Test: toggle output panel" },
      { "<leader>nw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Test: toggle watch file" },
      { "]n", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Test: next failed" },
      { "[n", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Test: prev failed" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            -- `-count=1` tắt test cache: chạy lại là chạy thật, không đọc kết quả cũ.
            go_test_args = { "-v", "-race", "-count=1" },
            -- gotestsum cho output gọn + JSON ổn định hơn `go test -json`,
            -- nhưng chỉ dùng khi binary có thật (cài qua :MasonInstallAll),
            -- không thì fallback về `go` để test vẫn chạy được.
            runner = vim.fn.executable("gotestsum") == 1 and "gotestsum" or "go",
            dap_go_enabled = true, -- `<leader>nd` dùng delve qua nvim-dap-go
            testify_enabled = true, -- nhận diện suite của stretchr/testify
          }),
          require("rustaceanvim.neotest"),
        },
        discovery = {
          -- Quét test lười (chỉ file đang mở). Repo Go/Rust lớn mà quét cả cây
          -- thì mỗi lần mở buffer sẽ khựng vài giây.
          enabled = false,
          concurrent = 1,
        },
        running = { concurrent = true },
        summary = {
          animated = false,
          open = "botright vsplit | vertical resize 50",
        },
        output = { open_on_run = false },
        quickfix = {
          enabled = true,
          open = false, -- lỗi vào quickfix, dùng `qn`/`qp` để duyệt
        },
        status = { virtual_text = true, signs = true },
      })
    end,
  },
}
