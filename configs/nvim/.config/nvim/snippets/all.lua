---@diagnostic disable: undefined-global
-- Auto-injected globals from luasnip.config.snip_env:
-- s = ls.s (snippet constructor)
-- t = ls.text_node (static text)
-- i = ls.insert_node (cursor jump locations)
-- f = ls.function_node (dynamic text from functions)
-- c = ls.choice_node (multiple options to choose from)
-- d = ls.dynamic_node (nodes that change based on other nodes)
-- r = ls.restore_node (restore previous input)
-- fmt = require("luasnip.extras.fmt").fmt (format strings with placeholders)
-- rep = require("luasnip.extras").rep (repeat other nodes)
-- p = require("luasnip.extras").partial (partial function application)
-- m = require("luasnip.extras").match (conditional nodes)
-- n = require("luasnip.extras").nonempty (non-empty conditional)
-- dl = require("luasnip.extras").dynamic_lambda (dynamic lambdas)

-- Function to get the opening part of the comment (// or /*)
local function get_comment_open()
  local filetype = vim.bo.filetype
  -- For CSS or SCSS, return the block comment opening (/*)
  if filetype == "css" or filetype == "scss" then
    return "/* "
  end
  -- Check for line comments (e.g., // or #)
  local commentstring = vim.bo.commentstring
  if not commentstring:match "/%*" then
    return commentstring:gsub("%%s", ""):gsub("%s*$", "") .. " "
  end
  -- Default to empty string if not detected
  return ""
end

-- Function to get the closing part of the comment (*/ or nothing for line comments)
local function get_comment_close()
  local filetype = vim.bo.filetype
  -- For CSS or SCSS, return the block comment closing (*/)
  if filetype == "css" or filetype == "scss" then
    return "*/"
  end
  -- Default to empty string for line comments
  return ""
end

-- Adding snippets
return {
  s("simple", t "wow, you were right!"),
  s(
    "title",
    fmt(
      [[
    {} ------------------------------------------------------------------------
    {} {}                                                                     
    {} ------------------------------------------------------------------------ {}
  ]],
      {
        f(get_comment_open), -- Dynamically insert the comment at the start
        f(get_comment_open), -- Dynamically insert the comment at the start
        i(1), -- Placeholder for user input in the middle
        f(get_comment_open), -- Dynamically insert the comment at the start
        f(get_comment_close), -- Dynamically insert the comment at the start
      }
    )
  ),
}
