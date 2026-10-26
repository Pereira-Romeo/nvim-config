------------------- shortcuts --------------------------------------
--"n" means shortcut is active while in normal mode, v for visual etc...
--

-- moving lines
vim.keymap.set({ "n", "i", "x" }, "<A-Up>", function() require("move_line").up() end, {desc = "move line/selection up"})
vim.keymap.set({ "n", "i", "x" }, "<A-Down>", function() require("move_line").down() end,  {desc = "move line/selection down"})

-- quick change indent
vim.keymap.set("n", "<S-Tab>", "<<", {desc = "remove one indent (does nothing at column 0)"})
vim.keymap.set("i", "<S-Tab>", "<C-d>", {desc = "same, in insert mode"})
vim.keymap.set("x", "<S-Tab>", "<gv", {desc = "remove one indent from selected lines, keep selection"})
vim.keymap.set("x", "<Tab>", ">gv", {desc = "add one indent to selected lines, keep selection"})

-- stuff
vim.keymap.set("n", "<leader>fo", Snacks.picker.files) -- file open
vim.keymap.set("n", "<leader>fe", function() Snacks.picker.explorer() end) -- file explorer
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers) -- opened files (same as vscode editors)

--search in files
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep) -- file grep (depends on ripgrep)
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics) -- file grep error, hints etc
vim.keymap.set("n", "<leader>fs", Snacks.picker.lsp_symbols) -- grep symbols
vim.keymap.set("n", "<leader>fS", Snacks.picker.lsp_workspace_symbols) -- grep symbols but workspace wise

vim.keymap.set("n", "<leader>t", function() Snacks.terminal() end, {desc = "Open a terminal window, <C-d> to kill it"})
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.colorschemes() end, {desc = "Change your colorscheme, note that it resets on start"})

--Misc
vim.keymap.set({"n", "v"}, "<leader>man", function() Snacks.picker.man() end, {desc = "Open man pages"})
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, {desc = "Open commands helper"})
vim.keymap.set("n", "<C-s>", "<cmd>write<CR>", {desc = "Save file."})

--notifications
vim.keymap.set({"n", "v"}, "<leader>n",  function() Snacks.notifier.show_history() end) -- check your notification history


-- github shortcuts (most depend on gh and lazygit)
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end) -- lazygit window
vim.keymap.set({"n", "v"}, "<leader>gB", function() Snacks.gitbrowse() end) -- open current repository in browser
vim.keymap.set({"n", "v"}, "<leader>gi", function() Snacks.picker.gh_issue() end) -- open github issues
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr() end) -- open a pull request
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.gh_pr({ state = "all" }) end) -- see pull requests
