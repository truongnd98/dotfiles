local M = {}

function M.debounce(func, waitTime)
  local lastCall = 0

  return function(...)
    local now = os.time();
    if now - lastCall < waitTime then
      return
    end

    lastCall = now
    func(...)
  end
end

return M
