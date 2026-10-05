-- Go: gopls đã lo LSP/format/codelens (xem lua/plugins/lsp.lua).
-- go.nvim ở đây chỉ dùng cho phần codegen mà gopls không làm được:
-- struct tag, `if err != nil`, impl interface, fill struct/switch, doc comment.
return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- UI picker cho :GoImpl
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "go", "gomod", "gowork", "gotmpl" },
    build = ':lua require("go.install").update_all_sync()',
    opts = {
      -- Tắt hết phần chồng chéo với setup sẵn có.
      lsp_cfg = false,          -- gopls do lua/plugins/lsp.lua cấu hình
      lsp_keymaps = false,      -- keymap LSP dùng chung ở LspAttach
      lsp_inlay_hints = { enable = false }, -- bật qua vim.lsp.inlay_hint
      dap_debug = false,        -- dùng nvim-dap-go
      dap_debug_gui = false,
      trouble = false,
      luasnip = false,
      null_ls_document_formatting_disable = true,
      verbose = false,

      gofmt = "gofumpt",
      -- Tag mặc định khi gọi :GoAddTag không kèm tham số.
      tag_transform = "camelcase",
      tag_options = "json=omitempty",
      comment_placeholder = "",
    },
    config = function(_, opts)
      require("go").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("go.keymaps", { clear = true }),
        pattern = { "go", "gomod", "gowork" },
        callback = function(ev)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
          end

          -- <leader>m = menu lệnh riêng của ngôn ngữ (đồng bộ với Rust)
          map("<leader>mt", "<cmd>GoAddTag<cr>", "Add struct tag (json)")
          map("<leader>mT", "<cmd>GoRmTag<cr>", "Remove struct tag")
          map("<leader>mi", "<cmd>GoIfErr<cr>", "Insert `if err != nil`")
          map("<leader>mI", "<cmd>GoImpl<cr>", "Implement interface")
          map("<leader>mf", "<cmd>GoFillStruct<cr>", "Fill struct literal")
          map("<leader>ms", "<cmd>GoFillSwitch<cr>", "Fill switch cases")
          map("<leader>mc", "<cmd>GoCmt<cr>", "Generate doc comment")
          map("<leader>mo", "<cmd>GoAlt!<cr>", "Open alternate (_test.go)")
          map("<leader>mm", "<cmd>GoModTidy<cr>", "go mod tidy")
          map("<leader>mg", "<cmd>GoGenerate<cr>", "go generate")
          map("<leader>mC", "<cmd>GoCoverage -t<cr>", "Toggle coverage overlay")
          map("<leader>mv", "<cmd>GoVet<cr>", "go vet")
        end,
      })
    end,
  },
}
