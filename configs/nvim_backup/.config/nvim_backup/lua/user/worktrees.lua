local wt = require("git-worktree")
wt.setup({})

require("telescope").load_extension("git_worktree")

local execute = vim.api.nvim_command
wt.on_tree_change(function(op, metadata)
	if op == wt.Operations.Switch then
		print("Switched from " .. metadata.prev_path .. " to " .. metadata.path)

		if vim.fn.filereadable(metadata.path .. "/yarn.lock") ~= 0 then
			execute("!yarn install")
		elseif vim.fn.filereadable(metadata.path .. "/package.json") ~= 0 then
			execute("!npm install")
		end
	end
	if op == wt.Operations.Create then
		print("Crated from " .. metadata.path)
	end
	if op == wt.Operations.Delete then
		print("Deleted from " .. metadata.path)
	end
end)
