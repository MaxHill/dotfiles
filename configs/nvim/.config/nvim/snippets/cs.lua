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

-- Adding snippets
return {
    s("net", t "dotnet is awesome"),
    s("class", fmt([[
        public class {}
        {{
            {}
        }}
    ]], {
        f(function(_, snip)
            -- Extract filename without extension
            local name = vim.fn.expand("%:t:r")
            -- Capitalize first letter (optional)
            return name:sub(1, 1):upper() .. name:sub(2)
        end),
        i(0) -- body of the class
    })),

    s("struct", fmt([[
public struct {}
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

    s("lam", fmt([[
        {} {} = {} => {};
    ]], {
        i(1, "Func<int, int>"), -- delegate type (Func/Action)
        i(2, "myLambda"),       -- variable name
        i(3, "x"),              -- lambda parameter(s)
        i(0, "x + 1")           -- lambda body (expression)
    })),

    s("meth", fmt([[
        public {} {}({})
        {{
            {}
        }}
    ]], {
        i(1, "void"), -- return type
        i(2, "MethodName"),
        i(3),         -- parameters
        i(0)          -- body
    })),

    s("prop", fmt([[
private {} _{};
public {} {}
{{
    get => _{};
    set => _{} = value;
}}
]], {
        i(1, "int"),      -- Type
        i(2, "PropertyName"), -- Property name
        rep(1),           -- Repeat type
        rep(2),           -- Repeat property name (no underscore here)
        rep(2),           -- Repeat property name (no underscore here)
        rep(2),           -- Repeat property name (no underscore here)
    })),

    s("aprop", fmt("public {} {} {{ get; set; }}", {
        i(1, "int"),
        i(2, "PropertyName"),
    })),

    s("iface", fmt([[
public interface {}
{{
    {}
}}
]], {
        i(1, "IInterfaceName"),
        i(0),
    })),
    s("for", fmt([[
for (int {} = 0; {} < {}; {}++)
{{
    {}
}}
]], {
        i(1, "i"),
        rep(1),
        i(2, "count"),
        rep(1),
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
    })),
}
