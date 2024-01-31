local ls = require "luasnip"
local types = require "luasnip.util.types"

ls.config.set_config {
	-- This tells LuaSnip to remember to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection
	history = true,

	-- This one is cool cause if you have dynamic snippets, it updates as you type!
	updateevents = "TextChanged,TextChangedI",

	-- Autosnippets:
	enable_autosnippets = true,

	-- Crazy highlights!!
	-- ext_opts = nil,
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { " « ", "NonTest" } },
			},
		},
	},
}


-- create snippet
-- s(context, nodes, condition, ...)
local snippet = ls.s
local fmt = require('luasnip.extras.fmt').fmt -- String and list of nodes
local t = ls.text_node                        -- Create text node
local i = ls.insert_node                      -- Location for the cursor to jump to
local f = ls.function_node                    -- Takes a function and returns text
local c = ls.choice_node                      -- Step through different choices
local d = ls.dynamic_node                     -- Not sure...
local same = function(index)                  -- Reuse an argument
	return f(function(args)
		return args[1]
	end, { index })
end


ls.add_snippets("all", {
	-- snippet("simple", t "wow, you were right!"),
})

ls.add_snippets("lua", {
	snippet("r", fmt("local {} = require \"{}\"{}", { same(1), i(1), i(3) }))
})

ls.add_snippets("typescript", {
	snippet("log", fmt("console.log({});", { i(1) }))
})

ls.add_snippets("markdown", {
	snippet("/link", fmt("[{}]({}{})", { same(2), c(1, { t("./"), t("") }), i(2) })),
	snippet(
		"/div",
		fmt("{} ---------------------------------------------------",
			{ f(function() return os.date("%x") end) }))
})



ls.add_snippets("rust", {
	snippet("test", fmt([[
	    #[test]
		fn {}() {{
			{}
		}}
]], {
		i(1, "test_thing"),
		i(2)
	})),

	snippet("testa", fmt([[
	    #[tokio::test]
		fn {}() {{
			{}
		}}
]], {
		i(1, "test_thing"),
		i(2)
	})),

	snippet("testl",
		i(1, "//use test_log::test; "),
		fmt([[
        #[test_log::test]
		fn {}() {{
			{}
		}}
]], {
			i(1, "test_thing"),
			i(2)
		})),

	snippet("testall",
		i(1, "//use test_log::test; "),
		fmt([[
        #[test(tokio::test)]
		fn {}() {{
			{}
		}}
]], {
			i(1, "test_thing"),
			i(2)
		})),

	snippet("modtest", fmt([[
		#[cfg(test)]
		mod test {{
			{}

			{}
		}}
	]], {
		c(1, { t("use super::*;", {}), t("") }),
		i(2),
	}))
})
