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
    s("ts", t "typescript is awesome"),
    s("class", fmt([[
    export class {}
    {{
      {}
    }}
  ]], {
        d(1, function()
            local name = vim.fn.expand("%:t:r")
            name = name:sub(1, 1):upper() .. name:sub(2)
            return sn(nil, i(1, name))
        end),
        i(0),
    })),
    -- Method snippet inside a class
    s("meth", fmt([[
    {}({}): {} {{
      {}
    }}
  ]], {
        i(1, "methodName"), -- method name
        i(2, ""),           -- parameters
        i(3, ""),           -- return type
        i(0),               -- body
    })),

    -- Standalone function snippet
    s("fn", fmt([[
    function {}({}): {} {{
      {}
    }}
  ]], {
        i(1, "functionName"), -- function name
        i(2, ""),             -- parameters
        i(3, "void"),         -- return type
        i(0),                 -- body
    })),

    s("prop", fmt([[{}: {}{};]], {
        i(1, "propertyName"),
        i(2, "string"),
        c(3, {
            t(""),
            sn(nil, fmt(" = {};", i(1, "''"))),
        }),
    })),

    s("type", fmt([[
type {} = {}{};
]], {
        i(1, "TypeName"),
        i(2, "{}"), -- type definition (e.g., `string | number`, `{ name: string }`, etc.)
        i(0),
    })),

    s("iface", fmt([[
interface {} {{
  {}
}}
]], {
        i(1, "InterfaceName"),
        i(0),
    })),
    s("for", fmt([[
for (const {} of {}) {{
  {}
}}
]], {
        i(1, "item"),
        i(2, "collection"),
        i(0),
    })),
    s("forin", fmt([[
for (const {} in {}) {{
  {}
}}
]], {
        i(1, "item"),
        i(2, "collection"),
        i(0),
    })),
    s("if", fmt([[
if ({}) {{
  {}
}}
]], {
        i(1, "condition"),
        i(0),
    })),
    s("elseif", fmt([[
else if ({}) {{
  {}
}}
]], {
        i(1, "condition"),
        i(0),
    })),
    s("else", fmt([[
else {{
  {}
}}
]], {
        i(0),
    }))
}
