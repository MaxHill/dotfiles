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
    s("css", t "css is awesome"),

    s("mq", fmt([[
    @media ({}width: {}) {{
      {}
    }}]], {
        c(1, { t("min-"), t("max-") }),
        i(2, "768px"),
        i(0)
    })),

    s("keyframes", fmt([[
    @keyframes {} {{
      0% {{
        {}
      }}
      100% {{
        {}
      }}
    }}]], {
        i(1, "animation-name"),
        i(2, "transform: translateX(0);"),
        i(3, "transform: translateX(100px);")
    })),

    s("hover", fmt([[
    &:hover {{
      {}
    }}]], {
        i(1)
    })),

    s("active", fmt([[
    &:active {{
      {}
    }}]], {
        i(1)
    })),

    s("focus", fmt([[
    &:focus {{
      {}
    }}]], {
        i(1)
    })),

    s("reset", fmt([[
    margin: 0;
    padding: 0;
    box-sizing: border-box;]], {})),

    s("hsl", fmt([[
    hsl(var(--{}))]], {
        i(1, "c-text")
    })),

    s("hsla", fmt([[
    hsla(var(--{}), {})]], {
        i(1, "c-text"),
        i(2, "0.8")
    }))
}
