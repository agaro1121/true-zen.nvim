

local cmd = vim.cmd
local opts = require("true-zen.config").options
local before_after_cmds = require("true-zen.utils.before_after_cmd")


local function test_bool(final_opt, var)
	
	if (var == true) then
		return "setlocal "..final_opt..""
	elseif (var == false) then
		return "setlocal no"..final_opt..""
	end

end

local function test_num(final_opt, num)
	return "setlocal "..final_opt.."="..num..""
end

local function test_str(final_opt, str)
	return "setlocal "..final_opt.."="..str..""
end

local function clean_and_exec(opt, table_opt, remove_str)
	final_opt = opt:gsub(remove_str, "")
	if (type(table_opt) == "boolean") then
		to_cmd = test_bool(final_opt, table_opt)
		cmd(to_cmd)
	elseif (type(table_opt) == "number") then
		to_cmd = test_num(final_opt, table_opt)
		cmd(to_cmd)
	elseif (type(table_opt) == "string") then
		to_cmd = test_str(final_opt, table_opt)
		cmd(to_cmd)
	end
end


function map_settings(table, bool, ui_element)

	ui_element = ui_element or "NONE"


	if (bool == true) then

		if (opts["minimalist"]["store_and_restore_settings"] == true) then
			cmd("echo 'ummmmmmm HBR = "..tostring(has_been_restored).."'")

			-- if (only_here == false or only_here == nil) then
			-- before_after_cmds.restore_settings(ui_element)

			if (amount_times_ran == nil) then
				amount_times_ran = 1
			elseif (amount_times_ran == 0) then
				amount_times_ran = amount_times_ran + 1
			else
				before_after_cmds.restore_settings(ui_element)
				amount_times_ran = amount_times_ran + 1
			end


			-- end
			-- if (has_been_restored == false or has_been_restored == nil) then
			-- 	has_been_restored = before_after_cmds.restore_settings(ui_element)
			-- elseif (has_been_restored == true) then
			-- 	has_been_restored = true
			-- end
		else
			for opt, _ in pairs(table) do
				if string.find(opt, "shown_") then
					clean_and_exec(opt, table[opt], "shown_")
				else
					-- skip the option
				end
			end
		end



	elseif (bool == false) then

		-- cmd("echo 'HBR = "..tostring(has_been_restored).."'")

		if (opts["minimalist"]["store_and_restore_settings"] == true) then


			if (ui_element == "BOTTOM") then

				if (amount_times_ran == nil) then
					amount_times_ran = 1
				elseif (amount_times_ran == 0) then
					amount_times_ran = amount_times_ran + 1
				else
					bottom_has_been_restored = before_after_cmds.store_settings(table, ui_element)
					amount_times_ran = amount_times_ran + 1
				end

				--[[
				if (bottom_has_been_restored == false) then
					bottom_has_been_restored = false
					-- cmd("echo 'here!!! HBR = "..tostring(bottom_has_been_restored).."'")
					bottom_only_here = false
				elseif (bottom_has_been_restored == true or bottom_has_been_restored == nil) then
					if (bottom_only_here == false) then
						-- ignore
					else
						bottom_has_been_restored = before_after_cmds.store_settings(table, ui_element)
						-- cmd("echo '(0) I ran btw HBR = "..tostring(bottom_has_been_restored).."'")
					end
				end
				]]--
			elseif (ui_element == "TOP") then
				if (top_has_been_restored == false) then
					top_has_been_restored = false
					-- cmd("echo 'here!!! HBR = "..tostring(top_has_been_restored).."'")
					-- top_only_here = false
				elseif (top_has_been_restored == true or top_has_been_restored == nil) then
					if (top_only_here == false) then
						-- ignore
					else
						top_has_been_restored = before_after_cmds.store_settings(table, ui_element)
						-- cmd("echo '(1) I ran btw HBR = "..tostring(top_has_been_restored).."'")
					end
				end
			elseif (ui_element == "LEFT") then
				if (left_has_been_restored == false) then
					left_has_been_restored = false
					-- cmd("echo 'here!!! HBR = "..tostring(left_has_been_restored).."'")
					left_only_here = false
				elseif (left_has_been_restored == true or left_has_been_restored == nil) then
					if (left_only_here == false) then
						-- ignore
					else
						left_has_been_restored = before_after_cmds.store_settings(table, ui_element)
						-- cmd("echo '(2) I ran btw HBR = "..tostring(left_has_been_restored).."'")
					end
				end

			end



			-- if (has_been_restored == false) then
			-- 	has_been_restored = false
			-- 	cmd("echo 'here!!! HBR = "..tostring(has_been_restored).."'")
			-- 	only_here = false
			-- elseif (has_been_restored == true or has_been_restored == nil) then
			-- 	if (only_here == false) then
			-- 		-- ignore
			-- 	else
			-- 		has_been_restored = before_after_cmds.store_settings(table, ui_element)
			-- 		cmd("echo ' I ran btw HBR = "..tostring(has_been_restored).."'")
			-- 	end
			-- end
		end

		-- if (opts["minimalist"]["store_and_restore_settings"] == true) then
		-- 	if (has_been_restored == false) then
		-- 		has_been_restored = false
		-- 		cmd("echo 'here!!! HBR = "..tostring(has_been_restored).."'")
		-- 		only_here = false
		-- 	elseif (has_been_restored == true or has_been_restored == nil) then
		-- 		if (only_here == false) then
		-- 			-- ignore
		-- 		else
		-- 			has_been_restored = before_after_cmds.store_settings(table, ui_element)
		-- 			cmd("echo ' I ran btw HBR = "..tostring(has_been_restored).."'")
		-- 		end
		-- 	end
		-- end

		for opt, _ in pairs(table) do
			if string.find(opt, "hidden_") then
				clean_and_exec(opt, table[opt], "hidden_")
			else
				-- skip the option
			end
		end
	end
end



return {
	map_settings = map_settings
}
