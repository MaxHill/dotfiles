local o = vim.opt
local g = vim.g

o.hlsearch = true
o.incsearch = true
o.linespace = 17
o.showmode = true -- Always show what mode we're currently editing in
o.wrap = false -- Don't wrap lines

o.tabstop = 2 -- A tab is two spaces
o.softtabstop = 2 -- When hitting <BS>, pretend like a tab is removed, even if spaces
o.smarttab = true
o.expandtab = true -- Expand tabs by default (overloadable per file type later)
o.shiftwidth = 2 -- Number of spaces to use for autoindenting
o.shiftround = true -- Use multiple of shiftwidth when indenting with '<' and '>'
o.backspace = { "indent", "eol", "start" } -- Allow backspacing over everything in insert mode
o.autoindent = true -- Always set autoindenting on
o.copyindent = true -- Copy the previous indentation on autoindenting
o.number = true -- Always show line numbers
o.ignorecase = true -- Ignore case when searching
o.smartcase = true -- Ignore case if search pattern is all lowercase,
o.timeoutlen = 300 -- Time to wait before a mapped sequence to complete (milliseconds)
o.visualbell = true -- Don't beep
o.autowrite = true -- Save on buffer switch
o.mouse = "a" -- Allow the mouse to be used
o.laststatus = 2 -- When to display statusbar (0: Never, 1: Only if you have more than 2 windows, the status bar shows, 2: Always)
o.cursorline = true -- Highlight the line the cursor is on
o.colorcolumn = "81" -- Highlight to column to see 80 char mark
o.complete:prepend({ "kspell" }) -- Autocomplete with dictionary words when spell check is on
o.swapfile = false -- Create swapfile
o.termguicolors = true -- Better color support in most terminals
o.winhighlight = "NormalNC:MyNormalWin" -- Make popups background the same as background
g.nvim_tree_quit_on_open = 1 -- Close file sidebar when file is opened
o.number = true -- Show line number on current line
o.relativenumber = true -- Use hybrid line numbers
