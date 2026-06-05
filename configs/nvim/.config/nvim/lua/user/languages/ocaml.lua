require("user.types")

---@type Language
local M = {}

local ocaml_root_markers = { "dune-project", "dune-workspace", "_opam" }

local function find_ocaml_root(path)
	if not path or path == "" then
		return nil
	end

	local root = vim.fs.root(path, ocaml_root_markers)
	if root then
		return root
	end

	local opam_file = vim.fs.find(function(name)
		return name:match("%.opam$") ~= nil
	end, { path = vim.fs.dirname(path), upward = true })[1]

	return opam_file and vim.fs.dirname(opam_file) or nil
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
				local cmd = { "opam", "exec", "--", "ocamllsp" }
				local root = config and config.root_dir

				if root and #root > 0 then
					cmd = { "opam", "exec", "--switch=" .. root, "--", "ocamllsp" }
				end

				return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root })
			end,
		},

	},
}

M.filetypes = { "ocaml" }

M.formatters = {
	{
		name = "ocamlformat",
		options = {
			command = "opam",
			args = function(_, ctx)
				local switch = ctx and ctx.filename and find_ocaml_root(ctx.filename)
				local args = { "exec" }

				if switch and #switch > 0 then
					table.insert(args, "--switch=" .. switch)
				end

				vim.list_extend(args, {
					"--",
					"ocamlformat",
					"--enable-outside-detected-project",
					"--name",
					"$FILENAME",
					"-",
				})

				return args
			end,
			stdin = true,
		},
	},
}

return M
