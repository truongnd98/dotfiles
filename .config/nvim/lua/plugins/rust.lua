-- Rust: rustaceanvim thay thế hoàn toàn `lspconfig.rust_analyzer`.
-- Nó tự start rust-analyzer, thêm runnables/debuggables/expand-macro,
-- render lỗi rustc đầy đủ (thay vì bản rút gọn của LSP) và tích hợp DAP.
--
-- QUAN TRỌNG: không được `vim.lsp.enable("rust_analyzer")` ở nơi khác,
-- xem ghi chú trong lua/plugins/lsp.lua.

local function codelldb_adapter()
  local mason = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
  local adapter = mason .. "/adapter/codelldb"
  local liblldb = mason .. "/lldb/lib/liblldb.dylib" -- macOS; Linux là .so

  if vim.fn.executable(adapter) == 0 then
    return nil -- chưa `:MasonInstall codelldb` -> rustaceanvim fallback về lldb-dap
  end
  return require("rustaceanvim.config").get_codelldb_adapter(adapter, liblldb)
end

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    -- rustaceanvim tự lazy-load qua ftplugin/rust.lua, KHÔNG bọc `ft`/`event`
    -- ở đây (sẽ làm nó start muộn hơn và mất `:RustAnalyzer` khi cần).
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        tools = {
          float_win_config = { border = "rounded" },
          -- `:RustLsp testables` chạy qua neotest (xem lua/plugins/neotest.lua)
          -- để kết quả hiện chung một chỗ với test của Go.
          test_executor = "neotest",
        },
        server = {
          ---@param client vim.lsp.Client
          ---@param bufnr integer
          on_attach = function(client, bufnr)
            local function map(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- Hover actions: hover thường + danh sách action tại con trỏ.
            -- Bấm lần 2 để nhảy vào cửa sổ float.
            map("<leader>i", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, "Rust hover actions")

            -- Code action của rust-analyzer được group theo nhóm, dùng bản
            -- của rustaceanvim thay vì vim.lsp.buf.code_action.
            vim.keymap.set({ "n", "v" }, "<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, { buffer = bufnr, desc = "Rust code action" })

            -- <leader>m = menu lệnh riêng của ngôn ngữ
            map("<leader>mr", function()
              vim.cmd.RustLsp("runnables")
            end, "Rust runnables")
            map("<leader>mR", function()
              vim.cmd.RustLsp({ "runnables", bang = true })
            end, "Rust run last")
            map("<leader>md", function()
              vim.cmd.RustLsp("debuggables")
            end, "Rust debuggables")
            map("<leader>mD", function()
              vim.cmd.RustLsp({ "debuggables", bang = true })
            end, "Rust debug last")
            map("<leader>me", function()
              vim.cmd.RustLsp("expandMacro")
            end, "Rust expand macro")
            map("<leader>mc", function()
              vim.cmd.RustLsp("openCargo")
            end, "Open Cargo.toml")
            map("<leader>mp", function()
              vim.cmd.RustLsp("parentModule")
            end, "Rust parent module")
            map("<leader>mj", function()
              vim.cmd.RustLsp("joinLines")
            end, "Rust join lines")
            map("<leader>mm", function()
              vim.cmd.RustLsp("rebuildProcMacros")
            end, "Rust rebuild proc macros")
            -- Lỗi rustc dạng đầy đủ (có ascii art chỉ vào đúng span) + `rustc --explain`
            map("<leader>ms", function()
              vim.cmd.RustLsp("renderDiagnostic")
            end, "Rust render diagnostic")
            map("<leader>mx", function()
              vim.cmd.RustLsp("explainError")
            end, "Rust explain error")
            map("<leader>mu", function()
              vim.cmd.RustLsp({ "view", "mir" })
            end, "Rust view MIR")

            if client:supports_method("textDocument/inlayHint") then
              vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                -- Bật hết feature để không bị "unresolved import" trong code
                -- nằm sau `#[cfg(feature = ...)]`.
                features = "all",
                buildScripts = { enable = true },
              },
              -- Clippy khi save thay cho `cargo check` - bắt được nhiều lỗi
              -- style/perf hơn mà không tốn thêm lượt build.
              checkOnSave = true,
              check = {
                command = "clippy",
                allTargets = true,
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  -- Các macro này rust-analyzer expand rất chậm/không chính xác.
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
              inlayHints = {
                bindingModeHints = { enable = false },
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
                parameterHints = { enable = true },
                typeHints = { enable = true },
                maxLength = 30,
              },
              lens = {
                enable = true,
                implementations = { enable = true },
                references = {
                  adt = { enable = true },
                  trait = { enable = true },
                },
              },
              imports = {
                granularity = { group = "module" },
                prefix = "self",
              },
              files = {
                excludeDirs = { ".git", ".direnv", "target", "node_modules" },
              },
              diagnostics = {
                enable = true,
                experimental = { enable = true },
              },
            },
          },
        },
        dap = {
          adapter = codelldb_adapter(),
        },
      }
    end,
  },

  -- Cargo.toml: version hiện tại vs mới nhất, feature list, docs/crates.io,
  -- và nguồn completion cho tên crate + version.
  {
    "saecki/crates.nvim",
    tag = "stable",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = { enabled = true },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
    config = function(_, opts)
      require("crates").setup(opts)

      vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("crates.keymaps", { clear = true }),
        pattern = "Cargo.toml",
        callback = function(ev)
          local crates = require("crates")
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          map("<leader>i", crates.show_popup, "Crate info")
          map("<leader>mv", crates.show_versions_popup, "Crate versions")
          map("<leader>mf", crates.show_features_popup, "Crate features")
          map("<leader>mD", crates.show_dependencies_popup, "Crate dependencies")
          map("<leader>mu", crates.update_crate, "Update crate")
          map("<leader>mU", crates.upgrade_crate, "Upgrade crate (bump major)")
          map("<leader>ma", crates.update_all_crates, "Update all crates")
          map("<leader>mA", crates.upgrade_all_crates, "Upgrade all crates")
          map("<leader>mo", crates.open_documentation, "Open docs.rs")
          map("<leader>mc", crates.open_crates_io, "Open crates.io")
          map("<leader>mR", crates.open_repository, "Open repository")
        end,
      })
    end,
  },
}
