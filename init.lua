------------------- package list -----------------------------------
vim.pack.add {
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" }, -- theme
    { src = "https://github.com/nvim-lualine/lualine.nvim" }, -- neovim mode line
    { src = "https://github.com/folke/snacks.nvim" }, -- useful stuff like grep, explorer, diagnostic, etc...
    { src = "https://github.com/nvim-mini/mini.icons" }, -- custom icons
    { src = "https://github.com/neovim/nvim-lspconfig" }, -- default lsp configs
    { src = "https://github.com/mason-org/mason.nvim" }, -- pakcage manager for lsp servers and misc
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- mason default lsp config
    { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" } -- lsp info on same line as error
}


------------------- theme & editor misc -----------------------------
vim.opt.showmode = false -- hide the default mode bar of neovim (which displays insert when in sert mode
vim.wo.number = true --show line number
vim.o.shiftwidth = 4
vim.o.winborder = "rounded" -- for man popup

vim.diagnostic.config({
    virtual_text = false,
    signs = {
	text = {
	    [vim.diagnostic.severity.ERROR] = " ",
	    [vim.diagnostic.severity.WARN] = " ",
	    [vim.diagnostic.severity.INFO] = "󰛨 ",
	    [vim.diagnostic.severity.HINT] = " ",
	},
    },
})


require("catppuccin").setup({
    flavour = "auto", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    float = {
        transparent = true, -- enable transparent floating windows
        solid = false, -- use solid styling for floating windows, see |winborder|
    },
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
})
vim.cmd.colorscheme "catppuccin-nvim"


require("lualine").setup() --status bar at the bottom
require("mini.icons").setup() --custom icons for files, directories etc...
require("snacks").setup({
    picker = { enabled = true },
    explorer = { enabled = true },
})


------------------- lsp config -------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {"clangd", "rust_analyzer", "lua_ls"},
})
vim.lsp.enable({ 'clangd', 'rust_analyzer', 'lua_ls' })


require("tiny-inline-diagnostic").setup({
    options = {
	multilines = {
	    enabled = true,
	}
    },
    -- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
    preset = "ghost"
})

------------------- shortcuts --------------------------------------
vim.g.mapleader = ' ' --key leading all my shortcuts (kinda like folder name of the shortcuts)

--"n" means shortcut is active while in normal mode
vim.keymap.set("n", "<leader>fo", Snacks.picker.files) -- file open
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep) -- file grep
vim.keymap.set("n", "<leader>fe", function() Snacks.picker.explorer() end) -- file explorer
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers) -- opened files (same as vscode editors)
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics) -- file grep error, hints etc
vim.keymap.set("n", "<leader>fs", Snacks.picker.lsp_symbols) -- i forgor
vim.keymap.set("n", "<leader>fS", Snacks.picker.lsp_workspace_symbols) -- i forgor but workspace wise

