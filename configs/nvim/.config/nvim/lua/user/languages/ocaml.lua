require("user.types")

---@type Language
local M = {}

local ocaml_root_markers = { "dune-project", "dune-workspace", "_opam" }

local function find_ocaml_root(path)
	if not path or path == "" then
		return nil
	end

	local nearest_project_file = vim.fs.find(function(name)
		return name == "dune-project" or name == "_opam" or name:match("%.opam$") ~= nil
	end, { path = vim.fs.dirname(path), upward = true })[1]

	if nearest_project_file then
		return vim.fs.dirname(nearest_project_file)
	end

	return vim.fs.root(path, { "dune-workspace" })
end

local function has_local_switch(root)
	return root and vim.uv.fs_stat(root .. "/_opam") ~= nil
end

local function opam_exec_args(root, command)
	local args = { "exec" }

	if has_local_switch(root) then
		table.insert(args, "--switch=" .. root)
	end

	table.insert(args, "--")
	vim.list_extend(args, command)
	return args
end

local function collect_bytecode_programs(dir, programs)
	local results = programs or {}
	local handle = vim.uv.fs_scandir(dir)
	if not handle then
		return results
	end

	while true do
		local name, entry_type = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end

		local path = dir .. "/" .. name
		if entry_type == "directory" then
			collect_bytecode_programs(path, results)
		elseif entry_type == "file" and name:match("%.bc$") then
			table.insert(results, path)
		end
	end

	return results
end

local function pick_bytecode_program(bufnr)
	local file_path = vim.api.nvim_buf_get_name(bufnr)
	local root = find_ocaml_root(file_path) or vim.uv.cwd()
	local build_dir = root .. "/_build/default"
	local programs = collect_bytecode_programs(build_dir)

	table.sort(programs)

	if #programs == 0 then
		vim.notify(
			"No OCaml bytecode executables found in "
				.. build_dir
				.. ". Build a target with (modes byte exe) first.",
			vim.log.levels.ERROR
		)
		return nil
	end

	if #programs == 1 then
		return programs[1]
	end

	local co = coroutine.running()
	vim.ui.select(programs, {
		prompt = "Select OCaml bytecode executable",
		format_item = function(item)
			return vim.fn.fnamemodify(item, ":." )
		end,
	}, function(choice)
		coroutine.resume(co, choice)
	end)

	return coroutine.yield()
end

M.lsps = {
	{
		lsp_name = "ocamllsp",
		config = {
			root_markers = ocaml_root_markers,
			root_dir = function(bufnr, on_dir)
				local file_path = vim.api.nvim_buf_get_name(bufnr)
				local root = find_ocaml_root(file_path)
				if root then
					on_dir(root)
				end
			end,
			cmd = function(dispatchers, config)
				local root = config and config.root_dir
				local cmd = { "opam" }
				vim.list_extend(cmd, opam_exec_args(root, { "ocamllsp" }))
				return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root })
			end,
		},

	},
}

M.filetypes = { "ocaml" }
M.treesitter_parsers = { "ocaml", "ocaml_interface" }

M.formatters = {
	{
		name = "ocamlformat",
		options = {
			command = "opam",
			args = function(_, ctx)
				local root = ctx and ctx.filename and find_ocaml_root(ctx.filename)
				return opam_exec_args(root, {
					"ocamlformat",
					"--enable-outside-detected-project",
					"--name",
					"$FILENAME",
					"-",
				})
			end,
			stdin = true,
		},
	},
}

M.setup = function()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "ocaml",
		callback = function(args)
			vim.cmd.compiler("ocaml")
		end,
	})

	local dap = require("dap")

	dap.adapters.ocamlearlybird = function(callback)
		local bufnr = vim.api.nvim_get_current_buf()
		local root = find_ocaml_root(vim.api.nvim_buf_get_name(bufnr))

		callback({
			type = "executable",
			command = "opam",
			args = opam_exec_args(root, { "ocamlearlybird", "debug" }),
			options = {
				cwd = root or vim.uv.cwd(),
				detached = false,
			},
		})
	end

	dap.configurations.ocaml = {
		{
			name = "Launch OCaml bytecode",
			type = "ocamlearlybird",
			request = "launch",
			program = function()
				return pick_bytecode_program(vim.api.nvim_get_current_buf())
			end,
			cwd = function()
				local file_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
				return find_ocaml_root(file_path) or vim.uv.cwd()
			end,
			stopOnEntry = false,
			console = "integratedTerminal",
			yieldSteps = 4096,
			onlyDebugGlob = "<${workspaceFolder}/**/*>",
		},
	}
end

return M
