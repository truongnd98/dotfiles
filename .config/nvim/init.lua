if vim.loader then
  vim.loader.enable()
end

-- `dd(value)` để debug config (xem lua/util/debug.lua). `vim.print` giữ nguyên.
_G.dd = function(...)
  require("util.debug").dump(...)
end

require("config.lazy")
