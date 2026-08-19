-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                          Editor Plugins                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end
        
        -- Navigation
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
        
        -- Actions
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff this ~")
        
        -- Text object
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },

  -- Git blame virtual text
  {
    "f-person/git-blame.nvim",
    event = "BufReadPost",
    opts = {
      enabled = false,  -- Disabled by default, toggle with :GitBlameToggle
      message_template = "  <author> • <date> • <summary>",
      date_format = "%Y-%m-%d",
      virtual_text_column = 80,
    },
    keys = {
      { "<leader>gtb", "<cmd>GitBlameToggle<cr>", desc = "Toggle git blame" },
    },
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      padding = true,
      sticky = true,
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
      pre_hook = nil,
      post_hook = nil,
    },
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        verilog = { "string" },
        systemverilog = { "string" },
      },
      disable_filetype = { "TelescopePrompt", "vim" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Better text objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
        TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        -- Verilog-specific
        SYNTHESIS = { icon = "󰕳 ", color = "warning", alt = { "SYNTH" } },
        SIMULATION = { icon = " ", color = "info", alt = { "SIM" } },
        LINT = { icon = " ", color = "hint" },
      },
      highlight = {
        multiline = true,
        before = "",
        keyword = "wide",
        after = "fg",
        pattern = [[.*<(KEYWORDS)\s*:]],
        comments_only = true,
      },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },

  -- Trouble (diagnostics list)
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
    },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location list" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix list" },
    },
  },

  -- Symbol outline
  {
    "hedyhli/outline.nvim",
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>lo", "<cmd>Outline<cr>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        position = "right",
        width = 30,
        relative_width = true,
      },
      symbols = {
        icons = {
          Module = { icon = "󰕳", hl = "Structure" },
          Class = { icon = "", hl = "Type" },
          Function = { icon = "󰊕", hl = "Function" },
          Variable = { icon = "", hl = "Constant" },
          Interface = { icon = "", hl = "Type" },
        },
      },
    },
  },

  -- Search/replace
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
      { "<leader>sw", function() require("spectre").open_visual({ select_word = true }) end, desc = "Search word (Spectre)" },
    },
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      preview = {
        auto_preview = true,
        border = "rounded",
      },
    },
  },

  -- Flash (motion)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Persistence (session management)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },

  -- Harpoon (quick file navigation)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ha", function() require("harpoon"):list():add() end, desc = "Harpoon add file" },
      { "<leader>hh", function() local harpoon = require("harpoon") harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Harpoon menu" },
      { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
      { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
      { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
      { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
      { "[H", function() require("harpoon"):list():prev() end, desc = "Harpoon prev" },
      { "]H", function() require("harpoon"):list():next() end, desc = "Harpoon next" },
    },
    opts = {},
  },

  -- Illuminate (highlight same words)
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "neo-tree",
        "lazy",
        "mason",
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      
      -- Keymaps
      vim.keymap.set("n", "]]", function()
        require("illuminate").goto_next_reference(false)
      end, { desc = "Next reference" })
      vim.keymap.set("n", "[[", function()
        require("illuminate").goto_prev_reference(false)
      end, { desc = "Prev reference" })
    end,
  },
}
