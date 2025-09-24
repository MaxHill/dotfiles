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
    s("svelte", t "svelte is awesome"),
    s("ts", fmt([[
    <script type="ts">
        {}
    </script>
  ]],
        {
            i(1)
        }
    )),

    s("css", fmt([[
    <style>
        {}
    </style>
  ]],
        {
            i(1)
        }
    )),

    s({ trig = "each" },
        fmta([[
        {#each <> as <>}
            <>
        {/each}
        ]],
            {
                i(1),
                i(2),
                i(3),
            })
    ),
    s({ trig = "if" },
        fmta([[
        {#if <>}
            <>
        {/if}
        ]],
            {
                i(1),
                i(2),
            })
    ),
    s({ trig = "elif" },
        fmta([[
        {:else if <>}
            <>
        ]],
            {
                i(1),
                i(2),
            })
    ),
    s({ trig = "else" },
        fmta([[
        {:else}
            <>
        ]],
            {
                i(1),
            })
    ),
}
