M = {}

M.mod_file = nil
M.asset_files = {}

M.toggle = function(pattern)
	if M.mod_file == nil then
		M.open_assets(pattern)
	else
		M.close_assets()
	end
end

-- local pattern = "%.*css$"
M.open_assets = function(pattern)
	local mod_file = vim.api.nvim_get_current_buf()
	local cwDir = vim.fn.expand("%:p:h")
	local matching_files = Get_matching_files(cwDir, pattern)

	if next(matching_files) ~= nil then
		M.mod_file = mod_file
	else
		print("No files found...")
	end

	for _, value in pairs(matching_files) do --actualcode
		vim.cmd("vsplit " .. value)
		table.insert(M.asset_files, vim.api.nvim_get_current_buf())
	end
end

M.close_assets = function()
	for _, buffer in pairs(M.asset_files) do
		vim.api.nvim_buf_delete(buffer, {})
	end
	M.mod_file = nil
	M.asset_files = {}
end

function Get_matching_files(dir, pattern)
	---@type string[]
	local dirContent = vim.split(vim.fn.glob(dir .. "/*"), "\n", { trimempty = true })
	local files = {}
	for _, item in pairs(dirContent) do
		if string.find(item, pattern) then
			table.insert(files, item)
		end
	end

	return files
end

return M
