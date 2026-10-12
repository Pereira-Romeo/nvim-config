require("snacks").setup({
    picker = {
        enabled = true,
        sources = {
            explorer = {
                hidden = true,
                ignored = true,
            },
        },
    },
    indent = { enabled = true },
    notifier = { enabled = true, timeout = 10000 },
    explorer = { enabled = true },
})
