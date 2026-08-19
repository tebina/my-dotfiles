#!/bin/sh
# Toggle a narrow cheat-sheet pane on the right. Identified by pane_title.
pane=$(tmux list-panes -F '#{pane_title} #{pane_id}' | awk '$1=="cheatsheet"{print $2}')
if [ -n "$pane" ]; then
  tmux kill-pane -t "$pane"
else
  tmux split-window -h -l 40 "less -R ~/.config/tmux/cheatsheet.txt"
  tmux select-pane -T cheatsheet
  tmux last-pane
fi
