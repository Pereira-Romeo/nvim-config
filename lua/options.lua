------------------- Neovim basic options ---------------------------
vim.opt.showmode = false -- hide the default mode bar of neovim (which displays insert when in sert mode
vim.wo.number = true --show line number
vim.opt.expandtab = true --prevent neovim from placing \t, replace them by spaces.
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
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
