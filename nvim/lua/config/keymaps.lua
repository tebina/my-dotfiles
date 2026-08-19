-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                              Keymaps                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local map = vim.keymap.set

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ General                                                                  │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Better escape
map("i", "jk", "<Esc>", { desc = "Escape insert mode" })
map("i", "jj", "<Esc>", { desc = "Escape insert mode" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Save file
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<CR>", { desc = "Save file" })

-- Quit
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Force quit all" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Navigation                                                               │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Buffer navigation
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<CR>", { desc = "Force delete buffer" })

-- Tab navigation
map("n", "<leader><tab>n", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "]<tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "[<tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Editing                                                                  │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Duplicate lines
map("n", "<A-S-j>", "<cmd>t.<CR>", { desc = "Duplicate line below" })
map("n", "<A-S-k>", "<cmd>t.-1<CR>", { desc = "Duplicate line above" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Don't yank on paste in visual mode
map("v", "p", '"_dP', { desc = "Paste without yanking" })

-- Select all
map("n", "<C-a>", "gg<S-v>G", { desc = "Select all" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ LSP (defined here, activated when LSP attaches)                          │
-- └──────────────────────────────────────────────────────────────────────────┘

-- These are set up in the LSP on_attach function
-- Listed here for reference:
-- gd = Go to definition
-- gD = Go to declaration
-- gr = Go to references
-- gi = Go to implementation
-- K = Hover documentation
-- <leader>ca = Code action
-- <leader>rn = Rename symbol
-- <leader>cf = Format code
-- <leader>cd = Show diagnostics
-- [d = Previous diagnostic
-- ]d = Next diagnostic

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Verilog/SystemVerilog Specific                                           │
-- └──────────────────────────────────────────────────────────────────────────┘

map("n", "<leader>vs", function()
  -- Toggle between .v/.sv and _tb.v/_tb.sv
  local file = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  local tb_file, src_file
  
  if file:match("_tb$") then
    src_file = file:gsub("_tb$", "") .. "." .. ext
    if vim.fn.filereadable(src_file) == 1 then
      vim.cmd("edit " .. src_file)
    end
  else
    tb_file = file .. "_tb." .. ext
    if vim.fn.filereadable(tb_file) == 1 then
      vim.cmd("edit " .. tb_file)
    end
  end
end, { desc = "Toggle source/testbench" })

map("n", "<leader>vh", function()
  -- Toggle between .sv and .svh (or .v and .vh)
  local file = vim.fn.expand("%:r")
  local ext = vim.fn.expand("%:e")
  local new_ext
  
  if ext == "sv" then new_ext = "svh"
  elseif ext == "svh" then new_ext = "sv"
  elseif ext == "v" then new_ext = "vh"
  elseif ext == "vh" then new_ext = "v"
  else return end
  
  local new_file = file .. "." .. new_ext
  if vim.fn.filereadable(new_file) == 1 then
    vim.cmd("edit " .. new_file)
  end
end, { desc = "Toggle header/source" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Diagnostics                                                              │
-- └──────────────────────────────────────────────────────────────────────────┘

map("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Quickfix list" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix" })

-- ┌──────────────────────────────────────────────────────────────────────────┐
-- │ Misc                                                                     │
-- └──────────────────────────────────────────────────────────────────────────┘

-- Toggle options
map("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "Toggle word wrap" })
map("n", "<leader>ul", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative line numbers" })
map("n", "<leader>us", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })

-- Open config
map("n", "<leader>oc", "<cmd>edit $MYVIMRC<CR>", { desc = "Open Neovim config" })

-- Lazy plugin manager
map("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy plugin manager" })
