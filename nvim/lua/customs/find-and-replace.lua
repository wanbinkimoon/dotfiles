--[[
Find and Replace Plugin for Neovim
==================================

This plugin provides an interactive find and replace functionality for Neovim.

Features:
- Interactive split window for find and replace operations
- Highlights all matches in the target buffer
- Allows per-instance or global substitution
- Navigation between matches
- Undo last action

Usage:
- Call the `replace()` function to open the find and replace window
- Enter the search text and replacement text
- Use the following commands in normal mode:
  <localleader>r : Replace all instances
  <localleader>s : Replace selected instance
  <localleader>n : Select next instance
  <localleader>p : Select previous instance
  <localleader>u : Undo last action
  <localleader>c : Close the find and replace window
  Esc           : Close the find and replace window

Installation:
1. Place this file in your Neovim configuration directory (e.g., ~/.config/nvim/lua/custom/)
2. Add the following to your init.lua:
   local replace = require('custom.find-and-replace')
   vim.api.nvim_create_user_command('Replace', replace.replace, {})

You can then use the `:Replace` command to start the find and replace process.
]]

local api = vim.api
local M = {}

-- Create the split window for find and replace
local function create_split()
  local height = 8
  vim.cmd("botright " .. height .. "new")
  local bufnr = api.nvim_get_current_buf()
  local win_id = api.nvim_get_current_win()

  -- Set up highlight groups
  vim.cmd([[
    highlight link ReplaceLabel Label
    highlight link ReplaceInputActive CursorLine
    highlight link ReplaceMatch Search
    highlight link ReplaceCounter MoreMsg
    highlight link ReplaceCommand Comment
    highlight link ReplaceSelectedMatch IncSearch
  ]])

  -- Set buffer options
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].bufhidden = "wipe"

  -- Set up the content of the split
  local content = {
    "<ll>r:Replace All  <ll>s:Replace Selected  <ll>n:Next  <ll>p:Prev  <ll>u:Undo  <ll>c/Esc:Cancel",
    "",
    "Find what:",
    "",
    "Replace with:",
    "",
    "",
    "",
  }
  api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
  local ns_id = api.nvim_create_namespace("replace_highlight")
  api.nvim_buf_add_highlight(bufnr, ns_id, "ReplaceCommand", 0, 0, -1)
  api.nvim_buf_add_highlight(bufnr, ns_id, "ReplaceLabel", 2, 0, 10)
  api.nvim_buf_add_highlight(bufnr, ns_id, "ReplaceLabel", 4, 0, 12)

  return {
    bufnr = bufnr,
    win_id = win_id,
    ns_id = ns_id,
  }
end

-- Highlight all matches in the target buffer
local function highlight_matches(target_bufnr, pattern)
  local ns_id = api.nvim_create_namespace("replace_match_highlight")
  api.nvim_buf_clear_namespace(target_bufnr, ns_id, 0, -1)
  local lines = api.nvim_buf_get_lines(target_bufnr, 0, -1, false)
  local matches = {}
  for i, line in ipairs(lines) do
    local start = 1
    while true do
      local match_start, match_end = line:find(pattern, start)
      if not match_start then
        break
      end
      table.insert(matches, { line = i - 1, col_start = match_start - 1, col_end = match_end })
      api.nvim_buf_add_highlight(target_bufnr, ns_id, "ReplaceMatch", i - 1, match_start - 1, match_end)
      start = match_end + 1
    end
  end
  return matches
end

-- Update highlights and match count
local function update_highlights(win_state, target_bufnr)
  local bufnr = win_state.bufnr
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local find_text = lines[4]
  if find_text ~= "" then
    win_state.matches = highlight_matches(target_bufnr, vim.pesc(find_text))
    local counter_text = string.format("%d matches", #win_state.matches)
    api.nvim_buf_set_lines(bufnr, 7, 8, false, { counter_text })
    api.nvim_buf_add_highlight(bufnr, win_state.ns_id, "ReplaceCounter", 7, 0, -1)
    if #win_state.matches > 0 then
      local current_match = win_state.matches[win_state.current_match_index]
      api.nvim_buf_clear_namespace(target_bufnr, api.nvim_create_namespace("replace_selected_match"), 0, -1)
      api.nvim_buf_add_highlight(
        target_bufnr,
        api.nvim_create_namespace("replace_selected_match"),
        "ReplaceSelectedMatch",
        current_match.line,
        current_match.col_start,
        current_match.col_end
      )
    end
  else
    win_state.matches = {}
    win_state.current_match_index = 1
    api.nvim_buf_set_lines(bufnr, 7, 8, false, { "" })
  end
end

-- Perform the replacement operation
local function perform_replace(win_state, target_bufnr, replace_all)
  local bufnr = win_state.bufnr
  local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local find_text = lines[4]
  local replace_text = lines[6]

  if find_text == "" then
    vim.api.nvim_echo({ { " No search text provided", "WarningMsg" } }, false, {})
    return false
  end

  local count = 0
  local lines_modified = vim.deepcopy(api.nvim_buf_get_lines(target_bufnr, 0, -1, false))

  if replace_all then
    -- Replace all instances
    for i, line in ipairs(lines_modified) do
      local new_line, num_replaced = line:gsub(vim.pesc(find_text), replace_text)
      if num_replaced > 0 then
        count = count + num_replaced
        lines_modified[i] = new_line
      end
    end
  else
    -- Replace only the selected instance
    local current_match = win_state.matches[win_state.current_match_index]
    if current_match then
      local line = lines_modified[current_match.line + 1]
      local before = line:sub(1, current_match.col_start)
      local after = line:sub(current_match.col_end + 1)
      lines_modified[current_match.line + 1] = before .. replace_text .. after
      count = 1
    end
  end

  if count > 0 then
    -- Store the current state for undo
    table.insert(win_state.undo_stack, api.nvim_buf_get_lines(target_bufnr, 0, -1, false))

    api.nvim_buf_set_lines(target_bufnr, 0, -1, false, lines_modified)
    vim.api.nvim_echo({ { count .. " replacements made", "Normal" } }, false, {})

    -- Update matches
    win_state.matches = highlight_matches(target_bufnr, vim.pesc(find_text))

    -- Adjust the current_match_index for single replacement
    if not replace_all then
      if win_state.current_match_index > #win_state.matches then
        win_state.current_match_index = 1
      end
      -- If we're at the last match, cycle back to the first
      if win_state.current_match_index == #win_state.matches then
        win_state.current_match_index = 1
      end
    end

    update_highlights(win_state, target_bufnr)
  end

  return true
end

-- Main function to initiate the find and replace process
function M.replace()
  local target_bufnr = api.nvim_get_current_buf()
  local win_state = create_split()
  local bufnr, win_id = win_state.bufnr, win_state.win_id
  win_state.matches = {}
  win_state.current_match_index = 1 -- Start with the first occurrence selected
  win_state.undo_stack = {}

  -- Close the find and replace window
  local function close_window()
    api.nvim_win_close(win_id, true)
    api.nvim_buf_clear_namespace(target_bufnr, api.nvim_create_namespace("replace_match_highlight"), 0, -1)
    api.nvim_buf_clear_namespace(target_bufnr, api.nvim_create_namespace("replace_selected_match"), 0, -1)
  end

  -- Select next or previous match
  local function select_match(direction)
    if #win_state.matches == 0 then
      return
    end
    win_state.current_match_index = win_state.current_match_index + direction
    if win_state.current_match_index > #win_state.matches then
      win_state.current_match_index = 1
    elseif win_state.current_match_index < 1 then
      win_state.current_match_index = #win_state.matches
    end
    update_highlights(win_state, target_bufnr)
  end

  -- Undo last action
  local function undo_last_action()
    if #win_state.undo_stack > 0 then
      local last_state = table.remove(win_state.undo_stack)
      api.nvim_buf_set_lines(target_bufnr, 0, -1, false, last_state)
      update_highlights(win_state, target_bufnr)
      vim.api.nvim_echo({ { "Last action undone", "Normal" } }, false, {})
    else
      vim.api.nvim_echo({ { "No more actions to undo", "WarningMsg" } }, false, {})
    end
  end

  -- Set up key mappings
  local normal_mode_mappings = {
    ["<localleader>r"] = function()
      perform_replace(win_state, target_bufnr, true)
    end,
    ["<localleader>s"] = function()
      perform_replace(win_state, target_bufnr, false)
    end,
    ["<localleader>n"] = function()
      select_match(1)
    end,
    ["<localleader>p"] = function()
      select_match(-1)
    end,
    ["<localleader>u"] = undo_last_action,
    ["<localleader>c"] = close_window,
    ["<Esc>"] = close_window,
  }

  for k, v in pairs(normal_mode_mappings) do
    api.nvim_buf_set_keymap(bufnr, "n", k, "", {
      callback = v,
      noremap = true,
      silent = true,
    })
  end

  api.nvim_buf_set_keymap(bufnr, "i", "<CR>", "<Esc>", {
    noremap = true,
    silent = true,
  })

  -- Set up autocommands to update highlights on text change
  api.nvim_create_autocmd("TextChanged", {
    buffer = bufnr,
    callback = function()
      update_highlights(win_state, target_bufnr)
    end,
  })

  api.nvim_create_autocmd("TextChangedI", {
    buffer = bufnr,
    callback = function()
      update_highlights(win_state, target_bufnr)
    end,
  })

  -- Initial highlight update
  update_highlights(win_state, target_bufnr)

  -- Set cursor to the "Find what:" field and enter insert mode
  api.nvim_win_set_cursor(win_id, { 4, 0 })
  vim.cmd("startinsert!")
end

return M
