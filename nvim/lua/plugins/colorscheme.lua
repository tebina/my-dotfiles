-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                            Colorscheme                                    ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",
        floats = "dark",
      },
      sidebars = { "qf", "help", "terminal", "packer" },
      day_brightness = 0.3,
      hide_inactive_statusline = false,
      dim_inactive = false,
      lualine_bold = true,
      
      -- Custom highlights for Verilog/SystemVerilog
      on_highlights = function(hl, c)
        -- Module/endmodule keywords
        hl["@keyword.verilog"] = { fg = c.purple, bold = true }
        hl["@keyword.systemverilog"] = { fg = c.purple, bold = true }
        
        -- Always blocks
        hl["@keyword.function.verilog"] = { fg = c.blue, bold = true }
        
        -- Wire/reg/logic types
        hl["@type.verilog"] = { fg = c.cyan }
        hl["@type.systemverilog"] = { fg = c.cyan }
        
        -- Parameters
        hl["@constant.verilog"] = { fg = c.orange }
        
        -- Operators
        hl["@operator.verilog"] = { fg = c.blue5 }
        
        -- Port directions
        hl["@keyword.modifier.verilog"] = { fg = c.green }
      end,
    },
  },
  
  -- Alternative colorschemes optimized for HDL work
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    opts = {
      flavour = "mocha",
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        which_key = true,
        telescope = { enabled = true },
        indent_blankline = { enabled = true },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
      },
    },
  },
  
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
        },
      },
    },
  },
}
