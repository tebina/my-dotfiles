-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                        Treesitter Configuration                           ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    opts = {
      -- Languages to install
      ensure_installed = {
        "verilog",           -- Verilog & SystemVerilog
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline",
        "bash",
        "python",
        "c",
        "cpp",
        "make",
        "tcl",               -- Often used in FPGA/ASIC flows
        "json",
        "yaml",
        "toml",
      },
      
      -- Install parsers synchronously
      sync_install = false,
      
      -- Auto-install missing parsers when entering buffer
      auto_install = true,
      
      -- Syntax highlighting
      highlight = {
        enable = true,
        -- Disable for large files
        disable = function(lang, buf)
          local max_filesize = 500 * 1024 -- 500 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },
      
      -- Indentation
      indent = {
        enable = true,
        disable = { "verilog" }, -- Verilog indentation can be tricky
      },
      
      -- Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      
      -- Text objects
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            -- Module/class text objects
            ["af"] = { query = "@function.outer", desc = "Select outer function/always block" },
            ["if"] = { query = "@function.inner", desc = "Select inner function/always block" },
            ["ac"] = { query = "@class.outer", desc = "Select outer class/module" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class/module" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer argument" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner argument" },
            ["ai"] = { query = "@conditional.outer", desc = "Select outer conditional" },
            ["ii"] = { query = "@conditional.inner", desc = "Select inner conditional" },
            ["al"] = { query = "@loop.outer", desc = "Select outer loop" },
            ["il"] = { query = "@loop.inner", desc = "Select inner loop" },
            ["a/"] = { query = "@comment.outer", desc = "Select outer comment" },
            ["i/"] = { query = "@comment.inner", desc = "Select inner comment" },
          },
        },
        
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function/always start" },
            ["]c"] = { query = "@class.outer", desc = "Next class/module start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next argument" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function/always end" },
            ["]C"] = { query = "@class.outer", desc = "Next class/module end" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Previous function/always start" },
            ["[c"] = { query = "@class.outer", desc = "Previous class/module start" },
            ["[a"] = { query = "@parameter.inner", desc = "Previous argument" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "Previous function/always end" },
            ["[C"] = { query = "@class.outer", desc = "Previous class/module end" },
          },
        },
        
        swap = {
          enable = true,
          swap_next = {
            ["<leader>a"] = "@parameter.inner",
          },
          swap_previous = {
            ["<leader>A"] = "@parameter.inner",
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      
      -- Register SystemVerilog as using the Verilog parser
      vim.treesitter.language.register("verilog", "systemverilog")
    end,
  },

  -- Show code context at top of screen
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = {
      enable = true,
      max_lines = 3,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    },
    keys = {
      {
        "[C",
        function()
          require("treesitter-context").go_to_context()
        end,
        desc = "Go to context",
      },
    },
  },

  -- Rainbow delimiters for nested brackets (helpful in complex expressions)
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")
      
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          verilog = rainbow_delimiters.strategy["global"],
          systemverilog = rainbow_delimiters.strategy["global"],
        },
        query = {
          [""] = "rainbow-delimiters",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },
}
