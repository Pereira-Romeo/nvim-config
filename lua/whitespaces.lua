------------------- flag trailing whitespaces as errors ------------
vim.cmd([[
  highlight link TrailingWhitespace Error
  syntax match TrailingWhitespace /[ \t]\+$/
]])
