--[[ Split a string into lines. ]]
local function split_lines(txt)
	return vim.fn.split(txt, "\n")
end

--[[ Find files in the runtime path. ]]
local function glob_runtimepath(pattern)
	local runtime_path = vim.fn.escape(vim.o.runtimepath, " ")
	local search_result = vim.fn.globpath(runtime_path, pattern)
	return split_lines(search_result)
end

-- Load snippets from JSON files (VSCode syntax)
require("luasnip/loaders/from_vscode").lazy_load({
	paths = {
		vim.fn.stdpath("config") .. "/snippets",
	},
})
