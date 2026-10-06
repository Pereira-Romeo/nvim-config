# My nvim config

This [config](./init.lua) contains the following plugins:
- **[bearded theme](https://github.com/Ferouk/bearded-nvim)** (more used to it and also better colors for c++ (and also has transparent bg))
- **[lualine](https://github.com/nvim-lualine/lualine.nvim)** (replacing the default nvim bottom status bar)
- **[mini icons](https://github.com/nvim-mini/mini.icons)** (fancy icons)
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**, **[mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim)** (lsp configs)
- **[mason](https://github.com/mason-org/mason.nvim)** (managing installed lsp and other stuff i don't use)
- **[tiny inline diagnostic](https://github.com/rachartier/tiny-inline-diagnostic.nvim)** (short diagnostic at the end of the line of the error)
- **[Snacks](https://github.com/folke/snacks.nvim)** (file grep, open, explorer, diagnostic...)
- **[Blink](https://github.com/saghen/blink.cmp)** (and the **[lib](https://github.com/saghen/blink.lib)**) (auto completion)
- **[tree sitter](https://github.com/nvim-treesitter/nvim-treesitter)** (syntax highlighting)

custom icons for errors, warnings, info, hint

shortcuts

highlighting trailing spaces with an error

render my c/c++ doxygen nicer

`EpitechHeader` to get a prompt that places and fills your epitech-style header


# lsp & syntax highlighting (with treesitter)
- C/C++
- make (no lsp \</3)
- rust
- lua
- doxygen (no lsp)
- typescript
- markdown (no lsp)
- dockerfile
- yaml
- bash


# shortcut list

note that all my shortcuts are led by a space ` `.

- ` fo` opens snacks file opener
- ` fg` opens snacks file grep
- ` fe` opens snacks file explorer
- ` fb` opens snacks file buffers (if i understood well then these are like the open editors in vscode)
- ` fd` opens snacks file diagnostics (errors, hints etc...)
- ` fs` opens snacks file symbols
- ` fS` opens snacks workspace symbols


# dependencies

for the install commands, they're for debian/ubuntu

- `tree-sitter-cli` install with `cargo binstall tree-sitter-cli` (for tree-sitter package), if you don't have cargo, **[check this page](https://rust-lang.org/tools/install/)**
- `ripgrep` install with `sudo snap install ripgrep --classic` (for snacks package: grep)
- `gh` install with `sudo snap install gh --classic` (for all snacks github issues, pull request etc), you'll need to run `gh auth login` before being able to use the shortcuts
- `lazygit` look at their **[repository](https://github.com/jesseduffield/lazygit)** for install (for snacks lazygit window)

