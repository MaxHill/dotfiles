local M = {}

local options = {
	["one"] = function()
		vim.notify("one fn")
	end,
	["two"] = function()
		vim.notify("two fn")
	end
}
-- Select one option from the table and run the function
M.select_file = function()
	local keys = vim.tbl_keys(options)
	table.sort(keys)
	vim.ui.select(keys, {
		prompt = "testing"
	}, function(choice)
		if not choice then
			return
		end
		options[choice]()
	end)
end

M.select_file()

return M
