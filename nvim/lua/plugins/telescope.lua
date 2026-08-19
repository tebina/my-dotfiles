-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                           Telescope                                       ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    keys = {
      -- File pickers
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      
      -- Search
      { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Search word under cursor" },
      { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in buffer" },
      { "<leader>sc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>sr", "<cmd>Telescope registers<cr>", desc = "Registers" },
      
      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      
      -- LSP
      { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>lS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>ld", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>lD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      
      -- Verilog specific
      { "<leader>vm", "<cmd>Telescope find_files find_command=rg,--files,--glob,*.sv,--glob,*.v,--glob,*.svh,--glob,*.vh<cr>", desc = "Find Verilog files" },
      { "<leader>vg", function()
        require("telescope.builtin").live_grep({
          type_filter = "verilog",
        })
      end, desc = "Grep in Verilog files" },
      
      -- File browser
      { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "File browser" },
      { "<leader>fE", "<cmd>Telescope file_browser path=%:p:h select_buffer=true<cr>", desc = "File browser (current dir)" },
      
      -- Resume
      { "<leader><leader>", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
    },
    opts = function()
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      
      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          
          file_ignore_patterns = {
            "%.git/",
            "node_modules/",
            "%.cache",
            "%.o$",
            "%.a$",
            "%.so$",
            "%.vcd$",           -- Waveform dump files
            "%.fsdb$",          -- Verdi waveform
            "%.vpd$",           -- VCS waveform
            "%.saif$",          -- Power analysis
            "csrc/",            -- VCS compile dir
            "simv.*",           -- VCS executable
            "AN%.DB/",          -- Synopsys database
            "work/",            -- Questa/ModelSim work dir
            "xsim%.dir/",       -- Xilinx simulation dir
          },
          
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<M-p>"] = action_layout.toggle_preview,
            },
            n = {
              ["<esc>"] = actions.close,
              ["q"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<M-p>"] = action_layout.toggle_preview,
            },
          },
          
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob", "!.git/*",
          },
        },
        
        pickers = {
          find_files = {
            hidden = true,
            find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
          buffers = {
            show_all_buffers = true,
            sort_lastused = true,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
          lsp_document_symbols = {
            symbols = {
              "Class",
              "Function",
              "Method",
              "Module",
              "Interface",
              "Variable",
              "Constant",
            },
          },
        },
        
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          file_browser = {
            hijack_netrw = true,
            grouped = true,
            hidden = true,
            respect_gitignore = false,
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      
      -- Load extensions
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "file_browser")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
