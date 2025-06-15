local M = {}

function M.debounce(func, waitTime, cache)
  local lastCall = 0
  local cacheResult = nil

  return function(...)
    local now = os.time();
    if now - lastCall < waitTime then
      if cache then
        if cacheResult then
          return cacheResult
        end

        cacheResult = func(...)
        return cacheResult
      end
    end

    cacheResult = func(...)
    lastCall = now
    return cacheResult
  end
end

return M
