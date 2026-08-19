-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║          Neovim Configuration for SystemVerilog/Verilog Development       ║
-- ║                          Optimized for Linux                              ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

-- Set leader key early (before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Set colorscheme after plugins load
vim.cmd.colorscheme("tokyonight-night")
