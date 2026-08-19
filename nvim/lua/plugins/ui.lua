-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              UI Plugins                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function()
      return {
        options = {
          theme = "tokyonight",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = {
            {
              "filename",
              path = 1,
              symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
              },
            },
            -- Show current module name for Verilog files
            {
              function()
                return vim.b.verilog_module_name or ""
              end,
              cond = function()
                local ft = vim.bo.filetype
                return (ft == "verilog" or ft == "systemverilog") and vim.b.verilog_module_name
              end,
              icon = "󰕳",
              color = { fg = "#7aa2f7" },
            },
          },
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = " ",
                warn = " ",
                info = " ",
                hint = " ",
              },
            },
            {
              function()
                local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                if #clients == 0 then
                  return ""
                end
                local names = {}
                for _, client in ipairs(clients) do
                  table.insert(names, client.name)
                end
                return " " .. table.concat(names, ", ")
              end,
              color = { fg = "#7dcfff" },
            },
            "encoding",
            "fileformat",
            "filetype",
          },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "neo-tree", "lazy", "quickfix" },
      }
    end,
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal file in explorer" },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      
      default_component_configs = {
        indent = {
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          indent_size = 2,
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
        },
        modified = {
          symbol = "●",
        },
        git_status = {
          symbols = {
            added = "",
            modified = "",
            deleted = "",
            renamed = "➜",
            untracked = "★",
            ignored = "◌",
            unstaged = "✗",
            staged = "✓",
            conflict = "",
          },
        },
      },
      
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            ".git",
            ".DS_Store",
            "thumbs.db",
          },
          hide_by_pattern = {
            "*.vcd",          -- Waveform files
            "*.fsdb",
            "*.vpd",
          },
          never_show = {},
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      
      window = {
        width = 35,
        mappings = {
          ["<space>"] = "none",
          ["<cr>"] = "open",
          ["o"] = "open",
          ["s"] = "open_split",
          ["v"] = "open_vsplit",
          ["t"] = "open_tabnew",
          ["h"] = "close_node",
          ["l"] = "open",
          ["a"] = {
            "add",
            config = {
              show_path = "relative",
            },
          },
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
        },
      },
    },
  },

  -- Buffer line (tabs)
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "none",
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        indicator = {
          style = "icon",
          icon = "▎",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 30,
        max_prefix_length = 30,
        tab_size = 21,
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = "thin",
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        sort_by = "insert_after_current",
      },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = true,
        show_start = false,
        show_end = false,
      },
      exclude = {
        filetypes = {
          "help",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
        },
      },
    },
  },

  -- Which-key (keybinding helper)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true },
        presets = {
          operators = true,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      win = {
        border = "rounded",
      },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug/diagnostics" },
        { "<leader>f", group = "find/files" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp" },
        { "<leader>o", group = "open" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>v", group = "verilog" },
        { "<leader>w", group = "workspace" },
        { "<leader>x", group = "quickfix/loclist" },
        { "<leader><tab>", group = "tabs" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      stages = "fade_in_slide_out",
      render = "compact",
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- Better vim.ui
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        border = "rounded",
        relative = "cursor",
      },
      select = {
        backend = { "telescope", "builtin" },
      },
    },
  },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Header
      dashboard.section.header.val = {
        [[                                                    ]],
        [[  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
        [[  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
        [[  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
        [[  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
        [[  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
        [[  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        [[                                                    ]],
        [[        SystemVerilog / Verilog Development         ]],
        [[                                                    ]],
      }

      -- Menu
      dashboard.section.buttons.val = {
        dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "󰊄  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("v", "󰕳  Find Verilog", ":Telescope find_files find_command=rg,--files,--glob,*.sv,--glob,*.v<CR>"),
        dashboard.button("c", "  Configuration", ":e $MYVIMRC <CR>"),
        dashboard.button("l", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- Footer
      dashboard.section.footer.val = function()
        local stats = require("lazy").stats()
        return "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins"
      end

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      alpha.setup(dashboard.opts)

      -- Disable folding on alpha buffer
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "alpha",
        callback = function()
          vim.opt_local.foldenable = false
        end,
      })
    end,
  },
}
