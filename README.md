# My nvim config

This [config](./init.lua) contains the following:
- **[catppuccin theme](https://github.com/catppuccin/nvim)** (transparent background :P)
- **[lualine](https://github.com/nvim-lualine/lualine.nvim)** (replacing the default nvim bottom status bar)
- **[mini icons](https://github.com/nvim-mini/mini.icons)** (fancy icons)
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**, **[mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim)** (lsp configs)
- **[mason](https://github.com/mason-org/mason.nvim)** (managing installed lsp and other stuff i don't use)
- **[tiny inline diagnostic](https://github.com/rachartier/tiny-inline-diagnostic.nvim)** (short diagnostic at the end of the line of the error)
- **[Snacks](https://github.com/folke/snacks.nvim)** (file grep, open, explorer, diagnostic...)

custom icons for errors, warnings, info, hint

shortcuts


# currently missing stuff i need to add

auto complete
docstring reader/interpreter
leap
lsp for makefile, python, html, css
figure out the compile_commands.json so clangd stops yelling about my correct includes
figure out how to copy paste stuff with system clipboard


# shortcut list

note that all my shortcuts are led by a space ` `.

- ` fo` opens snacks file opener
- ` fg` opens snacks file grep
- ` fe` opens snacks file explorer
- ` fb` opens snacks file buffers (if i understood well then these are like the open editors in vscode)
- ` fd` opens snacks file diagnostics (errors, hints etc...)
- ` fs` opens snacks file symbols
- ` fS` opens snacks workspace symbols

