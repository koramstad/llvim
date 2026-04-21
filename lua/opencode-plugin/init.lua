local M = {}

local layout = nil
local popup_top = nil
local popup_bottom = nil

function M.close()
	if layout then
		layout:unmount()
		layout = nil
		popup_top = nil
		popup_bottom = nil
	end
end

function M.open()
	M.close()

	local Popup = require("nui.popup")
	local Layout = require("nui.layout")

	popup_top = Popup({
		border = "rounded",
		enter = false,
	})

	popup_bottom = Popup({
		border = "rounded",
		enter = false,
	})

	layout = Layout(
		{
			position = "50%",
			size = { width = 80, height = 40 },
			relative = "editor",
		},
		Layout.Box({
			Layout.Box(popup_top, { size = "40%" }),
			Layout.Box(popup_bottom, { size = "60%" }),
		}, { dir = "col" })
	)

	layout:mount()

	vim.api.nvim_set_option_value("wrap", true, { win = popup_top.winid })
	vim.api.nvim_set_option_value("wrap", true, { win = popup_bottom.winid })

	popup_top:map("n", "<CR>", function()
		local top_buf = popup_top.bufnr
		local bottom_buf = popup_bottom.bufnr
		local lines = vim.api.nvim_buf_get_lines(top_buf, 0, -1, false)
		local prompt = table.concat(lines, "\n")

		vim.api.nvim_set_option_value("readonly", false, { buf = bottom_buf })
		vim.api.nvim_set_option_value("modifiable", true, { buf = bottom_buf })

		local current_lines = vim.api.nvim_buf_get_lines(bottom_buf, 0, -1, false)

		if #current_lines > 0 then
			table.insert(current_lines, "")
			table.insert(current_lines, "")
		end

		local prompt_lines = vim.split("> " .. prompt, "\n", { plain = true })
		for _, line in ipairs(prompt_lines) do
			table.insert(current_lines, line)
		end
		vim.api.nvim_buf_set_lines(bottom_buf, 0, -1, false, current_lines)
		vim.api.nvim_win_set_cursor(popup_bottom.winid, { vim.api.nvim_buf_line_count(bottom_buf), 1 })

		local buffer = {}
		local function flush_buffer()
			if #buffer > 0 then
				local flush_lines = vim.api.nvim_buf_get_lines(bottom_buf, 0, -1, false)
				for _, line in ipairs(buffer) do
					line = vim.trim(line)
					if line ~= "" then
						for _, sub in ipairs(vim.split(line, "\n", { plain = true })) do
							table.insert(flush_lines, sub)
						end
					end
				end
				vim.api.nvim_buf_set_lines(bottom_buf, 0, -1, false, flush_lines)
				vim.api.nvim_win_set_cursor(popup_bottom.winid, { vim.api.nvim_buf_line_count(bottom_buf), 1 })
				buffer = {}
			end
		end

		local function on_stdout(_, data)
			if data then
				for _, line in ipairs(data) do
					if line ~= "" and line:match("^%{") then
						local ok, json = pcall(vim.json.decode, line)
						if ok and json and json.type == "text" and json.part and json.part.text then
							local text = json.part.text
							if text then
								table.insert(buffer, text)
							end
						end
					end
				end
				flush_buffer()
			end
		end

		local function on_stderr(_, data)
			if data then
				local stderr_lines = vim.api.nvim_buf_get_lines(bottom_buf, 0, -1, false)
				for _, line in ipairs(data) do
					if line ~= "" then
						table.insert(stderr_lines, "[stderr] " .. line)
					end
				end
				vim.api.nvim_buf_set_lines(bottom_buf, 0, -1, false, stderr_lines)
			end
		end

		local function on_exit(_, _)
			vim.api.nvim_set_option_value("readonly", true, { buf = bottom_buf })
			vim.api.nvim_set_option_value("modifiable", false, { buf = bottom_buf })
		end

		vim.fn.jobstart({
			"script",
			"-q",
			"-c",
			"/home/koramstad/.opencode/bin/opencode run " .. vim.fn.shellescape(prompt) .. " --format json",
		}, {
			pty = true,
			stdout_buffered = false,
			on_stdout = on_stdout,
			on_stderr = on_stderr,
			on_exit = on_exit,
		})
	end)

	vim.api.nvim_set_current_win(popup_top.winid)
	vim.cmd("startinsert")
end

return M
