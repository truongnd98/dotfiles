return {
  "akinsho/nvim-toggleterm.lua",
  keys = {
    {
      "<leader>t",
      function()
        local window_id = vim.api.nvim_get_current_win()
        local term_window_id = vim.g.self_toggleterm_window_id

        -- Terminal doesn"t exist so create it
        if term_window_id == nil or term_window_id < 0 then
          vim.cmd("ToggleTerm size=100 direction=float")
          -- Terminal exists but it"s not focused so focus it
        elseif window_id ~= term_window_id then
          vim.api.nvim_set_current_win(vim.g.self_toggleterm_window_id)
          vim.cmd("startinsert!")
          -- Terminal exists and it"s focused so focus last window
        else
          vim.cmd("wincmd p")
        end
      end,
      desc = "Toggle or focus float terminal",
    },
    {
      "<leader>T",
      function()
        vim.cmd("ToggleTerm size=100 direction=float")
      end,
      desc = "Toggle float terminal",
    },
  },
  config = function()
    -- Keymap mode `t` phải gắn vào CHÍNH buffer terminal. Trước đây chúng được
    -- set với `{ buffer = 0 }` ngay trong `config`, nghĩa là gắn vào buffer
    -- đang current lúc plugin load (file source đầu tiên) - nên chưa bao giờ
    -- chạy. `on_open` cho đúng `term.bufnr`.
    local function term_keymaps(bufnr)
      local function map(lhs, rhs)
        vim.keymap.set("t", lhs, rhs, { buffer = bufnr, silent = true })
      end
      map("jk", [[<C-\><C-n>]])
      map("<C-h>", [[<Cmd>wincmd h<CR>]])
      map("<C-j>", [[<Cmd>wincmd j<CR>]])
      map("<C-k>", [[<Cmd>wincmd k<CR>]])
      map("<C-l>", [[<Cmd>wincmd l<CR>]])
      map("<C-w>", [[<C-\><C-n><C-w>]])
    end

    require("toggleterm").setup({
      shade_terminals = false,
      auto_scroll = false,
      autochdir = true,
      on_open = function(term)
        vim.g.self_toggleterm_window_id = vim.api.nvim_get_current_win()
        term_keymaps(term.bufnr)
      end,
      on_close = function(term)
        vim.g.self_toggleterm_window_id = -1
      end,
    })

    -- -- We can use <esc><esc> to be able to use a single <esc> in the terminal Vi mode.
    -- -- vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", [[<C-\><C-o>:ToggleTerm<CR>]], { noremap = true })
    -- -- or we can use a single escape
    -- -- https://github.com/akinsho/toggleterm.nvim/issues/365
    -- vim.api.nvim_del_keymap("t", "<esc><esc>") -- default lazyvim bind
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { noremap = true })
  end,
}
