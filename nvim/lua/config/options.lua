-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                           Editor Options                                  ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local opt = vim.opt

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Line Numbers & Display                                                   │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false
opt.cmdheight = 1
opt.laststatus = 3            -- Global statusline
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false              -- HDL files are often wide
opt.linebreak = true
opt.colorcolumn = "100"       -- Common line limit for Verilog

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Indentation (Verilog/SystemVerilog Standard)                             │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.tabstop = 2               -- Common for Verilog
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true          -- Use spaces
opt.smartindent = true
opt.autoindent = true
opt.cindent = false           -- Use Verilog-specific indenting

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Search                                                                   │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Files & Backup                                                           │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.autoread = true
opt.hidden = true

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Completion                                                               │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 15
opt.pumblend = 10

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Split Behavior                                                           │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Performance                                                              │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.updatetime = 200
opt.timeoutlen = 300
opt.redrawtime = 1500
opt.lazyredraw = false

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Folding (useful for large HDL modules)                                   │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Clipboard                                                                │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.clipboard = "unnamedplus"

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Misc                                                                     │
-- └──────────────────────────────────────────────────────────────────────────┘
opt.mouse = "a"
opt.mousemoveevent = true
opt.virtualedit = "block"
opt.fillchars = {
  foldopen = "-",
  foldclose = "+",
  fold = " ",
  foldsep = " ",
  diff = "/",
  eob = " ",
}
opt.list = true
opt.listchars = {
  tab = "→ ",
  trail = "·",
  extends = "»",
  precedes = "«",
  nbsp = "␣",
}

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Grep (use ripgrep if available)                                          │
-- └──────────────────────────────────────────────────────────────────────────┘
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden"
  opt.grepformat = "%f:%l:%c:%m"
end

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ File Type Associations                                                   │
-- └──────────────────────────────────────────────────────────────────────────┘
vim.filetype.add({
  extension = {
    v = "verilog",
    vh = "verilog",
    sv = "systemverilog",
    svh = "systemverilog",
    svi = "systemverilog",
    sva = "systemverilog",
    svp = "systemverilog",
    f = "verilog",             -- Verilog filelist
    vf = "verilog",
    vinc = "verilog",
  },
  filename = {
    [".svlsrc"] = "json",       -- svls config file
  },
  pattern = {
    [".*%.v%..*"] = "verilog",
    [".*%.sv%..*"] = "systemverilog",
  },
})
