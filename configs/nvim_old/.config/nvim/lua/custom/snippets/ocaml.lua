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

ls.add_snippets("ocaml", {
  snippet(
    "test",
    fmt(
      [[
let%{} "It {}" =
  {}
  ]],
      {
        c(1, {
          t "test_unit",
          t "test",
          t "expect_test",
        }),
        i(2, "can do stuff"),
        i(3),
      }
    )
  ),
  snippet(
    "eq",
    fmt(" [%test_eq: {}] {} {} ", {
      i(1),
      i(2),
      i(3),
    })
  ),
  snippet("expect", fmt("[%expect {{| {} |}}];", { i(1) })),
  snippet(
    "mod",
    fmt(
      [[
module {} = struct
  let {} = {} 
end
]],
      {
        i(1),
        i(2),
        i(3),
      }
    )
  ),
  snippet(
    "modi",
    fmt(
      [[
module {} : sig
  val {} : {}
end = struct
  let {} = {}
end
]],
      {
        i(1),
        i(2),
        i(3),
        same(2),
        i(4),
      }
    )
  ),
})

-- (* TESTS *)
-- let%test_unit "It can do stuff" =
--   let open Base in
--   let time = Unix.localtime 1718020376. |> format_time_iso_8601 in
--   (* [%test_eq: float] 0.1234 time *)
--   [%test_eq: string] "2024-06-10T13:52:56+0000" time
-- ;;
