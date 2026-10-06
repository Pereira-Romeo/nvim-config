------------------- package list -----------------------------------
vim.pack.add {
    -- UI customizing
    { src = "https://github.com/Ferouk/bearded-nvim", name = "bearded" }, -- theme
    { src = "https://github.com/nvim-lualine/lualine.nvim" }, -- neovim mode line
    -- misc
    { src = "https://github.com/folke/snacks.nvim" }, -- useful stuff like grep, explorer, diagnostic, etc...
    { src = "https://github.com/nvim-mini/mini.icons" }, -- custom icons
    -- lsp
    { src = "https://github.com/neovim/nvim-lspconfig" }, -- default lsp configs
    { src = "https://github.com/mason-org/mason.nvim" }, -- pakcage manager for lsp servers and misc
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- mason default lsp config
    { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" }, -- lsp info on same line as error
    -- auto complete
    { src = "https://github.com/saghen/blink.lib" }, -- auto completion
    { src = "https://github.com/saghen/blink.cmp" }, -- auto completion
    { src = "https://github.com/windwp/nvim-autopairs" }, -- auto place mirror brackets and quotes
    -- syntax highlighting etc
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- tree sitter, dunno what to tell ya
    --{ src = "https://github.com/meanderingprogrammer/render-markdown.nvim" }, -- markdown rendering
}
