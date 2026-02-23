require("user.types")

---@type Language
local M = {}

M.lsps = {
	{
		mason_name = "zls",
		lsp_name = "zls",
		config = {
			root_markers = { "build.zig", "build.zig.zon", ".git" },
		},
	},
}

M.filetypes = { "zig", "zon" }

M.formatters = {
	{
		name = "zigfmt",
		options = {
			command = "zig",
			args = { "fmt", "--stdin" },
			stdin = true,
		},
	},
}

--  ------------------------------------------------------------------------
--  Helpers
--  ------------------------------------------------------------------------
local function root()
	return vim.fs.root(0, { "build.zig", "build.zig.zon" }) or vim.uv.cwd()
end

local function bin_dir()
	return root() .. "/zig-out/bin"
end

local function list_executables()
	local dir = bin_dir()
	local exes = {}

	local handle = vim.uv.fs_scandir(dir)
	if not handle then
		return exes
	end

	while true do
		local name, type = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end

		if type == "file" and not name:match("%.pdb$") then
			local full_path = dir .. "/" .. name
			if vim.fn.executable(full_path) == 1 then
				table.insert(exes, full_path)
			end
		end
	end

	return exes
end

local function pick_executable(cb)
	local exes = list_executables()

	if #exes == 0 then
		vim.notify("No executables found. Run :ZigBuild first.", vim.log.levels.ERROR)
		return
	end

	if #exes == 1 then
		cb(exes[1])
		return
	end

	vim.ui.select(exes, { prompt = "Select executable" }, cb)
end

local function zig_build(target, cb)
	vim.notify("Building Zig project…")

	local cmd = { "zig", "build" }
	if target then
		table.insert(cmd, target)
	end

	vim.system(cmd, { cwd = root(), text = true }, function(obj)
		vim.schedule(function()
			if obj.code == 0 then
				vim.notify("Build succeeded")
				if cb then
					cb(true)
				end
			else
				local error_msg = "Build failed"
				if obj.stderr and obj.stderr ~= "" then
					error_msg = error_msg .. ":\n" .. obj.stderr
				end
				vim.notify(error_msg, vim.log.levels.ERROR)
				if cb then
					cb(false)
				end
			end
		end)
	end)
end

local input_args = vim.schedule_wrap(function()
	local s = vim.fn.input("Arguments: ")
	return s == "" and {} or vim.split(s, " ")
end)

M.setup = function()
	local mason_utils = require("user.mason")
	mason_utils.install("codelldb")

	local dap = require("dap")

	-- Configure codelldb adapter for Zig (using executable mode for better reliability)
	dap.adapters.codelldb = {
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
		-- On Windows, you may need: detached = false,
	}

	-- Zig debug configurations
	dap.configurations.zig = {
		-- Build → pick exe → debug
		{
			name = "Build & Launch",
			type = "codelldb",
			request = "launch",
			program = function()
				local co = coroutine.running()
				local result

				zig_build(nil, function(ok)
					if ok then
						pick_executable(function(path)
							result = path
							coroutine.resume(co)
						end)
					else
						coroutine.resume(co)
					end
				end)

				coroutine.yield()
				return result
			end,
			cwd = "${workspaceFolder}",
			args = input_args,
		},

		-- Launch existing executable
		{
			name = "Launch (no build)",
			type = "codelldb",
			request = "launch",
			program = function()
				local co = coroutine.running()
				local result

				pick_executable(function(path)
					result = path
					coroutine.resume(co)
				end)

				coroutine.yield()
				return result
			end,
			cwd = "${workspaceFolder}",
			args = input_args,
		},

		-- Build & debug tests
		{
			name = "Build & Test",
			type = "codelldb",
			request = "launch",
			program = function()
				local co = coroutine.running()
				local result

				zig_build("test", function(ok)
					if ok then
						result = bin_dir() .. "/test"
					end
					coroutine.resume(co)
				end)

				coroutine.yield()
				return result
			end,
			cwd = "${workspaceFolder}",
		},

		-- Attach to PID
		{
			name = "Attach to Process",
			type = "codelldb",
			request = "attach",
			pid = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
	}
end

return M
