------------------- THIS PART IS MADE BY AI BECAUSE ----------------
------------------- lazy and also not interested in ----------------
------------------- learning this right now ------------------------

local M = {}


-- Pretty Doxygen hover for C/C++ using clangd
--
-- K:
--   1. asks clangd for the hover/signature
--   2. asks clangd where the declaration is
--   3. reads the original Doxygen comment from that location
--   4. renders the documentation as Markdown

local function pretty_doxygen_hover()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({
    bufnr = bufnr,
    method = "textDocument/hover",
  })

  if #clients == 0 then
    vim.lsp.buf.hover()
    return
  end

  local client = clients[1]
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

  local hover_result
  local declaration_result

  local function show()
    if not hover_result or not declaration_result then
      return
    end

    ------------------------------------------------------------
    -- Find the declaration location.
    ------------------------------------------------------------

    local location = declaration_result

    if vim.islist(location) then
      location = location[1]
    end

    if not location then
      vim.lsp.buf.hover()
      return
    end

    local range = location.range
    local uri = location.uri or location.targetUri

    if not range or not uri then
      vim.lsp.buf.hover()
      return
    end

    ------------------------------------------------------------
    -- Load the declaration buffer.
    ------------------------------------------------------------

    local filename = vim.uri_to_fname(uri)
    local target_buf = vim.fn.bufadd(filename)

    if not vim.api.nvim_buf_is_loaded(target_buf) then
      vim.fn.bufload(target_buf)
    end

    local declaration_line = range.start.line

    local source_lines = vim.api.nvim_buf_get_lines(
      target_buf,
      0,
      declaration_line,
      false
    )

    ------------------------------------------------------------
    -- Find the Doxygen comment immediately above the declaration.
    ------------------------------------------------------------

    local comment = {}
    local i = #source_lines

    -- Skip blank lines.
    while i > 0 and source_lines[i]:match("^%s*$") do
      i = i - 1
    end

    if i > 0 and source_lines[i]:match("^%s*%*/") then
      -- /** ... */
      table.insert(comment, 1, source_lines[i])
      i = i - 1

      while i > 0 do
        table.insert(comment, 1, source_lines[i])

        if source_lines[i]:match("^%s*/%*") then
          break
        end

        i = i - 1
      end

    else
      -- /// one-line Doxygen comments
      while i > 0 and source_lines[i]:match("^%s*///") do
        table.insert(comment, 1, source_lines[i])
        i = i - 1
      end
    end

    if #comment == 0 then
      vim.lsp.buf.hover()
      return
    end

    ------------------------------------------------------------
    -- Clean the Doxygen comment.
    ------------------------------------------------------------

    local cleaned = {}

    for _, line in ipairs(comment) do
      -- /**, /***, etc.
      line = line:gsub("^%s*/%*+%s?", "")

      -- Leading '*'
      line = line:gsub("^%s*%*%s?", "")

      -- ///
      line = line:gsub("^%s*///%s?", "")

      -- Closing */
      line = line:gsub("%s*%*/%s*$", "")

      table.insert(cleaned, line)
    end

    ------------------------------------------------------------
    -- Parse Doxygen.
    ------------------------------------------------------------

    local brief = {}
    local params_docs = {}
    local returns = {}
    local exceptions = {}

    local current_section = brief

    for _, line in ipairs(cleaned) do
      line = vim.trim(line)

      if line == "" then
        if #current_section > 0 and current_section[#current_section] ~= "" then
          table.insert(current_section, "")
        end

      else
        -- @brief
        local value = line:match("^@brief%s+(.+)$")

        if value then
          current_section = brief
          table.insert(brief, value)

        else
          -- @param [in/out/in,out] name description
          local direction, name, description =
            line:match("^@param%s+%[?(in,out|in|out)%]?%s+(%S+)%s*(.*)$")

          if not name then
            name, description =
              line:match("^@param%s+(%S+)%s*(.*)$")
          end

          if name then
            params_docs[name] = description
            current_section = nil

          else
            -- @return / @returns
            value = line:match("^@returns?%s+(.+)$")

            if value then
              table.insert(returns, value)
              current_section = returns

            else
              -- @exception / @throw / @throws
              value =
                line:match("^@(?:exception|throw|throws)%s+(.+)$")

              if value then
                table.insert(exceptions, value)
                current_section = exceptions

              elseif not line:match("^@%w+") then
                -- Ordinary prose after @brief.
                if current_section then
                  table.insert(current_section, line)
                end
              end
            end
          end
        end
      end
    end

    ------------------------------------------------------------
    -- Extract clangd's signature.
    ------------------------------------------------------------

    local signature = {}

    local contents = hover_result.contents

    if type(contents) == "table"
      and contents.kind == "markdown"
    then
      contents = contents.value
    elseif type(contents) == "table"
      and contents.kind == "plaintext"
    then
      contents = contents.value
    end

    if type(contents) == "string" then
      local in_code_block = false

      for line in contents:gmatch("[^\r\n]*") do
        if line:match("^```") then
          in_code_block = not in_code_block
        elseif in_code_block then
          table.insert(signature, line)
        end
      end
    elseif vim.islist(contents) then
      for _, item in ipairs(contents) do
        if type(item) == "table" and item.language and item.value then
          table.insert(signature, "```" .. item.language)
          vim.list_extend(
            signature,
            vim.split(item.value, "\n", { plain = true })
          )
          table.insert(signature, "```")
        end
      end
    end

    ------------------------------------------------------------
    -- Build the pretty Markdown document.
    ------------------------------------------------------------

    local output = {}

    -- Brief
    for _, line in ipairs(brief) do
      table.insert(output, line)
    end

    if #brief > 0 then
      table.insert(output, "")
    end

    -- Parameters
    if next(params_docs) then
      table.insert(output, "### Parameters")
      table.insert(output, "")

      -- Try to preserve the declaration's parameter order.
      local parameter_order = {}

      for _, line in ipairs(source_lines) do
        for name in line:gmatch("[%w_]+%s*[,%)=]") do
          name = name:gsub("[%s,%)=]", "")

          if params_docs[name] and not vim.tbl_contains(parameter_order, name) then
            table.insert(parameter_order, name)
          end
        end
      end

      -- Anything we couldn't determine the order of.
      for name in pairs(params_docs) do
        if not vim.tbl_contains(parameter_order, name) then
          table.insert(parameter_order, name)
        end
      end

      for _, name in ipairs(parameter_order) do
        local description = params_docs[name]

        if description ~= "" then
          table.insert(
            output,
            "- `" .. name .. "` — " .. description
          )
        else
          table.insert(output, "- `" .. name .. "`")
        end
      end

      table.insert(output, "")
    end

    -- Returns
    if #returns > 0 then
      table.insert(output, "### Returns")
      table.insert(output, "")

      for _, line in ipairs(returns) do
        table.insert(output, line)
      end

      table.insert(output, "")
    end

    -- Exceptions
    if #exceptions > 0 then
      table.insert(output, "### Exceptions")
      table.insert(output, "")

      for _, line in ipairs(exceptions) do
        table.insert(output, "- " .. line)
      end

      table.insert(output, "")
    end

    ------------------------------------------------------------
    -- Signature
    ------------------------------------------------------------

    if #signature > 0 then
      table.insert(output, "---")
      table.insert(output, "")
      vim.list_extend(output, signature)
    end

    -- Remove trailing blank lines.
    while #output > 0 and output[#output] == "" do
      table.remove(output)
    end

    if #output == 0 then
      vim.lsp.buf.hover()
      return
    end

    ------------------------------------------------------------
    -- Show it.
    ------------------------------------------------------------

    vim.lsp.util.open_floating_preview(
      output,
      "markdown",
      {
        border = "rounded",
        max_width = math.floor(vim.o.columns * 0.7),
        max_height = math.floor(vim.o.lines * 0.65),
        focusable = true,
      }
    )
  end

  --------------------------------------------------------------
  -- Request hover.
  --------------------------------------------------------------

  client:request(
    "textDocument/hover",
    params,
    function(err, result)
      if not err then
        hover_result = result
        show()
      end
    end,
    bufnr
  )

  --------------------------------------------------------------
  -- Request declaration.
  --
  -- Declaration is preferable to definition because the Doxygen
  -- comment normally lives next to the declaration in the header.
  --------------------------------------------------------------

  client:request(
    "textDocument/declaration",
    params,
    function(err, result)
      if not err or result then
        declaration_result = result
        show()
      end
    end,
    bufnr
  )

  --------------------------------------------------------------
  -- Some clangd setups don't return declaration locations.
  -- Fall back to definition.
  --------------------------------------------------------------

  vim.defer_fn(function()
    if declaration_result == nil then
      client:request(
        "textDocument/definition",
        params,
        function(err, result)
          if not err then
            declaration_result = result
            show()
          end
        end,
        bufnr
      )
    end
  end, 100)
end

vim.keymap.set("n", "K", pretty_doxygen_hover, {
  silent = true,
  desc = "Pretty Doxygen hover",
})

function M.setup()
    vim.keymap.set("n", "K", pretty_doxygen_hover, { silent = true, desc = "Pretty Doxygen hover" })
end

return M

