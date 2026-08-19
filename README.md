# my-dotfiles

My tmux and neovim config.

## Layout → where it goes

| Repo | Install path |
|------|--------------|
| `nvim/` | `~/.config/nvim/` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `tmux/config/` | `~/.config/tmux/` |

```sh
ln -sfn "$PWD/nvim"              ~/.config/nvim
ln -sfn "$PWD/tmux/tmux.conf"    ~/.tmux.conf
ln -sfn "$PWD/tmux/config"       ~/.config/tmux
```

## Bootstrap

```sh
brew install tmux neovim fzf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
tmux new -s main        # then: prefix + I  to install plugins
```

`tmux-thumbs` compiles from Rust source — needs `brew install rust`, then
`cargo build --release` in `~/.tmux/plugins/tmux-thumbs`.

nvim bootstraps lazy.nvim itself on first launch; `lazy-lock.json` pins versions.

## Notes

- tmux prefix is `C-a`. Tabs/popups are on `M-` (Option) with no prefix —
  see `tmux/config/cheatsheet.txt`, or press `M-\` in tmux.
- **Plugin order in `tmux.conf` matters**: `tmux-tokyo-night` must stay last,
  since it overwrites `status-right`. Anything appended after it silently loses
  its statusline hook (this is what broke tmux-continuum).
- Requires Alacritty's `option_as_alt = "Both"` for the `M-` bindings to work
  on macOS.
