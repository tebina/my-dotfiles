-- Verilog filetype settings
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true
vim.opt_local.commentstring = "// %s"
vim.opt_local.colorcolumn = "100"

-- Match pairs for Verilog
vim.opt_local.matchpairs:append({ "begin:end" })
