-- This file is coded with AI.
-- Adds the Epitech style header to a file
-- And adds header guard to .h and .hpp files (either set it to define, pragma or false if you don't want guards)
local M = {}

M.config = {
  -- "define"  -> #ifndef / #define / #endif guard
  -- "pragma"  -> #pragma once
  -- false     -> no header guard
  header_guard = "define",
}

local block = { open = "/*", close = "*/", prefix = "** ", empty = "**" }
local line = { prefix = "# ", empty = "#", shebang = true }

local styles = {
  c = block,
  cpp = block,
  rust = block,
  javascript = block,
  typescript = block,
  sh = line,
  bash = line,
  make = line,
  python = line,
}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

---------------------------------------------------------------------------
-- Popup prompt
---------------------------------------------------------------------------
local function prompt(opts, on_done)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"

  local width = math.min(60, vim.o.columns - 4)
  local height = opts.multiline and 8 or 1
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. opts.title .. " ",
    title_pos = "center",
  }
  if vim.fn.has("nvim-0.10") == 1 then
    win_opts.footer = opts.multiline and " <C-s> confirm | <C-c> cancel " or " <CR> confirm | <C-c> cancel "
    win_opts.footer_pos = "center"
  end

  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.wo[win].wrap = true

  local closed = false
  local function close(submit)
    if closed then return end
    closed = true
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    vim.cmd("stopinsert")
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if submit then
      vim.schedule(function() on_done(lines) end)
    end
  end

  local function map(modes, lhs, submit)
    vim.keymap.set(modes, lhs, function() close(submit) end, { buffer = buf, nowait = true })
  end

  map({ "i", "n" }, "<C-c>", false)
  map("n", "<Esc>", false)
  map("n", "q", false)
  if opts.multiline then
    map({ "i", "n" }, "<C-s>", true)
    map("n", "<CR>", true)
  else
    map({ "i", "n" }, "<CR>", true)
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = buf,
    once = true,
    callback = function() close(false) end,
  })

  vim.cmd("startinsert")
end

---------------------------------------------------------------------------
-- Header building / detection
---------------------------------------------------------------------------
local function build(style, project, name, desc_lines)
  local out = {}
  local function add(s)
    s = s:gsub("%s+$", "")
    out[#out + 1] = (s == "") and style.empty or (style.prefix .. s)
  end

  if style.open then out[#out + 1] = style.open end
  add(project .. " PROJECT, " .. os.date("%Y"))
  add(name)
  add("file description:")
  for _, l in ipairs(desc_lines) do add(l) end
  -- block comments close themselves; line comments get a blank separator
  out[#out + 1] = style.close or ""
  return out
end

-- Returns (start, end_exclusive) 0-indexed of an existing header, or nil.
local function find_existing(buf, style, first)
  local lines = vim.api.nvim_buf_get_lines(buf, first, first + 200, false)
  local p = style.prefix:gsub("%s+$", "")
  local i = 1

  if style.open then
    if lines[1] ~= style.open then return nil end
    i = 2
  end

  if not (lines[i] and lines[i]:match("^" .. vim.pesc(p) .. " .+ PROJECT, %d%d%d%d$")) then
    return nil
  end
  if not (lines[i + 2] and lines[i + 2]:lower() == p .. " file description:") then
    return nil
  end

  if style.open then
    for j = i + 3, #lines do
      if lines[j] == style.close then
        return first, first + j
      elseif not lines[j]:match("^" .. vim.pesc(p)) then
        return nil
      end
    end
    return nil
  end

  local j = i + 3
  while lines[j] and lines[j]:match("^" .. vim.pesc(p)) do j = j + 1 end
  local last = j - 1
  if lines[j] == "" then last = j end -- swallow our blank separator line
  return first, first + last
end

---------------------------------------------------------------------------
-- Header guards (.h / .hpp)
---------------------------------------------------------------------------
local function is_c_header(buf)
  local ext = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":e"):lower()
  return ext == "h" or ext == "hpp"
end

local function guard_macro(buf, fallback)
  local stem = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t:r")
  if stem == "" then stem = fallback end
  stem = stem:gsub("[^%w]", "_"):upper()
  return stem .. "_H"
end

local function has_guard(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, l in ipairs(lines) do
    if l:match("^%s*#%s*pragma%s+once") then return true end
    local macro = l:match("^%s*#%s*ifndef%s+([%w_]+)")
    if macro then
      for j = i + 1, #lines do
        if lines[j] ~= "" then
          if lines[j]:match("^%s*#%s*define%s+" .. macro .. "%f[^%w_]") then return true end
          break
        end
      end
    end
  end
  return false
end

-- header_end: 0-indexed exclusive end of the Epitech header in the buffer.
local function add_guard(buf, header_end, fallback_name)
  local mode = M.config.header_guard
  if not mode or not is_c_header(buf) or has_guard(buf) then return end

  local rest = vim.api.nvim_buf_get_lines(buf, header_end, -1, false)
  while #rest > 0 and trim(rest[1]) == "" do table.remove(rest, 1) end
  while #rest > 0 and trim(rest[#rest]) == "" do table.remove(rest) end

  local out = { "" }
  if mode == "pragma" then
    out[#out + 1] = "#pragma once"
    if #rest > 0 then
      out[#out + 1] = ""
      vim.list_extend(out, rest)
    end
  else
    local macro = guard_macro(buf, fallback_name)
    out[#out + 1] = "#ifndef " .. macro
    out[#out + 1] = "    #define " .. macro
    out[#out + 1] = ""
    if #rest > 0 then
      vim.list_extend(out, rest)
      out[#out + 1] = ""
    end
    out[#out + 1] = "#endif /* " .. macro .. " */"
  end

  vim.api.nvim_buf_set_lines(buf, header_end, -1, false, out)
end

---------------------------------------------------------------------------
-- Apply
---------------------------------------------------------------------------
local function apply(buf, style, project, name, desc_lines)
  local header = build(style, project, name, desc_lines)

  local first = 0
  local l1 = vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1]
  if style.shebang and l1 and l1:match("^#!") then first = 1 end

  local s, e = find_existing(buf, style, first)
  local start = s or first
  vim.api.nvim_buf_set_lines(buf, start, e or start, false, header)

  add_guard(buf, start + #header, name)
end

---------------------------------------------------------------------------
-- Command
---------------------------------------------------------------------------
function M.run()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local style = styles[ft]
  if not style then
    vim.notify("EpitechHeader: unsupported filetype '" .. ft .. "'", vim.log.levels.ERROR)
    return
  end

  local buf_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t:r")

  prompt({ title = "Enter project type (default: EPITECH)" }, function(l1)
    local project = trim(l1[1] or "")
    if project == "" then project = "EPITECH" end

    prompt({ title = "Enter project name (default: current workdir)" }, function(l2)
      local name = trim(l2[1] or "")
      if name == "" then name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") end

      prompt({ title = "Enter file description (default: filename)", multiline = true }, function(l3)
        while #l3 > 0 and trim(l3[#l3]) == "" do table.remove(l3) end
        if #l3 == 0 then
          l3 = { buf_name ~= "" and buf_name or name }
        end
        if vim.api.nvim_buf_is_valid(buf) then
          apply(buf, style, project, name, l3)
        end
      end)
    end)
  end)
end

function M.setup(opts)
  M.config = vim.tbl_extend("force", M.config, opts or {})
  local g = M.config.header_guard
  if g ~= false and g ~= "define" and g ~= "pragma" then
    vim.notify('epitech_header: header_guard must be "define", "pragma" or false', vim.log.levels.WARN)
    M.config.header_guard = "define"
  end
  vim.api.nvim_create_user_command("EpitechHeader", M.run, {})
end

return M
