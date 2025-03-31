local M = {}

-- Maximum memory usage before aggressive buffer cleanup (in MB)
local MAX_MEMORY_USAGE = 1000

-- Check memory usage and clean buffers if needed
function M.check_memory_usage()
  local memory_usage = vim.loop.resident_set_memory() / 1024 / 1024
  if memory_usage > MAX_MEMORY_USAGE then
    M.clean_inactive_buffers()
    collectgarbage("collect")
  end
end

-- Clean inactive buffers more aggressively
function M.clean_inactive_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  
  for _, buf in ipairs(buffers) do
    -- Skip current buffer
    if buf ~= current_buf then
      -- Skip modified buffers
      if not vim.api.nvim_buf_get_option(buf, "modified") then
        -- Check if buffer is displayed in any window
        local windows = vim.fn.win_findbuf(buf)
        if #windows == 0 then
          -- Check if it's a special buffer type we want to keep
          local ft = vim.api.nvim_buf_get_option(buf, "filetype")
          if not vim.tbl_contains({"help", "fugitive", "neo-tree", "lazy"}, ft) then
            vim.api.nvim_buf_delete(buf, {})
          end
        end
      end
    end
  end
end

-- Setup periodic memory checks
function M.setup()
  -- Check memory usage periodically (every 5 minutes)
  vim.api.nvim_create_autocmd({"CursorHold", "BufEnter"}, {
    callback = function()
      -- Only run occasionally to avoid performance impact
      if math.random() < 0.1 then  -- 10% chance to run on each event
        M.check_memory_usage()
      end
    end,
  })
  
  -- Add command to manually clean buffers
  vim.api.nvim_create_user_command("CleanBuffers", function()
    M.clean_inactive_buffers()
    vim.notify("Cleaned inactive buffers")
  end, {})
end

return M
