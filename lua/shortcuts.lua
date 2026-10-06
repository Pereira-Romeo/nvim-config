------------------- shortcuts --------------------------------------
--"n" means shortcut is active while in normal mode, v for visual etc...

vim.keymap.set("n", "<leader>fo", Snacks.picker.files) -- file open
vim.keymap.set("n", "<leader>fe", function() Snacks.picker.explorer() end) -- file explorer
vim.keymap.set("n", "<leader>fb", Snacks.picker.buffers) -- opened files (same as vscode editors)

--search in files
vim.keymap.set("n", "<leader>fg", Snacks.picker.grep) -- file grep (depends on ripgrep)
vim.keymap.set("n", "<leader>fd", Snacks.picker.diagnostics) -- file grep error, hints etc
vim.keymap.set("n", "<leader>fs", Snacks.picker.lsp_symbols) -- grep symbols
vim.keymap.set("n", "<leader>fS", Snacks.picker.lsp_workspace_symbols) -- grep symbols but workspace wise

vim.keymap.set("n", "<leader>t", function() Snacks.terminal() end) -- terminal window (CTRL + D to close it)
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.colorschemes() end) -- change your neovim colorscheme on the fly, note that it resets.

--Misc
vim.keymap.set({"n", "v"}, "<leader>man", function() Snacks.picker.man() end) -- man pages
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end) -- commands helper


--notifications
vim.keymap.set({"n", "v"}, "<leader>n",  function() Snacks.notifier.show_history() end) -- check your notification history


-- github shortcuts (most depend on gh and lazygit)
vim.keymap.set("n", "<leader>lg", function() Snacks.lazygit() end) -- lazygit window
vim.keymap.set({"n", "v"}, "<leader>gB", function() Snacks.gitbrowse() end) -- open current repository in browser
vim.keymap.set({"n", "v"}, "<leader>gi", function() Snacks.picker.gh_issue() end) -- open github issues
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr() end) -- open a pull request
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.gh_pr({ state = "all" }) end) -- see pull requests
