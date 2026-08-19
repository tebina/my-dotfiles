# my-dotfiles

Neovim + tmux config for SystemVerilog/Verilog (FPGA/ASIC) work.
macOS and Linux  see [Install](#install).

## What's here

| Path | Install to | Contents |
|------|-----------|----------|
| `nvim/` | `~/.config/nvim/` | lazy.nvim setup, 54 plugins, HDL LSP + linting + snippets |
| `tmux/tmux.conf` | `~/.tmux.conf` | prefix `C-a`, 7 plugins + tpm, tokyo-night theme |
| `tmux/config/` | `~/.config/tmux/` | cheatsheet + its toggle script |

`nvim/README.md` documents the Neovim side in full : prerequisites, keybindings,
snippets, LSP config, troubleshooting.

## Install

Step by step, from nothing to working. Takes ~10 minutes.

### 1. Install dependencies

**macOS**

```sh
brew install git neovim tmux fzf ripgrep
brew install --cask font-meslo-lg-nerd-font
```

**Debian / Ubuntu**

```sh
sudo apt update
sudo apt install -y git neovim tmux fzf ripgrep build-essential
# Nerd Font: download from https://github.com/ryanoasis/nerd-fonts/releases
```

Then set your terminal's font to **MesloLGS Nerd Font Mono**, or icons render as
boxes.

Check you have what you need:

```sh
nvim --version | head -1      # need >= 0.9, 0.10+ preferred
tmux -V                       # need >= 3.2 (popups)
git --version; rg --version; fzf --version; cc --version
```

### 2. Clone the repo

```sh
git clone https://github.com/tebina/my-dotfiles.git ~/my-dotfiles
cd ~/my-dotfiles
```

### 3. Back up any existing config

Skip nothing here  `ln` does **not** replace an existing directory, it silently
creates the link *inside* it.

```sh
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.config/tmux ~/.config/tmux.bak 2>/dev/null
mv ~/.tmux.conf   ~/.tmux.conf.bak   2>/dev/null
```

### 4. Symlink the configs

```sh
cd ~/my-dotfiles
mkdir -p ~/.config
ln -s "$PWD/nvim"           ~/.config/nvim
ln -s "$PWD/tmux/config"    ~/.config/tmux
ln -s "$PWD/tmux/tmux.conf" ~/.tmux.conf
```

Verify all three point back into the repo:

```sh
ls -l ~/.config/nvim ~/.config/tmux ~/.tmux.conf
```

### 5. Install tmux plugins

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new -s main
```

Inside tmux, press **`Ctrl+A`**, release, then **`Shift+I`**. Wait for
"TMUX environment reloaded". The status bar turns into the tokyo-night theme
when it worked.

### 6. Build tmux-thumbs

The only plugin without a prebuilt binary  it compiles from Rust.

```sh
brew install rust                      # or: sudo apt install cargo
cd ~/.tmux/plugins/tmux-thumbs
cargo build --release
```

Skip this if you do not want it; then delete the `fcsonline/tmux-thumbs`
line from `tmux/tmux.conf`.

### 7. Install nvim plugins

```sh
nvim
```

lazy.nvim bootstraps itself and installs all 54 pinned plugins on first launch.
Wait for it to finish, then `:qa` and reopen. Check health:

```sh
nvim +checkhealth
```

### 8. HDL tooling (only for Verilog/SystemVerilog work)

Everything above works without this. Mason auto-installs
`lua-language-server`; the HDL tools are manual.

```sh
# language server
cargo install svls                     # needs rust from step 6

# linters
brew install verilator icarus-verilog          # macOS
sudo apt install -y verilator iverilog         # Debian/Ubuntu

# formatter: no package, grab a release binary
# https://github.com/chipsalliance/verible/releases
```

### Verify it all works

```sh
tmux kill-server 2>/dev/null; tmux new -s main
```

- Status bar appears **at the top** → tmux.conf loaded
- `Option+T` opens a new tab → keybindings loaded
- `Option+\` opens the cheatsheet sidebar → `~/.config/tmux` linked
- `Ctrl+A` then `U` opens a URL picker → plugins installed

## nvim plugins

54 plugins, all pinned in `lazy-lock.json`. A fresh clone installs these exact
versions. Managed by lazy.nvim, which bootstraps itself on first launch.

**Core / libraries** (4)  
`lazy.nvim` · `plenary.nvim` · `nui.nvim` · `nvim-web-devicons`

**LSP & completion** (15)  
`nvim-lspconfig` · `mason.nvim` · `mason-lspconfig.nvim` · `neodev.nvim` · `fidget.nvim` · `nvim-cmp` · `cmp-nvim-lsp` · `cmp-buffer` · `cmp-path` · `cmp-cmdline` · `cmp_luasnip` · `LuaSnip` · `friendly-snippets` · `lspkind.nvim` · `nvim-autopairs`

**Lint & format** (2)  
`nvim-lint` · `conform.nvim`

**Navigation & search** (10)  
`telescope.nvim` · `telescope-fzf-native.nvim` · `telescope-file-browser.nvim` · `telescope-ui-select.nvim` · `harpoon` · `flash.nvim` · `neo-tree.nvim` · `outline.nvim` · `nvim-spectre` · `nvim-bqf`

**Editing** (5)  
`Comment.nvim` · `nvim-surround` · `mini.ai` · `vim-illuminate` · `todo-comments.nvim`

**Git** (2)  
`gitsigns.nvim` · `git-blame.nvim`

**UI** (10)  
`lualine.nvim` · `bufferline.nvim` · `alpha-nvim` · `which-key.nvim` · `indent-blankline.nvim` · `rainbow-delimiters.nvim` · `nvim-notify` · `dressing.nvim` · `trouble.nvim` · `persistence.nvim`

**Treesitter** (3)  
`nvim-treesitter` · `nvim-treesitter-context` · `nvim-treesitter-textobjects`

**Themes** (3)  
`tokyonight.nvim` · `catppuccin` · `nightfox.nvim`

Language servers are installed by Mason (`lua-language-server` automatically;
HDL servers via cargo, see step 8). Full keybindings and LSP details are in
`nvim/README.md`.

## tmux keys

Prefix is `C-a`. Tab and popup bindings use `M-` (Option) with **no prefix**.

| Key | |
|---|---|
| `M-t` / `M-1..9` / `M-h` `M-l` / `M-w` | new tab / go to tab / prev-next / close |
| `M-p` | fuzzy window palette across all sessions |
| `M-g` | scratch shell popup |
| `M-\` / `M-?` | cheatsheet sidebar / popup |
| `C-a u` `C-a Tab` `C-a F` `C-a /` | URLs · extrakto · thumbs hints · search scrollback |
| `C-a \|` `C-a -` `C-a m` | split right / down / zoom |
| `C-h C-j C-k C-l` | move between panes (and in/out of nvim) |

Full list: `tmux/config/cheatsheet.txt`, or press `M-\` inside tmux.

### tmux plugins

`tpm` · `vim-tmux-navigator` · `tmux-resurrect` · `tmux-fzf-url` · `extrakto` ·
`tmux-fuzzback` · `tmux-thumbs` · `tmux-tokyo-night`

## Gotchas

- Session save/restore is manual: `C-a C-s` saves, `C-a C-r` restores.
- Alacritty needs `option_as_alt = "Both"` or none of the `M-` bindings fire
  on macOS.
- `cheatsheet.txt` contains real ANSI escape bytes. Edit it with `printf`
  or a script  a plain heredoc drops the `\033` and you get literal `[1;36m`
  on screen.
