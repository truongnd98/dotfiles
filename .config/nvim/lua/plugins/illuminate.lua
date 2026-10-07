return {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
  opts = {
    delay = 200,
    large_file_cutoff = 2000,
    -- `large_file_overrides` THAY THẾ config cho file lớn (config.lua:39-45).
    -- Bản cũ liệt kê cả 3 provider = y hệt default, nên override không làm gì.
    -- Trên file >2000 dòng chỉ dùng `lsp`: chính xác nhất và không phải quét
    -- regex/treesitter toàn buffer mỗi lần cursor dừng.
    large_file_overrides = {
      providers = { "lsp" },
    },
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}
