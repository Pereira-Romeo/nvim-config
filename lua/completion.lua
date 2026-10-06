------------------- auto completion --------------------------------
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

require("nvim-autopairs").setup {}
