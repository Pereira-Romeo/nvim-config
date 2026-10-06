vim.g.mapleader = ' ' --key leading all my shortcuts (kinda like folder name of the shortcuts)

require("plugins")
require("options")
require("theme")

require("snack_config")

------------------- markdown stuff ---------------------------------
-- customize later
--require("render-markdown").setup({})


------------------- highlight trailing spaces ----------------------
require("whitespaces")
require("syntax_highlight")
require("lsp")
require("completion")

require("shortcuts")

require("doxygen_hover").setup() -- make K inspect have pretty doxygen render for C/C++
require("epitech_header").setup()
