-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                       Linting & Formatting                                ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- Conform.nvim for formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- Verilog/SystemVerilog formatting with Verible
        verilog = { "verible" },
        systemverilog = { "verible" },
        
        -- Other languages
        lua = { "stylua" },
        python = { "black" },
        sh = { "shfmt" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      
      -- Define formatters
      formatters = {
        verible = {
          command = "verible-verilog-format",
          args = {
            "--indentation_spaces=2",
            "--port_declarations_alignment=align",
            "--port_declarations_indentation=indent",
            "--named_parameter_alignment=align",
            "--named_port_alignment=align",
            "--module_net_variable_alignment=align",
            "--case_items_alignment=align",
            "--formal_parameters_alignment=align",
            "--class_member_variable_alignment=align",
            "--assignment_statement_alignment=align",
            "--try_wrap_long_lines=true",
            "-",
          },
          stdin = true,
        },
      },
      
      -- Format on save (optional, disabled by default)
      format_on_save = function(bufnr)
        -- Disable for large files
        local lines = vim.api.nvim_buf_line_count(bufnr)
        if lines > 5000 then
          return
        end
        
        -- Only format on save if explicitly enabled
        if vim.g.format_on_save then
          return {
            timeout_ms = 3000,
            lsp_fallback = true,
          }
        end
      end,
    },
    init = function()
      -- Toggle format on save
      vim.keymap.set("n", "<leader>uf", function()
        vim.g.format_on_save = not vim.g.format_on_save
        vim.notify(
          "Format on save: " .. (vim.g.format_on_save and "enabled" or "disabled"),
          vim.log.levels.INFO
        )
      end, { desc = "Toggle format on save" })
    end,
  },

  -- nvim-lint for linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Configure linters by filetype
      lint.linters_by_ft = {
        verilog = { "verilator" },
        systemverilog = { "verilator" },
      }

      -- Custom Verilator linter configuration
      lint.linters.verilator = {
        name = "verilator",
        cmd = "verilator",
        stdin = false,
        append_fname = true,
        args = {
          "--lint-only",
          "-Wall",
          "--quiet-exit",
          "-Wno-DECLFILENAME",     -- Common in IP cores
          "-Wno-UNUSEDSIGNAL",     -- Can be noisy
        },
        stream = "stderr",
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          local filename = vim.fn.expand("%:t")
          
          for line in output:gmatch("[^\r\n]+") do
            -- Match Verilator output format: %Error: file:line:col: message
            -- or %Warning-TYPE: file:line:col: message
            local severity, file, lnum, col, message = line:match(
              "%%(%w+)%-?[%w]*: ([^:]+):(%d+):(%d+): (.+)"
            )
            
            if not severity then
              -- Try format without column
              severity, file, lnum, message = line:match(
                "%%(%w+)%-?[%w]*: ([^:]+):(%d+): (.+)"
              )
              col = "1"
            end
            
            if severity and file and file:match(filename) then
              local sev = vim.diagnostic.severity.ERROR
              if severity:lower() == "warning" then
                sev = vim.diagnostic.severity.WARN
              elseif severity:lower() == "info" then
                sev = vim.diagnostic.severity.INFO
              end
              
              table.insert(diagnostics, {
                lnum = tonumber(lnum) - 1,
                col = tonumber(col) - 1,
                end_lnum = tonumber(lnum) - 1,
                end_col = tonumber(col),
                message = message,
                severity = sev,
                source = "verilator",
              })
            end
          end
          
          return diagnostics
        end,
      }

      -- Alternative: Icarus Verilog linter
      lint.linters.iverilog = {
        name = "iverilog",
        cmd = "iverilog",
        stdin = false,
        append_fname = true,
        args = {
          "-t", "null",
          "-Wall",
          "-g2012",  -- SystemVerilog 2012
        },
        stream = "stderr",
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          local filename = vim.fn.expand("%:t")
          
          for line in output:gmatch("[^\r\n]+") do
            local file, lnum, message = line:match("([^:]+):(%d+): (.+)")
            
            if file and file:match(filename) then
              local severity = vim.diagnostic.severity.ERROR
              if message:match("^warning:") then
                severity = vim.diagnostic.severity.WARN
                message = message:gsub("^warning: ", "")
              end
              
              table.insert(diagnostics, {
                lnum = tonumber(lnum) - 1,
                col = 0,
                message = message,
                severity = severity,
                source = "iverilog",
              })
            end
          end
          
          return diagnostics
        end,
      }

      -- Verible linter
      lint.linters.verible_lint = {
        name = "verible_lint",
        cmd = "verible-verilog-lint",
        stdin = false,
        append_fname = true,
        args = {
          "--rules=-line-length",  -- Disable line length check (customize as needed)
        },
        stream = "stdout",
        ignore_exitcode = true,
        parser = require("lint.parser").from_pattern(
          "([^:]+):(%d+):(%d+): (.+)",
          { "file", "lnum", "col", "message" },
          nil,
          {
            ["severity"] = vim.diagnostic.severity.WARN,
            ["source"] = "verible",
          }
        ),
      }

      -- Create autocommand to run linter
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          -- Only lint if not a large file
          if not vim.b.large_file then
            lint.try_lint()
          end
        end,
      })

      -- Manual lint command
      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Lint current file" })

      -- Select linter
      vim.keymap.set("n", "<leader>cL", function()
        local linters = { "verilator", "iverilog", "verible_lint" }
        vim.ui.select(linters, {
          prompt = "Select linter:",
        }, function(choice)
          if choice then
            lint.linters_by_ft.verilog = { choice }
            lint.linters_by_ft.systemverilog = { choice }
            lint.try_lint()
            vim.notify("Switched to " .. choice, vim.log.levels.INFO)
          end
        end)
      end, { desc = "Select linter" })
    end,
  },
}
