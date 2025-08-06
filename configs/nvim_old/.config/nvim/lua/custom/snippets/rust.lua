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

ls.add_snippets("rust", {
  snippet(
    "test",
    fmt(
      [[
		{}
		fn {}() {{
			{}
		}}
]],
      {
        c(1, {
          t "#[test]",
          t "#[tokio::test]",
          t "#[test_log::test]",
          t "#[test_log::test(tokio::test)]",
        }),
        i(2, "test_thing"),
        i(3),
      }
    )
  ),
  snippet(
    "modtest",
    fmt(
      [[
		#[cfg(test)]
		mod test {{
			{}

			{}
		}}
	]],
      {
        c(1, { t("use super::*;", {}), t "" }),
        i(2),
      }
    )
  ),
  snippet(
    "query",
    fmt(
      [[
		sqlx::query_as!(
			{},
			r"
			{}
			",
		)
		.fetch_all(pool)
		.await
		{}
	]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
})
