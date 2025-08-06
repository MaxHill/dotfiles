local ls = require "luasnip"

local snippet = ls.s
local fmt = require("luasnip.extras.fmt").fmt -- String and list of nodes
local t = ls.text_node -- Create text node
local i = ls.insert_node -- Location for the cursor to jump to
local f = ls.function_node -- Takes a function and returns text
local c = ls.choice_node -- Step through different choices
local d = ls.dynamic_node -- Not sure...
local same = function(index) -- Reuse an argument
  return f(function(args)
    return args[1]
  end, { index })
end

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
ls.add_snippets("all", {
  snippet("simple", t "wow, you were right!"),
  snippet(
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
})
