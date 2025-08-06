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

ls.add_snippets("gleam", {
  snippet(
    "test",
    fmt(
      [[
fn {}_test(){{
  {}
}}
  ]],
      {
        i(1),
        i(2),
      }
    )
  ),
  snippet(
    "external",
    fmt(
      [[
  @external(javascript, "{}", "{}")
  pub fn {}() -> {}
  ]],
      {
        i(1),
        i(2),
        i(3),
        i(4),
      }
    )
  ),
  snippet(
    "title",
    fmt(
      [[
// {} ---------------------------------------------------------------------
  ]],
      {
        i(1),
      }
    )
  ),
  snippet(
    "doc",
    fmt(
      [[
/// {}
/// 
/// ## Example
/// ```gleam
/// {}
/// ```
  ]],
      {
        i(1),
        i(2),
      }
    )
  ),
})
