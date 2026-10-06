------------------- treesitter config ------------------------------
local ts = require("nvim-treesitter")
ts.install({"make", "c", "cpp", "rust", "lua", "doxygen", "typescript", "markdown", "dockerfile", "yaml", "bash"})


vim.api.nvim_create_autocmd("FileType", {
  pattern = {"make", "c", "cpp", "rust", "lua", "typescript", "markdown", "dockerfile", "yaml", "bash"},
  callback = function()
    vim.treesitter.start()
  end,
})

-- keyword specific coloring, :Inspect on a word to find out what tree-sitter classify it as if you want to overwrite something else
vim.api.nvim_set_hl(0, "@keyword.doxygen", { fg = "#1FC49E" })
vim.api.nvim_set_hl(0, "@tag.doxygen", { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "@variable.parameter.doxygen", { fg = "#E0A0DB" })
vim.api.nvim_set_hl(0, "@keyword.cpp", { fg = "#F1DB74" })
vim.api.nvim_set_hl(0, "@keyword", { fg = "#F1DB74" })
vim.api.nvim_set_hl(0, "@keyword.operator", { fg = "#1FC49E" })
vim.api.nvim_set_hl(0, "@lsp.typemod.variable.defaultLibrary", { fg = "#EC7886" })
vim.api.nvim_set_hl(0, "@keyword.modifier.cpp", { fg = "#B592F5" })
vim.api.nvim_set_hl(0, "@keyword.type", { fg = "#B592F5" })
vim.api.nvim_set_hl(0, "@keyword.exception.cpp", { fg = "#F1DB74" })
vim.api.nvim_set_hl(0, "@string.make", { fg = "#F35C4C" })
