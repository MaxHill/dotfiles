M = {}
M.toggle_test_file = function()
  local current_file = vim.fn.expand "%"

  -- Check if valid file
  if current_file == "" then
    print "No file open!"
    return
  end

  -- Get filename and extension
  local filename = vim.fn.fnamemodify(current_file, ":t")
  local extension = vim.fn.fnamemodify(current_file, ":e")
  local basename = vim.fn.fnamemodify(filename, ":r") -- Filename without extension

  -- Check if filename has "_test" suffix
  local is_test_file = string.match(basename, "_test$")

  -- Decide target filename with same extension
  local target_basename
  if is_test_file then
    target_basename = string.gsub(basename, "_test$", "")
  else
    target_basename = basename .. "_test"
  end
  local target_filename = target_basename .. "." .. extension

  -- Set project root (try to find .git root or fallback to current directory)
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  local project_root = git_root and vim.fn.trim(git_root) or vim.fn.getcwd()

  -- Run ripgrep to find file, respecting .gitignore, limited to project root
  local files = vim.fn.systemlist(string.format("rg --files --ignore -g '%s' %s", target_filename, project_root))

  -- Check if we got any results
  if #files == 1 then
    -- Only one result, open it directly
    vim.cmd("edit " .. files[1])
  elseif #files > 1 then
    -- Multiple results, fall back to Telescope
    require("telescope.builtin").find_files {
      prompt_title = "Toggle Test File",
      cwd = project_root,
      default_text = target_filename,
      search_dirs = { project_root },
      attach_mappings = function(_, map)
        map("i", "<CR>", function(bufnr)
          local entry = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(bufnr)
          vim.cmd("edit " .. entry.path)
        end)
        return true
      end,
    }
  else
    -- No results found
    print("Can't find file: " .. target_filename)
  end
end

return M
