------------------- lsp config -------------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {"clangd", "rust_analyzer", "lua_ls", "ts_ls", "marksman", "dockerls", "docker_compose_language_service", "bashls"},
})

vim.lsp.config("lua_ls", { --just removing the vim warning from the nvim config
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "Snacks" } },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME },
            },
        },
    },
})

vim.lsp.enable({"clangd", "rust_analyzer", "lua_ls", "ts_ls", "marksman", "dockerls", "docker_compose_language_service", "bashls"})

require("tiny-inline-diagnostic").setup({
    options = {
	    multilines = {
	        enabled = true,
	    }
    },
    -- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
    preset = "ghost"
})
