local api = vim.api
local M = {}

local function create_split()
	local height = 8
	vim.cmd("botright " .. height .. "new")
	local bufnr = api.nvim_get_current_buf()
	local win_id = api.nvim_get_current_win()

	vim.cmd([[
        highlight ReplaceLabel guifg=#00ffff gui=bold
        highlight ReplaceInputActive guibg=#1a1a3a
        highlight ReplaceMatch guibg=#404040
        highlight ReplaceCounter guifg=#ffff00 gui=bold
        highlight ReplaceCommand guifg=#808080
    ]])

	vim.bo[bufnr].buftype = "nofile"
	vim.bo[bufnr].swapfile = false
	vim.bo[bufnr].bufhidden = "wipe"

	local content = {
		"<localleader>r:Replace  <localleader>c/Esc:Cancel",
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

	local augroup = api.nvim_create_augroup("ReplacePlugin", { clear = true })
	api.nvim_create_autocmd("CursorMoved", {
		buffer = bufnr,
		group = augroup,
		callback = function()
			local cursor = api.nvim_win_get_cursor(win_id)
			local line = cursor[1] - 1
			api.nvim_buf_clear_namespace(bufnr, ns_id, 3, 4)
			api.nvim_buf_clear_namespace(bufnr, ns_id, 5, 6)
			if line == 3 then
				api.nvim_buf_add_highlight(bufnr, ns_id, "ReplaceInputActive", 3, 0, -1)
			elseif line == 5 then
				api.nvim_buf_add_highlight(bufnr, ns_id, "ReplaceInputActive", 5, 0, -1)
			end
		end,
	})

	return {
		bufnr = bufnr,
		win_id = win_id,
		ns_id = ns_id,
	}
end

local function highlight_matches(target_bufnr, pattern)
	local ns_id = api.nvim_create_namespace("replace_match_highlight")
	api.nvim_buf_clear_namespace(target_bufnr, ns_id, 0, -1)
	local lines = api.nvim_buf_get_lines(target_bufnr, 0, -1, false)
	local match_count = 0
	for i, line in ipairs(lines) do
		local start = 1
		while true do
			local match_start, match_end = line:find(pattern, start)
			if not match_start then
				break
			end
			api.nvim_buf_add_highlight(target_bufnr, ns_id, "ReplaceMatch", i - 1, match_start - 1, match_end)
			start = match_end + 1
			match_count = match_count + 1
		end
	end
	return match_count
end

local function perform_replace(win_state, target_bufnr)
	local bufnr = win_state.bufnr
	local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local find_text = lines[4]
	local replace_text = lines[6]

	if find_text == "" then
		vim.api.nvim_echo({ { " No search text provided", "WarningMsg" } }, false, {})
		return false
	end

	local count = 0
	local lines_modified = {}
	local buffer_lines = api.nvim_buf_get_lines(target_bufnr, 0, -1, false)

	for i, line in ipairs(buffer_lines) do
		local new_line, num_replaced = line:gsub(vim.pesc(find_text), replace_text)
		if num_replaced > 0 then
			count = count + num_replaced
			lines_modified[i] = new_line
		else
			lines_modified[i] = line
		end
	end

	if count > 0 then
		api.nvim_buf_set_lines(target_bufnr, 0, -1, false, lines_modified)
	end

	vim.api.nvim_echo({ { count .. " replacements made", "Normal" } }, false, {})

	return true
end

function M.replace()
	local target_bufnr = api.nvim_get_current_buf()
	local win_state = create_split()
	local bufnr, win_id = win_state.bufnr, win_state.win_id

	local function close_window()
		api.nvim_win_close(win_id, true)
	end

	local function update_highlights()
		local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local find_text = lines[4]
		if find_text ~= "" then
			local match_count = highlight_matches(target_bufnr, vim.pesc(find_text))
			local counter_text = string.format("%d matches", match_count)
			api.nvim_buf_set_lines(bufnr, 7, 8, false, { counter_text })
			api.nvim_buf_add_highlight(bufnr, win_state.ns_id, "ReplaceCounter", 7, 0, -1)
		else
			api.nvim_buf_set_lines(bufnr, 7, 8, false, { "" })
		end
	end

	local normal_mode_mappings = {
		["<localleader>r"] = perform_replace,
		["<localleader>c"] = close_window,
		["<Esc>"] = close_window,
	}

	for k, v in pairs(normal_mode_mappings) do
		api.nvim_buf_set_keymap(bufnr, "n", k, "", {
			callback = function()
				v(win_state, target_bufnr)
			end,
			noremap = true,
			silent = true,
		})
	end

	api.nvim_buf_set_keymap(bufnr, "i", "<CR>", "<Esc>", {
		noremap = true,
		silent = true,
	})

	api.nvim_create_autocmd("TextChanged", {
		buffer = bufnr,
		callback = update_highlights,
	})

	api.nvim_create_autocmd("TextChangedI", {
		buffer = bufnr,
		callback = update_highlights,
	})

	update_highlights()

	-- Set cursor to the "Find what:" field
	api.nvim_win_set_cursor(win_id, { 4, 0 })
	vim.cmd("startinsert!")
end

return M
