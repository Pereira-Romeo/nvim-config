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
    { src = "https://github.com/meanderingprogrammer/render-markdown.nvim" }, -- markdown rendering
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


-- Bearded theme
require("bearded").setup({
  flavor = "hc-ebony",
  transparent = true,
  bold = true,
  italic = true,
  dim_inactive = false,
  terminal_colors = true,
  on_highlights = function(set, palette, opts)
    -- optional override
    set("Normal", { fg = palette.ui.default })
  end,
})
vim.cmd.colorscheme("bearded")
-- need to change doxygen coloring back, do that later
vim.api.nvim_set_hl(0, "@keyword.doxygen", { fg = "#ff0000" })
vim.api.nvim_set_hl(0, "@tag.doxygen", { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "@variable.parameter.doxygen", { fg = "#00ffff" })




require("lualine").setup() --status bar at the bottom
require("nvim-autopairs").setup {}
require("mini.icons").setup() --custom icons for files, directories etc...
require("snacks").setup({
    picker = {
        enabled = true,
        sources = {
            explorer = {
                hidden = true,
                ignored = false,
            },
        },
    },
    explorer = { enabled = true },
})


------------------- markdown stuff ---------------------------------
-- customize later
require("render-markdown").setup({})


------------------- highlight trailing spaces ----------------------

vim.cmd([[
  highlight link TrailingWhitespace Error
  syntax match TrailingWhitespace /\[ \t]\+$/
]])


------------------- treesitter config ------------------------------

local ts = require("nvim-treesitter")
ts.install("make", "c", "cpp", "rust", "lua", "doxygen", "typescript", "markdown", "dockerfile", "yaml")


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "make", "c", "cpp", "rust", "lua", "typescript", "markdown", "dockerfile", "yaml" },
  callback = function()
    vim.treesitter.start()
  end,
})


------------------- lsp config -------------------------------------

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {"clangd", "rust_analyzer", "lua_ls", "ts_ls", "marksman", "dockerls", "docker_compose_language_service"},
})
vim.lsp.enable({"clangd", "rust_analyzer", "lua_ls", "ts_ls", "marksman", "dockerls", "docker_compose_language_service"})


require("tiny-inline-diagnostic").setup({
    options = {
	multilines = {
	    enabled = true,
	}
    },
    -- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
    preset = "ghost"
})


local cmp = require("blink.cmp")
cmp.build():pwait()

cmp.setup({
    keymap = {
	["<Tab>"] = { "accept", "fallback" },
	["<UpArrow>"] = { "select_prev", "fallback" },
	["<DownArrow>"] = { "select_next", "fallback" },
	["<Esc>"] = { "cancel", "fallback" },
    },
    completion = {
	accept = {
	    auto_brackets = {
		enabled = true,
	    },
	},
    },
    sources = {
	default = {
	    "lsp",
	    "path",
	    "snippets",
	    "buffer",
	},
    },
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



------------------- make K inspect pretty with my doxygen ----------
require("doxygen_hover").setup()


