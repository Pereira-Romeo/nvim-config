------------------- auto completion --------------------------------
local cmp = require("blink.cmp")
cmp.build():pwait()

cmp.setup({
    keymap = {
	["<Tab>"] = { "accept", "fallback" },
	["<UpArrow>"] = { "select_prev", "fallback" },
	["<DownArrow>"] = { "select_next", "fallback" },
	["<Esc>"] = { "cancel", "fallback" },
    },
    completion = {
	accept = {
	    auto_brackets = {
		enabled = true,
	    },
	},
    },
    sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    providers = {
        snippets = { score_offset = 20 },
        lsp = {
            transform_items = function(_, items)
                return vim.tbl_filter(function(item)
                    local text = item.insertText
                        or (item.textEdit and item.textEdit.newText)
                        or ""
                    local is_snippet = item.kind == vim.lsp.protocol.CompletionItemKind.Snippet
                    -- drop clangd's "namespace ${1:identifier} {" pattern so the one that shows up is only our snippet
                    return not (is_snippet and text:match("^namespace%s+%$%b{}%s*{"))
                end, items)
            end,
        },
    },
},
})

require("nvim-autopairs").setup {}
