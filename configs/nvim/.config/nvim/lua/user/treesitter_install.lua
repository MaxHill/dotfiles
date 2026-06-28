local M = {}

local install_in_progress = false
local pending = false

---@param parsers string[]
function M.ensure_installed(parsers)
	if type(parsers) ~= "table" or #parsers == 0 then
		return
	end

	if install_in_progress then
		pending = true
		return
	end

	local ok, treesitter = pcall(require, "nvim-treesitter")
	if not ok or type(treesitter.install) ~= "function" or type(treesitter.get_installed) ~= "function" then
		return
	end

	install_in_progress = true

	local installed = {}
	for _, parser in ipairs(treesitter.get_installed("parsers") or {}) do
		installed[parser] = true
	end

	local missing = {}
	for _, parser in ipairs(parsers) do
		if not installed[parser] then
			table.insert(missing, parser)
		end
	end

	if #missing == 0 then
		install_in_progress = false
		return
	end

	treesitter.install(missing)

	vim.defer_fn(function()
		install_in_progress = false
		if pending then
			pending = false
			M.ensure_installed(parsers)
		end
	end, 300)
end

return M
