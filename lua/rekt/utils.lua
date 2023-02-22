local extratypes = {
  ts = "typescript",
  tsx = "typescript",
}

local test_ext = {
  go = "_test",
  javascript = ".spec",
  lua = ".test",
  typescript = ".spec",
  typescriptreact = ".spec", -- this is weird
}

local M = {}

---@param filename string
---@return string
function M.guess_type(filename)
  local type = vim.filetype.match({ filename = filename, })
  if type ~= "" and type ~= nil then
    return type
  end

  local tokens = vim.split(filename, ".", { plain = true, trimempty = true, })
  return extratypes[tokens[#tokens]]
end

---@param filename string
---@return string
function M.make_test_name(filename)
  local filetype = M.guess_type(filename)
  local test_name = string.gsub(filename, "(.*)(%.)(%w+)", "%1" .. test_ext[filetype] .. ".%3")
  return test_name
end

---@param config RektSplitConfig | nil
---@param file string
function M.edit_file(config, file)
  if config ~= nil then
    if config.direction == "vsplit" then
      vim.cmd.vsplit()
    else
      vim.cmd.split()
    end
  end

  -- TOOD: will need to handle multiple file names or when the file doesn't exist
  vim.cmd.e(file)
end

return M
