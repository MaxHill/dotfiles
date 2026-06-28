require("user.types")

---@type Language
local M = {}

M.setup = function()
	vim.filetype.add({
		extension = {
			prr = "prr",
		},
	})

	local function ensure_prr_runtime()
		local candidates = vim.fn.globpath(vim.o.packpath, "pack/*/*/prr", false, true)
		for _, root in ipairs(candidates) do
			local vim_dir = root .. "/vim"
			if vim.fn.isdirectory(vim_dir) == 1 then
				local rtp = vim.split(vim.o.runtimepath, ",", { trimempty = true })
				if not vim.tbl_contains(rtp, vim_dir) then
					vim.opt.runtimepath:append(vim_dir)
				end
				return
			end
		end
	end

	ensure_prr_runtime()

	local prr_group = vim.api.nvim_create_augroup("Prr", { clear = true })

	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		group = prr_group,
		pattern = "*.prr",
		callback = function()
			ensure_prr_runtime()
			vim.cmd("set syntax=on")
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = prr_group,
		pattern = "prr",
		callback = function()
			-- Open folds by default for easier review reading
			vim.opt_local.foldlevel = 9999

			-- Optional highlight tuning from prr docs
			vim.cmd("hi! link prrAdded Function")
			vim.cmd("hi! link prrRemoved Keyword")
			vim.cmd("hi! link prrFile Special")
			vim.cmd("hi! link prrHeader Directory")
			vim.cmd("hi! link prrIndex Special")
			vim.cmd("hi! link prrChunk Special")
			vim.cmd("hi! link prrChunkH Special")
			vim.cmd("hi! link prrTagName Special")
			vim.cmd("hi! link prrResult Special")
		end,
	})
end

return M
