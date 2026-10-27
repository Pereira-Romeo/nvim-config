vim.g.mapleader = ' ' --key leading all my shortcuts (kinda like folder name of the shortcuts)

require("plugins")
require("options")
require("theme")

require("snacks_config")

------------------- markdown stuff ---------------------------------
-- customize later
--require("render-markdown").setup({})


------------------- highlight trailing spaces ----------------------
require("whitespaces").setup({ strip_on_save = false, listchars = true })
require("syntax_highlight")
require("lsp")
require("completion")

require("shortcuts")

--require("doxygen_hover").setup() -- you don't need that.
require("epitech_header").setup({ header_guard = "pragma" })
