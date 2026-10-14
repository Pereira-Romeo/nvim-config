-- Highlights trailing whitespace and odd invisible whitespace characters as errors.

local M = {}

local GROUP = "TrailingWhitespace"

-- Unusual whitespace: no-break space, ogham space, en/em/thin/hair/zero-width spaces,
-- narrow no-break space, medium math space, ideographic space, BOM.
local ODD = "\\u00a0\\u1680\\u2000-\\u200b\\u202f\\u205f\\u3000\\ufeff"

-- trailing spaces/tabs/odd chars (not flagged on the line being typed, to avoid flicker)
local TRAILING = "[ \\t" .. ODD .. "]\\+\\%#\\@<!$"
-- odd characters anywhere in a line
local ANYWHERE = "[" .. ODD .. "]"
-- what gets stripped on save
local STRIP = "[ \\t" .. ODD .. "]\\+$"

local ignored_ft = { "help", "snacks_dashboard", "snacks_picker_input", "snacks_picker_list", "snacks_terminal", "lazygit", "mason" }
local no_strip_ft = { "markdown", "diff", "gitcommit" } -- trailing double space = line break in markdown

local function define_hl()
    vim.api.nvim_set_hl(0, GROUP, { link = "Error" })
end

local function clear_matches()
    for _, var in ipairs({ "ws_trailing", "ws_odd" }) do
        local id = vim.w[var]
        if id then
            pcall(vim.fn.matchdelete, id)
            vim.w[var] = nil
        end
    end
end

-- matchadd is window-local, so (re)apply it whenever a window shows a new buffer
local function apply()
    clear_matches()
    if vim.bo.buftype ~= "" or vim.tbl_contains(ignored_ft, vim.bo.filetype) then
        return
    end
    vim.w.ws_trailing = vim.fn.matchadd(GROUP, TRAILING, 10)
    vim.w.ws_odd = vim.fn.matchadd(GROUP, ANYWHERE, 10)
end

local function strip()
    if vim.bo.buftype ~= "" or vim.bo.binary or not vim.bo.modifiable
        or vim.tbl_contains(no_strip_ft, vim.bo.filetype) then
        return
    end
    local view = vim.fn.winsaveview()
    vim.cmd(("keeppatterns silent! %%s/%s//e"):format(STRIP))
    vim.fn.winrestview(view)
end

---@param opts? { strip_on_save?: boolean, listchars?: boolean }
function M.setup(opts)
    opts = vim.tbl_extend("force", { strip_on_save = true, listchars = true }, opts or {})

    define_hl()
    -- :colorscheme runs `hi clear`, which would drop the link, so re-apply it
    vim.api.nvim_create_autocmd("ColorScheme", { callback = define_hl })

    local aug = vim.api.nvim_create_augroup("WhitespaceHighlight", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType", "TermOpen" }, {
        group = aug,
        callback = apply,
    })
    apply() -- current window

    if opts.strip_on_save then
        vim.api.nvim_create_autocmd("BufWritePre", { group = aug, callback = strip })
    end

    if opts.listchars then
        vim.opt.list = true
        vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
    end

    vim.api.nvim_create_user_command("StripWhitespace", strip, {})
end

return M
