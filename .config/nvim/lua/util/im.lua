local M = {
  current_engine = nil,
}

local IM_EN = "com.apple.keylayout.ABC"
local IM_VN = "com.apple.inputmethod.VietnameseIM.VietnameseTelex"


function M.loadCurrentEngine()
    local stdout = vim.loop.new_pipe(false)
    local stdout_chunks = {}
    local handle
    handle = vim.loop.spawn("im-select", { args = { }, stdio = { nil, stdout, nil } }, function (code, _signal)
      stdout:close()
      handle:close()
      if code == 0 then
        local im_cur_engine = table.concat(stdout_chunks)
        im_cur_engine = string.gsub(im_cur_engine, "\n$", "")

        if im_cur_engine == IM_EN then
          M.current_engine = "EN"
          return
        end

        if im_cur_engine == IM_VN then
          M.current_engine = "VN"
          return
        end

        M.current_engine = "UNKNOW"
      end
    end)
    -- Read STDOUT
    stdout:read_start(function(err, data)
      assert(not err, err)
      if data then
        table.insert(stdout_chunks, data)
      end
    end)
  end

function M.getIMEngine()
  return require("util.per").debounce(function ()
    if M.current_engine then
      M.loadCurrentEngine()
      return M.current_engine
    end

    M.loadCurrentEngine()
  end, 0.5, true)
end


function M.offIM()
  if M.current_engine == "EN" then
    return
  end

  local handle
  handle = vim.loop.spawn("im-select", { args = { IM_EN } }, function (code, _signal)
    handle:close()
    if code == 0 then
      M.current_engine = "EN"
    end
  end)
end

return M
