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

return {
  s(
    "hopen",
    t({
      "open Hegel",
      "open Hegel.Generators",
    })
  ),

  s(
    "htest",
    fmt(
      [[
let%hegel_test {} tc =
  {}
]],
      {
        i(1, "test_name"),
        i(0, "assert true"),
      }
    )
  ),

  s(
    "hdint",
    fmt(
      "let {} = draw tc (integers ~min_value:({}) ~max_value:{} ()) in",
      {
        i(1, "n"),
        i(2, "-1000"),
        i(0, "1000"),
      }
    )
  ),

  s(
    "hdbool",
    fmt(
      "let {} = draw tc (booleans ()) in",
      {
        i(1, "b"),
      }
    )
  ),

  s(
    "hdtext",
    fmt(
      "let {} = draw tc (text ()) in",
      {
        i(1, "s"),
      }
    )
  ),

  s(
    "hdfloat",
    fmt(
      "let {} = draw tc (floats ()) in",
      {
        i(1, "x"),
      }
    )
  ),

  s(
    "hdchar",
    fmt(
      "let {} = draw tc (characters ()) in",
      {
        i(1, "ch"),
      }
    )
  ),

  s(
    "hdbin",
    fmt(
      "let {} = draw tc (binary ()) in",
      {
        i(1, "bytes"),
      }
    )
  ),

  s(
    "hn",
    fmt(
      "note tc (Printf.sprintf \"%s = {}\" {} {})",
      {
        i(1, "%d"),
        i(2, "\"x\""),
        i(0, "x"),
      }
    )
  ),

  s(
    "hass",
    fmt(
      "assert ({})",
      {
        i(0, "condition"),
      }
    )
  ),
}
