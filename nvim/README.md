# Neovim Configuration for SystemVerilog/Verilog Development

A comprehensive Neovim configuration optimized for FPGA and ASIC development on Linux.

## Features

- **LSP Support**: svls, veridian, hdl_checker for code intelligence
- **Syntax Highlighting**: Tree-sitter based highlighting for Verilog/SystemVerilog
- **Linting**: Verilator, Icarus Verilog, Verible integration
- **Formatting**: Verible-verilog-format with customizable options
- **Snippets**: 40+ SystemVerilog/Verilog snippets for common patterns
- **File Navigation**: Telescope fuzzy finder with HDL-specific filters
- **Modern UI**: Tokyo Night theme, bufferline, statusline, file explorer

## Prerequisites

### Required
- Neovim >= 0.9.0 (0.10+ recommended)
- Git
- A C compiler (gcc/clang) for tree-sitter
- ripgrep (for telescope searching)
- A Nerd Font (for icons)

### HDL Tools (Install what you need)

#### Language Servers

```bash
# svls (Rust-based, recommended)
cargo install svls

# OR veridian (alternative)
cargo install veridian

# hdl-checker (Python-based, supports multiple simulators)
pip install hdl-checker
```

#### Linting Tools

```bash
# Verilator (most popular)
sudo apt install verilator

# Icarus Verilog (alternative)
sudo apt install iverilog
```

#### Formatting Tools

```bash
# Verible (from Google) - Download from GitHub releases
# https://github.com/chipsalliance/verible/releases

# Example for Linux x64:
wget https://github.com/chipsalliance/verible/releases/download/v0.0-3428-gcfcbb82b/verible-v0.0-3428-gcfcbb82b-linux-static-x86_64.tar.gz
tar -xzf verible-*.tar.gz
sudo cp verible-*/bin/* /usr/local/bin/
```

## Installation

### 1. Backup Existing Config

```bash
# Backup existing config if you have one
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. Install This Configuration

```bash
# Copy the config
cp -r /path/to/nvim-config ~/.config/nvim

# OR if downloading from somewhere:
git clone <repo-url> ~/.config/nvim
```

### 3. Start Neovim

```bash
nvim
```

On first launch:
- Lazy.nvim will auto-install
- All plugins will be downloaded
- Tree-sitter parsers will be installed
- LSP servers will be set up via Mason

## Directory Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua         # Editor settings
│   │   ├── keymaps.lua         # Key bindings
│   │   └── autocmds.lua        # Auto commands
│   ├── plugins/
│   │   ├── colorscheme.lua     # Color themes
│   │   ├── lsp.lua             # LSP configuration
│   │   ├── completion.lua      # Autocompletion (nvim-cmp)
│   │   ├── treesitter.lua      # Syntax highlighting
│   │   ├── linting.lua         # Linters & formatters
│   │   ├── telescope.lua       # Fuzzy finder
│   │   ├── ui.lua              # UI components
│   │   └── editor.lua          # Editor enhancements
│   └── snippets/
│       └── verilog.lua         # HDL snippets
└── after/
    └── ftplugin/
        ├── verilog.lua         # Verilog-specific settings
        └── systemverilog.lua   # SystemVerilog-specific settings
```

## Key Bindings

Leader key: `<Space>`

### General

| Key | Description |
|-----|-------------|
| `jk` or `jj` | Exit insert mode |
| `<C-s>` | Save file |
| `<leader>q` | Quit |
| `<Esc>` | Clear search highlights |

### Navigation

| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate windows |
| `<S-h>` / `<S-l>` | Previous/Next buffer |
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | List buffers |

### LSP

| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>cf` | Format code |
| `[d` / `]d` | Previous/Next diagnostic |

### Verilog/SystemVerilog

| Key | Description |
|-----|-------------|
| `<leader>vs` | Toggle source/testbench |
| `<leader>vh` | Toggle header/source |
| `<leader>vm` | Find Verilog files |
| `<leader>vg` | Grep in Verilog files |

### Git

| Key | Description |
|-----|-------------|
| `]h` / `[h` | Next/Previous hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Blame line |

## Snippets

Type the trigger and press `<Tab>` to expand:

### Module & Structure
- `mod` - Full module template with parameters
- `modmin` - Minimal module template
- `intf` - Interface with modports

### Always Blocks
- `alwff` - always_ff with reset
- `alwffp` - always_ff (posedge only)
- `alwcb` - always_comb
- `alwl` - always_latch

### FSM & Control
- `fsm` - Complete FSM template
- `case` - case statement
- `unique` - unique case

### Types
- `logic` - logic declaration
- `enum` - enum typedef
- `struct` - struct typedef

### Generate
- `genfor` - generate for loop
- `genif` - generate if

### Testbench
- `tb` - Full testbench template
- `clkgen` - Clock generator
- `task` - task declaration
- `func` - function declaration

### Common Patterns
- `fifo` - FIFO logic template
- `counter` - Counter with enable/clear
- `shiftreg` - Shift register

### Assertions
- `assert` - Simple assertion
- `asserti` - Implication assertion
- `cover` - Cover property
- `assume` - Assume property

### Comments
- `header` - File header
- `section` - Section comment

## LSP Configuration

### svls Configuration

Create `.svlsrc` in your project root:

```json
{
  "includeIndexing": ["**/*.{sv,svh,v,vh}"],
  "excludeIndexing": ["sim/**/*.*", "tb/**/*.*"],
  "defines": {
    "SYNTHESIS": ""
  },
  "launchConfiguration": "verilator -sv --lint-only"
}
```

### hdl_checker Configuration

Create `.hdl_checker.config`:

```
vhdl_ls.toml
```

Or use project-specific `.hdl_checker.config`:

```
[verilog]
files = *.v
include = include/

[systemverilog]
files = *.sv, *.svh
include = include/
```

## Customization

### Change Colorscheme

In `init.lua`, change:
```lua
vim.cmd.colorscheme("tokyonight-night")
```

Options: `tokyonight-night`, `tokyonight-storm`, `catppuccin`, `nightfox`

### Change Indentation

Edit `lua/config/options.lua`:
```lua
opt.tabstop = 4      -- Change from 2 to 4
opt.shiftwidth = 4
opt.softtabstop = 4
```

### Enable Format on Save

In Neovim, press `<leader>uf` to toggle format on save.

Or set it permanently in `lua/plugins/linting.lua`.

### Switch Linter

Press `<leader>cL` to select between verilator, iverilog, or verible.

## Troubleshooting

### LSP Not Working

1. Check if the language server is installed:
   ```bash
   which svls
   ```

2. Check LSP status in Neovim:
   ```
   :LspInfo
   ```

3. Check logs:
   ```
   :LspLog
   ```

### Tree-sitter Errors

Reinstall parsers:
```
:TSUpdate verilog
```

### Plugin Issues

Update all plugins:
```
:Lazy sync
```

Reset plugin state:
```bash
rm -rf ~/.local/share/nvim
nvim  # Reinstalls everything
```

## Resources

- [svls](https://github.com/dalance/svls) - SystemVerilog Language Server
- [veridian](https://github.com/vivekmalneedi/veridian) - Alternative SV LSP
- [verilator](https://www.veripool.org/verilator/) - Fast Verilog simulator/linter
- [verible](https://github.com/chipsalliance/verible) - Google's SV tools
- [Neovim LSP](https://neovim.io/doc/user/lsp.html) - Neovim LSP documentation

## License

MIT License - Feel free to use and modify!
