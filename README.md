# My nvim config

This [config](./init.lua) contains the following:
- **[catppuccin theme](https://github.com/catppuccin/nvim)** (transparent background :P)
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


# currently missing stuff i need to add

docstring reader/interpreter (my doxygen stuff not getting picked up by tree sitter :broken_heart:)
leap

figure out if there's a way to make my compile_flags.txt global to all my projects wihtout putting them in the projects


# shortcut list

note that all my shortcuts are led by a space ` `.

- ` fo` opens snacks file opener
- ` fg` opens snacks file grep
- ` fe` opens snacks file explorer
- ` fb` opens snacks file buffers (if i understood well then these are like the open editors in vscode)
- ` fd` opens snacks file diagnostics (errors, hints etc...)
- ` fs` opens snacks file symbols
- ` fS` opens snacks workspace symbols

