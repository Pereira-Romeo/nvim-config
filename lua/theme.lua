-- Bearded theme
require("bearded").setup({
  flavor = "hc-ebony",
  transparent = true,
  bold = true,
  italic = true,
  dim_inactive = false,
  terminal_colors = true,
  --on_highlights = function(set, palette)
    -- optional override
    --set("Normal", { fg = palette.ui.default })
  --end,
})
vim.cmd.colorscheme("bearded")

require("lualine").setup() --status bar at the bottom
require("mini.icons").setup() --custom icons for files, directories etc...
