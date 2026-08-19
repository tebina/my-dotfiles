-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                     LSP Configuration for HDL                             ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Diagnostic signs
      local signs = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- LSP keymaps (applied when LSP attaches)
      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gr", vim.lsp.buf.references, "Go to references")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gt", vim.lsp.buf.type_definition, "Go to type definition")

        -- Information
        map("n", "K", vim.lsp.buf.hover, "Hover documentation")
        map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Actions
        map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("v", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ async = true })
        end, "Format code")

        -- Diagnostics
        map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "<leader>dl", vim.diagnostic.setloclist, "Diagnostics to loclist")

        -- Workspace
        map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
        map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
        map("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folders")

        -- Inlay hints (if supported)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      -- Capabilities with cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      local lspconfig = require("lspconfig")

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │ SystemVerilog Language Server (svls)                               │
      -- │ Install: cargo install svls                                        │
      -- └────────────────────────────────────────────────────────────────────┘
      lspconfig.svls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern(".svlsrc", ".git", "*.sv", "*.v"),
        settings = {
          systemverilog = {
            includeIndexing = { "**/*.{sv,svh,v,vh}" },
            excludeIndexing = { "sim/**/*.*" },
            defines = {},
            launchConfiguration = "verilator -sv --lint-only",
            formatCommand = "verible-verilog-format",
          },
        },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │ Veridian (Alternative SystemVerilog LSP)                           │
      -- │ Install: cargo install veridian                                    │
      -- └────────────────────────────────────────────────────────────────────┘
      -- Uncomment to use veridian instead of svls
      -- lspconfig.veridian.setup({
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      --   root_dir = lspconfig.util.root_pattern(".git", "*.sv", "*.v"),
      -- })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │ HDL Checker (Supports multiple simulators)                         │
      -- │ Install: pip install hdl-checker                                   │
      -- └────────────────────────────────────────────────────────────────────┘
      lspconfig.hdl_checker.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern(".hdl_checker.config", ".git"),
        cmd = { "hdl_checker", "--lsp" },
      })

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │ Verible (Google's Verilog/SystemVerilog tools)                     │
      -- │ For formatting and linting (not a full LSP)                        │
      -- │ Install: See https://github.com/chipsalliance/verible              │
      -- └────────────────────────────────────────────────────────────────────┘
      -- Verible is used through null-ls for formatting

      -- ┌────────────────────────────────────────────────────────────────────┐
      -- │ Lua LSP (for Neovim config)                                        │
      -- └────────────────────────────────────────────────────────────────────┘
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
    end,
  },

  -- Mason (LSP/tool installer)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "lua-language-server",
        -- Note: svls and veridian are best installed via cargo
        -- "verible" can be installed manually from GitHub releases
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end,
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          done_icon = "✓",
        },
      },
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
}
