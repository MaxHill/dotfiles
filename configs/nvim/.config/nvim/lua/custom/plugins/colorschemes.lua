return {
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   dependencies = {
  --     "nvim-tree/nvim-web-devicons",
  --     "rebelot/kanagawa.nvim",
  --   },
  --   config = function()
  --     require("lualine").setup {
  --       options = {
  --         theme = "catppuccin",
  --         component_separators = "|",
  --         section_separators = "",
  --       },
  --       sections = {
  --         lualine_a = { "mode" },
  --         -- lualine_b = { "branch", "diff", "diagnostics" },
  --         lualine_c = { { "filename", path = 0 } },
  --         lualine_x = { "fileformat", "filetype" },
  --         -- lualine_y = { "progress" },
  --         -- lualine_z = { "location" },
  --       },
  --     }
  --   end,
  -- },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   priority = 1000,
  --   config = function()
  --     vim.cmd "colorscheme rose-pine"
  --   end,
  -- },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup {
        flavour = "latte", -- latte, frappe, macchiato, mocha
        transparent_background = true, -- disables setting the background color.
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
          enabled = true,
          indentscope_color = "",
        },
      }
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  -- {
  --   "scottmckendry/cyberdream.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     require("cyberdream").setup {
  --       -- Enable transparent background
  --       transparent = true,
  --       -- Enable italics comments
  --       italic_comments = true,
  --       -- Replace all fillchars with ' ' for the ultimate clean look
  --       hide_fillchars = false,
  --       -- Modern borderless telescope theme
  --       borderless_telescope = true,
  --       -- Set terminal colors used in `:terminal`
  --       terminal_colors = true,
  --       theme = {
  --         variant = "default", -- use "light" for the light variant
  --         highlights = {
  --           -- Highlight groups to override, adding new groups is also possible
  --           -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values
  --
  --           -- Example:
  --           Comment = { fg = "#696969", bg = "NONE", italic = true },
  --
  --           -- Complete list can be found in `lua/cyberdream/theme.lua`
  --         },
  --
  --         -- Override a color entirely
  --         colors = {
  --           -- For a list of colors see `lua/cyberdream/colours.lua`
  --           -- Example:
  --           bg = "#000000",
  --           green = "#00ff00",
  --           magenta = "#ff00ff",
  --         },
  --       },
  --     }
  --
  --     vim.cmd "colorscheme cyberdream"
  --   end,
  -- },
}
