local service = require("true-zen.services.modes.mode-ataraxis.service")
local opts = require("true-zen.config").options
-- local truezen = require("true-zen.init")

local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local M = {}

local function get_status()
    return status_mode_ataraxis
end

local function set_status(value)
    status_mode_ataraxis = value
end

local function eval_main_window()
    vim.cmd(
        [[windo if &ma | if exists("b:truezen_main_window_id") | let g:truezen_main_window = b:truezen_main_window_id | endif | endif]]
    )
end

local function autocmds(state)
    if (state == "start") then
        api.nvim_exec(
            [[
			augroup truezen_mode_ataraxis
				autocmd!
				autocmd WinEnter * if exists("w:truezen_window") | execute "lua require'true-zen.services.modes.mode-ataraxis.init'.resume()" | endif
			augroup END
		]],
            false
        )
    elseif (state == "stop") then
        api.nvim_exec([[
			augroup truezen_mode_ataraxis
				autocmd!
			augroup END
		]], false)
    end
end

local function get_win_dimensions()
    local dimensions = {}
    dimensions["x_axis"] = api.nvim_eval([[winwidth('%')]])
    dimensions["y_axis"] = api.nvim_eval([[winheight('%')]])

    return dimensions
end

local function on()
    service.on()
    autocmds("start")
    set_status("on")
end

local function off()
    autocmds("stop")
    service.off()
    set_status("off")
end

function M.resume()
    if (service.get_layout() ~= api.nvim_eval("winrestcmd()")) then
		autocmds("stop")

		local is_integration_noclc_enabled = opts["integrations"]["noclc"]
		local exists_cursorline = api.nvim_eval([[exists("#noclc_active_window_buffer_cursorline")]])
		local exists_cursorcolumn = api.nvim_eval([[exists("#noclc_active_window_buffer_cursorcolumn")]])

		print("exists_cursorline = "..exists_cursorline.."; exists_cursorcolumn = "..exists_cursorcolumn)

        print("closing all windows without truezen_buffer var...")

		if (is_integration_noclc_enabled == true) then
			local integration_noclc = require("true-zen.services.integrations.noclc")
			if (exists_cursorline == 1) then integration_noclc.disable_element("cursorline") end
			if (exists_cursorcolumn == 1) then integration_noclc.disable_element("cursorcolumn") end
		end

		cmd([[call g:TrueZenWinDo("if !exists('w:truezen_window') | :q | endif")]])


        print("loading layout...")
		cmd(service.get_layout())

        print("getting id of only the window that is modifiable...")
        print("going to the main window by id...")



		cmd([[call win_gotoid(g:truezen_main_window)]])

		-- if (is_integration_noclc_enabled == true) then
		-- 	local integration_noclc = require("true-zen.services.integrations.noclc")
		-- 	if (exists_cursorline == 1) then integration_noclc.enable_element("cursorline") end
		-- 	if (exists_cursorcolumn == 1) then integration_noclc.enable_element("cursorcolumn") end
		-- end

		autocmds("start")
    else
        print("Layout is still the same")
    end
end

local function toggle()
    if (get_status() == "on") then
        off()
    else
        on()
    end
end

function M.main(option)
    option = option or 0

    if (option == "toggle") then
        toggle()
    elseif (option == "on") then
        on()
    elseif (option == "off") then
        off()
    end
end

return M
