M = {}

M.mod_file = nil
M.asset_files = {}

---Toggle split for file matching pattern in same directory
---Example:
--- ```lua
--- vim.keymap.set("n", "<leader><space>c", function()
--- require("user.open_assets").toggle(".*css$")
--- end, {desc = "Open css files in current dir in a split"})
--- ```
---@param pattern string
M.toggle = function(pattern)
  if M.mod_file == nil then
    M.open_assets(pattern)
  else
    M.close_assets()
  end
end

---Open first matching file in split
---@param pattern string "%.*css$"
M.open_assets = function(pattern)
  local mod_file = vim.api.nvim_get_current_buf()
  local cwDir = vim.fn.expand "%:p:h"
  local matching_files = Get_matching_files(cwDir, pattern)

  if next(matching_files) ~= nil then
    M.mod_file = mod_file
  else
    print "No files found..."
  end

  for _, value in pairs(matching_files) do --actualcode
    vim.cmd("vsplit " .. value)
    table.insert(M.asset_files, vim.api.nvim_get_current_buf())
  end
end

---Closes open asset file used for close toggle
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
