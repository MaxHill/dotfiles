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
    -- Function snippet
    s("fn", fmt([[
func {}({}) {} {{
    {}
}}
]], {
        i(1, "functionName"),
        i(2, ""), -- parameters, e.g. "arg int"
        i(3, ""), -- return type, e.g. "int" or "(int, error)"
        i(0),
    })),

    -- Method snippet
    s("meth", fmt([[
func ({}) {}({}) {} {{
    {}
}}
]], {
        i(1, "r Receiver"), -- receiver
        i(2, "MethodName"),
        i(3, ""),       -- parameters
        i(4, ""),       -- return type
        i(0),
    })),

    s("type", fmt([[
type {} {}{}
]], {
        i(1, "TypeName"),
        i(2, "struct"), -- e.g., `struct`, `int`, `interface`, etc.
        i(0),
    })),

    -- Interface snippet
    s("iface", fmt([[
type {} interface {{
    {}
}}
]], {
        i(1, "InterfaceName"),
        i(0),
    })),

    -- For loop snippet (range loop)
    s("for", fmt([[
for {}, {} := range {} {{
    {}
}}
]], {
        i(1, "i"),
        i(2, "v"),
        i(3, "collection"),
        i(0),
    })),

    -- If snippet
    s("if", fmt([[
if {} {{
    {}
}}
]], {
        i(1, "condition"),
        i(0),
    })),

    -- Else if snippet
    s("elseif", fmt([[
else if {} {{
    {}
}}
]], {
        i(1, "condition"),
        i(0),
    })),

    -- Else snippet
    s("else", fmt([[
else {{
    {}
}}
]], {
        i(0),
    })),
}
