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
				-- none-ls chỉ khai đúng một source là prettier; thiếu binary thì
				-- <leader>cf trên TS/JS/JSON/YAML/MD im lặng không làm gì.
				"prettier",
				-- for ts/js
				-- KHÔNG cài TypeScript qua Mason. TypeScript 7+ đã tích hợp LSP native
				-- (`tsc --lsp`, compiler viết lại bằng Go) và đi kèm luôn trong
				-- dependency `typescript` của project -> mỗi repo dùng đúng version của
				-- nó. Mason chỉ dẫn tới một bản global, lệch với project.
				"eslint-lsp",
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

      -- KHÔNG `require("mason-registry")` ở đây. Nó kéo theo cả registry +
      -- toàn bộ máy cài đặt (mason-registry.sources.github, mason-core.fetch,
      -- installer.InstallLocation, installer.managers.powershell...) - đo được
      -- ~116ms, tức phần lớn thời gian khởi động, cho thứ chỉ cần khi THỰC SỰ
      -- cài package. Chỉ require bên trong `:MasonInstallAll`.
      vim.api.nvim_create_user_command("MasonInstallAll", function()
        local mr = require("mason-registry")

        -- Sau khi cài xong thì bắn lại FileType để LSP vừa cài attach vào
        -- buffer đang mở, không phải restart nvim. Đăng ký ở đây thay vì lúc
        -- setup vì handler này chỉ có ý nghĩa trong luồng cài đặt.
        mr:on("package:install:success", function()
          vim.defer_fn(function()
            require("lazy.core.handler.event").trigger({
              event = "FileType",
              buf = vim.api.nvim_get_current_buf(),
            })
          end, 100)
        end)

        mr.refresh(function()
          for _, tool in ipairs(opts.ensure_installed) do
            local pkg = mr.get_package(tool)
            if not pkg:is_installed() then
              pkg:install()
            end
          end
        end)
      end, { desc = "Cài mọi tool trong ensure_installed" })
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    -- `event` quan trọng cho startup: `defaults.lazy = false` (config/lazy.lua)
    -- nghĩa là plugin nào KHÔNG có trigger lazy sẽ load ngay lúc khởi động.
    -- Bỏ dòng này đi thì mason-lspconfig thành eager và kéo cả mason.nvim +
    -- mason-registry vào startup - đo được +46ms khi mở file.
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {},
      -- rustaceanvim tự quản lý rust-analyzer (client name `rust-analyzer`).
      -- Nếu để mason-lspconfig enable thêm `rust_analyzer` sẽ có 2 client
      -- cùng attach vào buffer Rust -> duplicate diagnostics & code action.
      --
      -- `tsgo`: mason map package `tsgo` -> server `tsgo`, mà `tsgo` chỉ là alias
      -- deprecated của `tsc`. Để nó tự enable thì vừa có deprecation warning mỗi
      -- lần mở file TS, vừa bỏ qua `cmd` mình đặt cho `tsc` (nên nó sẽ cố chạy
      -- shim node và fail). Config `tsc` được enable thủ công ở lsp config.
      automatic_enable = { exclude = { "rust_analyzer", "tsgo" } },
    },
  },
  {
    "neovim/nvim-lspconfig",
    -- Lazy theo buffer: `config` dưới đây gọi
    -- `require("blink.cmp").get_lsp_capabilities()`, nên nếu để eager thì
    -- lspconfig kéo luôn blink.cmp + LuaSnip vào startup (đo được ~20ms).
    --
    -- `BufReadPre`/`BufNewFile` vẫn chạy TRƯỚC `FileType`, mà `vim.lsp.enable()`
    -- chỉ cần được gọi trước FileType để client start -> LSP vẫn attach bình
    -- thường. Đánh đổi: keymap LSP global (gd/gr/<leader>i/...) chỉ tồn tại sau
    -- khi đã mở file đầu tiên - vốn cũng là lúc duy nhất chúng có nghĩa.
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- mason.nvim prepend `<data>/mason/bin` vào PATH lúc nó setup, nhưng nó
      -- load muộn hơn file này (qua mason-lspconfig ở BufReadPre). Nghĩa là mọi
      -- `vim.fn.executable(...)` dưới đây chạy khi PATH CHƯA có mason -> luôn
      -- trả 0, và các nhánh gate không bao giờ đúng (đã verify:
      -- executable("typescript-language-server") = 0 lúc VimEnter dù nó đã cài
      -- qua Mason).
      -- Prepend tay ở đây rẻ hơn là ép mason load eager chỉ để lấy PATH.
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if vim.fn.isdirectory(mason_bin) == 1 and not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end

      -- capabilities áp một lần cho MỌI server qua `'*'`, thay vì nhắc lại
      -- `capabilities = capabilities` ở từng config.
      --
      -- Block `capabilities.textDocument.semanticTokens = { ..., tokenTypes = {},
      -- tokenModifiers = {}, ... }` cũ đã xoá: khai hai mảng đó RỖNG là nói với
      -- server "client không hỗ trợ loại token nào" - đánh nhau trực tiếp với
      -- `semanticTokens = true` đang bật cho gopls. Default của Nvim
      -- (`vim.lsp.protocol.make_client_capabilities()`) đã điền đúng danh sách
      -- tokenTypes/tokenModifiers mà Nvim biết highlight.
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- lua
      vim.lsp.enable("lua_ls")
      vim.lsp.config["lua_ls"] = {
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
      -- typescript / javascript: LSP native của TypeScript 7+
      --
      -- Tên config trong nvim-lspconfig là `tsc` (`tsgo` là alias deprecated của
      -- nó, sẽ bị bỏ ở lspconfig 3.0.0).
      --
      -- KHÔNG override `cmd`: `lsp/tsc.lua` tự dò `<root>/node_modules/.bin/tsc`
      -- trước rồi mới tới PATH, và chỉ nhận binary có `--version` >= 7. Nhờ vậy
      -- mỗi project chạy đúng version TypeScript mà nó pin.
      --
      -- Việc dò binary nằm trong `root_dir` của tsc.lua chứ không phải `cmd`, nên
      -- không thể lách bằng cách ghi đè `cmd` - nếu không tìm thấy `tsc` hỗ trợ
      -- `--lsp` thì nó không attach và báo:
      --   "tsc: no binary supporting `--lsp` found (requires TypeScript 7.0+)"
      --
      -- Điều kiện để chạy: project có `typescript` >= 7 trong devDependencies, VÀ
      -- node >= 20. `bin/tsc` của TS 7 là file không đuôi trong package
      -- `"type":"module"`; Node 18 không nạp được (ERR_UNKNOWN_FILE_EXTENSION) dù
      -- `engines` của package khai `>=16.20.0`.
      vim.lsp.enable("tsc")

      -- Js: eslint dùng `vscode-eslint-language-server` (mason: `eslint-lsp`).
      local has_eslint = vim.fn.executable("vscode-eslint-language-server") == 1
      if has_eslint then
        vim.lsp.enable("eslint")
      end

      -- Thiếu tool thì nói ra, một lần, lúc thật sự mở file TS/JS.
      if not has_eslint then
        vim.api.nvim_create_autocmd("FileType", {
          group = vim.api.nvim_create_augroup("lsp.ts_missing_tools", { clear = true }),
          pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
          once = true,
          callback = function()
            vim.notify(
              "eslint-lsp chưa cài - chạy `:MasonInstallAll` (hoặc `:Mason`)."
                .. "\n(TypeScript LSP không qua Mason: cần `typescript` >= 7 trong"
                .. " devDependencies của project và node >= 20.)",
              vim.log.levels.WARN
            )
          end,
        })
      end
      -- -- yaml
      -- vim.lsp.enable("yamlls")
      -- golang
      vim.lsp.enable("gopls")
      vim.lsp.config["gopls"] = {
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
      -- taplo không cần tuỳ biến gì thêm; capabilities đã vào qua '*'.
      vim.lsp.enable("taplo")

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
