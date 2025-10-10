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
    s("astro", t "astro is awesome"),
    s("frontmatter", fmt([[
---
{}
---
]], {
        i(1, "title: My Astro Page"),
    })),
    s("script", fmt([[
<script{}>{}
</script>
]], {
        c(1, {
            t(""),
            sn(nil, fmt(" define:vars={{{}}}", i(1, "prop"))),
        }),
        i(2),
    })),
    s("style", fmt([[
<style>
{}
</style>
]], {
        i(1),
    })),
    s("client", fmt([[
<div client:{}>{}</div>
]], {
        c(1, {
            t("load"),
            t("idle"),
            t("visible"),
            t("media"),
            t("only"),
        }),
        i(2),
    })),
    s("component", fmt([[
---
import {} from '{}';
---

<{} />
]], {
        i(1, "Component"),
        i(2, "./Component.astro"),
        rep(1),
    })),
}