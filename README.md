# my-dotfiles

Neovim + tmux config for SystemVerilog/Verilog (FPGA/ASIC) work on macOS.

## What's here

| Path | Install to | Contents |
|------|-----------|----------|
| `nvim/` | `~/.config/nvim/` | lazy.nvim setup, 55 plugins, HDL LSP + linting + snippets |
| `tmux/tmux.conf` | `~/.tmux.conf` | prefix `C-a`, 7 plugins, tokyo-night theme |
| `tmux/config/` | `~/.config/tmux/` | cheatsheet + its toggle script |

`nvim/README.md` documents the Neovim side in full — prerequisites, keybindings,
snippets, LSP config, troubleshooting.

## Install

```sh
git clone git@github.com:tebina/my-dotfiles.git ~/my-dotfiles
cd ~/my-dotfiles

# back up anything already there — ln will NOT replace an existing directory,
# it silently nests the link inside it
mv ~/.config/nvim  ~/.config/nvim.bak  2>/dev/null
mv ~/.config/tmux  ~/.config/tmux.bak  2>/dev/null
mv ~/.tmux.conf    ~/.tmux.conf.bak    2>/dev/null

ln -s "$PWD/nvim"           ~/.config/nvim
ln -s "$PWD/tmux/config"    ~/.config/tmux
ln -s "$PWD/tmux/tmux.conf" ~/.tmux.conf
```

### Dependencies

```sh
brew install tmux neovim fzf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new -s main          # then press: C-a  I    (installs tmux plugins)
```

nvim bootstraps lazy.nvim on first launch and installs from `lazy-lock.json`
(54 plugins pinned). HDL tooling — `svls`, `veridian`, `verible`, `verilator`,
`iverilog` — is listed in `nvim/README.md` under Prerequisites.

`tmux-thumbs` has no prebuilt binary; it compiles from Rust:

```sh
brew install rust
cd ~/.tmux/plugins/tmux-thumbs && cargo build --release
```

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

- **`tmux-tokyo-night` must stay last in the plugin list.** It overwrites
  `status-right`, so any plugin added after it silently loses its statusline
  hook. This is what killed `tmux-continuum` here — it stopped saving and kept
  restoring one stale 2024 session on every start.
- Session save/restore is **manual**: `C-a C-s` saves, `C-a C-r` restores.
  Continuum's auto-restore is deliberately not enabled.
- Alacritty needs `option_as_alt = "Both"` or none of the `M-` bindings fire
  on macOS.
- `cheatsheet.txt` contains real ANSI escape bytes. Edit it with `printf`
  or a script — a plain heredoc drops the `\033` and you get literal `[1;36m`
  on screen.
