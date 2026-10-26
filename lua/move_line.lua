-- This file is coded with AI.
-- Move the current line (or visual selection) up/down and re-indent it for its new spot,
-- like Alt+Up / Alt+Down in VSCode.
--
-- Usage (shortcuts.lua):
--   vim.keymap.set({ "n", "i", "x" }, "<A-Up>",   function() require("move_line").up() end)
--   vim.keymap.set({ "n", "i", "x" }, "<A-Down>", function() require("move_line").down() end)

local M = {}

-- `=` only does something sensible when the filetype has indent rules; otherwise
-- Neovim falls back to C-indenting, which would mangle e.g. markdown.
local function can_reindent()
    return vim.bo.indentexpr ~= "" or vim.bo.cindent or vim.bo.lisp
end

local function make_indent(width)
    if vim.bo.expandtab then
        return (" "):rep(width)
    end
    local ts = vim.bo.tabstop
    return ("\t"):rep(math.floor(width / ts)) .. (" "):rep(width % ts)
end

-- Re-indent the first non-blank line of s..e with `==`, then shift the rest of the
-- block by the same amount so relative indentation inside the block is preserved.
local function reindent(s, e)
    if not can_reindent() then
        return
    end

    local first
    for l = s, e do
        if vim.fn.getline(l):match("%S") then
            first = l
            break
        end
    end
    if not first then
        return
    end

    local before = vim.fn.indent(first)
    vim.cmd(("silent %dnormal! =="):format(first))
    local delta = vim.fn.indent(first) - before
    if delta == 0 then
        return
    end

    for l = s, e do
        if l ~= first then
            local text = vim.fn.getline(l)
            if text:match("%S") then
                local new_width = math.max(0, vim.fn.indent(l) + delta)
                vim.fn.setline(l, make_indent(new_width) .. text:match("^%s*(.*)$"))
            end
        end
    end
end

-- Move lines s..e one line in direction dir (1 = down, -1 = up).
-- Returns the new range, or nil if already at the top/bottom of the buffer.
local function move_range(s, e, dir)
    if (dir > 0 and e >= vim.fn.line("$")) or (dir < 0 and s <= 1) then
        return nil
    end
    local target = dir > 0 and e + 1 or s - 2
    vim.cmd(("silent %d,%dmove %d"):format(s, e, target))
    return s + dir, e + dir
end

local function leading_bytes(lnum)
    return #vim.fn.getline(lnum):match("^%s*")
end

local function move(dir)
    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" or mode == "\22" then
        local s, e = vim.fn.line("v"), vim.fn.line(".")
        if s > e then
            s, e = e, s
        end
        vim.cmd("normal! " .. vim.keycode("<Esc>"))

        local ns, ne = move_range(s, e, dir)
        if ns then
            reindent(ns, ne)
        else
            ns, ne = s, e
        end
        vim.cmd(("normal! %dGV%dG"):format(ns, ne)) -- reselect, linewise
        return
    end

    -- normal / insert mode: single line
    local pos = vim.api.nvim_win_get_cursor(0)
    local ns = move_range(pos[1], pos[1], dir)
    if not ns then
        return
    end

    local before = leading_bytes(ns)
    reindent(ns, ns)
    local shift = leading_bytes(ns) - before

    -- keep the cursor on the same character after the indent change
    local col = math.max(0, math.min(pos[2] + shift, #vim.fn.getline(ns)))
    vim.api.nvim_win_set_cursor(0, { ns, col })
end

function M.up()
    move(-1)
end

function M.down()
    move(1)
end

return M
