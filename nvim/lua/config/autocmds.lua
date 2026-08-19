-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                            Autocommands                                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ General                                                                  │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Remove trailing whitespace on save
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = { "*.v", "*.vh", "*.sv", "*.svh", "*.sva" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Return to last edit position
augroup("RestoreCursor", { clear = true })
autocmd("BufReadPost", {
  group = "RestoreCursor",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Auto resize splits when window is resized
augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = "AutoResize",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Close some filetypes with <q>
augroup("CloseWithQ", { clear = true })
autocmd("FileType", {
  group = "CloseWithQ",
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "checkhealth",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Verilog/SystemVerilog Specific                                           │
-- └──────────────────────────────────────────────────────────────────────────┘

augroup("VerilogSettings", { clear = true })

-- Set up Verilog/SystemVerilog specific options
autocmd("FileType", {
  group = "VerilogSettings",
  pattern = { "verilog", "systemverilog" },
  callback = function()
    local opt = vim.opt_local
    
    -- Indentation
    opt.tabstop = 2
    opt.shiftwidth = 2
    opt.softtabstop = 2
    opt.expandtab = true
    
    -- Comments
    opt.commentstring = "// %s"
    
    -- Fold settings
    opt.foldmethod = "expr"
    opt.foldexpr = "nvim_treesitter#foldexpr()"
    
    -- Useful abbreviations
    vim.cmd([[
      iabbrev <buffer> alwff always_ff @(posedge clk or negedge rst_n) begin<CR>end
      iabbrev <buffer> alwcb always_comb begin<CR>end
      iabbrev <buffer> alwl always_latch begin<CR>end
      iabbrev <buffer> init initial begin<CR>end
      iabbrev <buffer> intf interface<CR>endinterface
      iabbrev <buffer> modu module<CR>endmodule
      iabbrev <buffer> funct function<CR>endfunction
      iabbrev <buffer> taskk task<CR>endtask
      iabbrev <buffer> classs class<CR>endclass
      iabbrev <buffer> pkgg package<CR>endpackage
    ]])
  end,
})

-- Auto-detect top module in file
autocmd("BufReadPost", {
  group = "VerilogSettings",
  pattern = { "*.v", "*.sv" },
  callback = function()
    -- Store module name for quick access
    local lines = vim.api.nvim_buf_get_lines(0, 0, 100, false)
    for _, line in ipairs(lines) do
      local module_name = line:match("^%s*module%s+([%w_]+)")
      if module_name then
        vim.b.verilog_module_name = module_name
        break
      end
    end
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Large File Handling                                                      │
-- └──────────────────────────────────────────────────────────────────────────┘

augroup("LargeFile", { clear = true })
autocmd("BufReadPre", {
  group = "LargeFile",
  callback = function(args)
    local file_size = vim.fn.getfsize(args.file)
    -- Files larger than 1MB
    if file_size > 1024 * 1024 then
      vim.b.large_file = true
      vim.opt_local.foldmethod = "manual"
      vim.opt_local.spell = false
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
      vim.cmd("syntax off")
    end
  end,
})

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Terminal                                                                 │
-- └──────────────────────────────────────────────────────────────────────────┘

augroup("Terminal", { clear = true })
autocmd("TermOpen", {
  group = "Terminal",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.cmd("startinsert")
  end,
})
