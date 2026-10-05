return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
				-- for lua
				"stylua",
				"luacheck",
				"lua-language-server",
				--
				"shfmt",
				-- -- for ts/js
				-- -- "typescript-language-server",
				-- "ts_ls",
				"eslint-lsp",
        -- tsgo_ls is a fork of ts_ls with better performance
        "tsgo",
        -- "biome",
        -- "copilot-language-server",
        -- for golang
        "gopls",                    -- LSP chính
        "golangci-lint",            -- Linter
        "golangci-lint-langserver", -- Server trung gian để hiển thị lỗi lên LSP
        "goimports",                -- Format & sửa import
        "gofumpt",                  -- Binary cho :GoFmt của go.nvim
        "delve",                    -- Debugger (nvim-dap-go)
        "gomodifytags",             -- Thêm/xoá struct tag (:GoAddTag)
        "impl",                     -- Sinh method stub cho interface (:GoImpl)
        "gotests",                  -- Sinh table-driven test (:GoTestAdd)
        "iferr",                    -- Sinh block `if err != nil` (:GoIfErr)
        "gotestsum",                -- Test runner cho neotest-golang
        -- for rust
        -- rust-analyzer & rustfmt lấy từ rustup (khớp toolchain của project),
        -- KHÔNG cài qua Mason để tránh lệch version. rustaceanvim tự dò trên PATH.
        "codelldb",                 -- Debug adapter cho Rust (nvim-dap)
        "taplo",                    -- LSP cho TOML / Cargo.toml
        -- -- for PHP
        -- "intelephense",    -- LSP chính cho PHP
        -- "php-cs-fixer",   -- Linter & Formatter
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        mr.refresh(function()
          for _, tool in ipairs(opts.ensure_installed) do
            local p = mr.get_package(tool)
            if not p:is_installed() then
              p:install()
            end
          end
        end)
      end, {})

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {},
      -- rustaceanvim tự quản lý rust-analyzer (client name `rust-analyzer`).
      -- Nếu để mason-lspconfig enable thêm `rust_analyzer` sẽ có 2 client
      -- cùng attach vào buffer Rust -> duplicate diagnostics & code action.
      automatic_enable = { exclude = { "rust_analyzer" } },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities.textDocument.semanticTokens = {
        dynamicRegistration = false,
        requests = {
          range = true,
          full = {
            delta = true
          }
        },
        tokenTypes = {},
        tokenModifiers = {},
        formats = { "relative" },
        overlappingTokenSupport = true,
        multilineTokenSupport = true,
      }

      -- lua
      vim.lsp.enable("lua_ls")
      vim.lsp.config["lua_ls"] = {
        capabilities = capabilities,
        settings = {
          Lua = {
            hint = { enable = false },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              },
              checkThirdParty = false,
              maxPreload = 2000,
              preloadFileSize = 1000,
            },
            completion = { callSnippet = "Replace" },
            telemetry = {
              enable = false,
            },
          },
        },
      }
      -- typescript
      vim.lsp.enable("ts_ls")
      vim.lsp.config["ts_ls"] = {
        capabilities = capabilities,
        -- cmd = { "typescript-language-server", "--stdio", "--max-old-space-size=4096" },
        cmd = { "tsgo", "lsp" },
        flags = {
          debounce_text_changes = 100,
        },
        settings = {
          typescript = {
            inlayHints = { includeInlayParameterNameHints = "all" }
          },
          javascript = {
            inlayHints = { includeInlayParameterNameHints = "all" }
          },
        },
      }
      -- Js
      vim.lsp.enable("eslint")
      -- -- yaml
      -- vim.lsp.enable("yamlls")
      -- golang
      vim.lsp.enable("gopls")
      vim.lsp.config["gopls"] = {
        capabilities = capabilities,
        -- `go.work` trước `go.mod` để multi-module workspace chỉ chạy 1 gopls.
        root_markers = { "go.work", "go.mod", ".git" },
        settings = {
          gopls = {
            staticcheck = true,
            gofumpt = true,
            completeUnimported = true,
            usePlaceholders = true,
            semanticTokens = true,
            directoryFilters = { "-.git", "-node_modules", "-vendor", "-bazel-bin", "-bazel-out" },
            analyses = {
              unusedparams = true,
              unusedwrite = true,
              useany = true,
              nilness = true,
              shadow = true,
              fieldalignment = false, -- ồn ào, bật khi thật sự cần tối ưu struct
            },
            codelenses = {
              generate = true,
              gc_details = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              regenerate_cgo = true,
              run_govulncheck = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            vulncheck = "Imports",
          },
        },
      }
      -- golangci lint
      -- Chỉ enable khi binary có thật: nếu chưa chạy :MasonInstallAll thì
      -- vim.lsp.enable() sẽ ném lỗi "not executable" mỗi lần mở file Go.
      if vim.fn.executable("golangci-lint-langserver") == 1 and vim.fn.executable("golangci-lint") == 1 then
        vim.lsp.enable("golangci_lint_ls")
      end
      vim.lsp.config["golangci_lint_ls"] = {
        capabilities = capabilities,
        filetypes = { "go", "gomod" },
        root_markers = { "go.work", "go.mod", ".git" },
        init_options = {
          -- golangci-lint v2 bỏ `--out-format`, thay bằng `--output.json.path`.
          -- `--show-stats=false` để stdout chỉ còn JSON thuần cho langserver parse.
          command = {
            "golangci-lint",
            "run",
            "--output.json.path=stdout",
            "--show-stats=false",
            "--issues-exit-code=1",
          },
        },
      }

      -- toml (Cargo.toml, rustfmt.toml, .golangci.toml)
      vim.lsp.enable("taplo")
      vim.lsp.config["taplo"] = {
        capabilities = capabilities,
      }

      -- rust: KHÔNG cấu hình ở đây. rustaceanvim (lua/plugins/rust.lua) tự
      -- start rust-analyzer với project/toolchain detection riêng.

      -- -- PHP / Laravel
      -- vim.lsp.enable("intelephense")
      -- vim.lsp.config["intelephense"] = {
      --   capabilities = capabilities,
      --   filetypes = { "php", "blade" },
      --   settings = {
      --     intelephense = {
      --       files = {
      --         maxSize = 5000000, -- Tăng giới hạn file để quét vendor mượt hơn
      --       },
      --       -- Hỗ trợ Laravel: Thêm các thư viện Laravel vào stub để autocomplete tốt hơn
      --       stubs = {
      --         "apache", "bcmath", "bz2", "calendar", "Core", "curl", "date", "dom", "ds", "enchant",
      --         "fileinfo", "filter", "fpm", "ftp", "gd", "gettext", "hash", "iconv", "imap", "intl",
      --         "json", "ldap", "libxml", "mbstring", "mcrypt", "mysql", "mysqli", "password", "pcntl",
      --         "pcre", "PDO", "pdo_mysql", "Phar", "readline", "recode", "Reflection", "session",
      --         "SimpleXML", "soap", "sockets", "sodium", "SPL", "standard", "superglobals", "sysvmsg",
      --         "sysvsem", "sysvshm", "tidy", "tokenizer", "xml", "xmlreader", "xmlrpc", "xmlwriter",
      --         "xsl", "Zend OPcache", "zip", "zlib",
      --         "wordpress", "phpunit", "laravel", "redis", -- Thêm stub Laravel & Redis
      --       },
      --       diagnostics = {
      --         enable = true,
      --       },
      --     },
      --   },
      -- }

      -- Global LSP keymaps (giữ nguyên bindings cũ)
      vim.keymap.set("n", "<leader>i", vim.lsp.buf.hover, { desc = "LSP hover" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Goto implementation" })
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto definition" })
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto declaration" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
      vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto type definition" })
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })

      -- Symbol pickers: xương sống khi đọc codebase Go/Rust lớn.
      vim.keymap.set("n", "<leader>fm", function()
        require("telescope.builtin").lsp_document_symbols()
      end, { desc = "Document symbols" })
      vim.keymap.set("n", "<leader>fw", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols()
      end, { desc = "Workspace symbols" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp.attach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          -- Inlay hints: gopls & rust-analyzer đều rất mạnh khoản này.
          -- Bật mặc định cho go/rust, các ngôn ngữ khác bật thủ công qua <leader>ch.
          if client:supports_method("textDocument/inlayHint") then
            local ft = vim.bo[ev.buf].filetype
            if ft == "go" or ft == "rust" then
              vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
            end
            map("n", "<leader>ch", function()
              local filter = { bufnr = ev.buf }
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
            end, "Toggle inlay hints")
          end

          -- Code lens: `run test` / `generate` / `tidy` của gopls,
          -- `Run`/`Debug` của rust-analyzer.
          -- `codelens.enable` (Nvim 0.11+) tự refresh khi buffer đổi, không cần
          -- autocmd thủ công như `codelens.refresh` cũ (đã deprecated ở 0.13).
          if client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = ev.buf })
            map("n", "<leader>cl", vim.lsp.codelens.run, "Run code lens")
          end

          -- gopls không tự bỏ import thừa khi format -> Go build sẽ fail.
          -- Chạy `source.organizeImports` trước khi ghi file.
          if vim.bo[ev.buf].filetype == "go" then
            map("n", "<leader>co", function()
              require("util.lsp").organize_imports(ev.buf)
            end, "Organize imports")
          end
        end,
      })
    end
  }
}
