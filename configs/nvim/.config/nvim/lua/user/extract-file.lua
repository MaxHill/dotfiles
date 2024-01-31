local M = {}

M.extract_selection_to_file = function()
	local path = vim.fn.expand('%:h');
	local name = vim.fn.input(path)

	local full_file_path = vim.fn.expand('%:p:h') .. name;

	-- Cut current selection
	vim.cmd.normal { '"zd', bang = true }                                 -- save to register 'z'
	vim.cmd("call writefile(getreg('z', 1, 1), '" .. full_file_path .. "')") -- write register 'z' to full_file_path
end

return M
