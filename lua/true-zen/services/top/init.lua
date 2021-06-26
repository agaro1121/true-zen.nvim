local service = require("true-zen.services.top.service")
local cmd = vim.cmd
local api = vim.api

local M = {}

local function get_status()
    return top_show
end

local function set_status(value)
    top_show = value
end

local function on()
    service.on()
    set_status("on")
end

local function off()
    service.off()
    set_status("off")
end

local function toggle()
    if (get_status() == "on") then
        off()
    elseif (get_status() == "off") then
        on()
    else
        if (api.nvim_eval("&showtabline > 0") == 1) then
            off()
        else
            on()
        end
    end
end

function M.main(option)
    option = option or 0

    if (option == 'toggle') then
        toggle()
    elseif (option == 'on') then
		on()
    elseif (option == 'off') then
		off()
    end
end

return M
