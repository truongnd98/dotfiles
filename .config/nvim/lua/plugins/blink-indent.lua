return {
  "saghen/blink.indent",
  -- Indent guide chỉ có nghĩa khi đã có buffer thật.
  event = { "BufReadPost", "BufNewFile" },
  --- @module "blink.indent"
  --- @type blink.indent.Config
  -- opts = {},
}
