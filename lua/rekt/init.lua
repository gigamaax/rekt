local utils = require('rekt.utils')

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

---@class RektConfig
local default_config = {
  ---@type 'split' | 'buffer'
  open_type = "split",
}


local M = {}

M.config = default_config

---@param opt RektConfig | nil
function M.setup(opt)
  if opt ~= nil then
    M.config = opt
  end
end

function M.guess_type(filename)
  local type = vim.filetype.match({ filename = filename, })
  if type ~= "" and type ~= nil then
    return type
  end

  local tokens = vim.split(filename, ".", { plain = true, trimempty = true, })
  return extratypes[tokens[#tokens]]
end

function M.make_test_name(filename)
  local filetype = M.guess_type(filename)
  return string.gsub(filename, "(.*)(%.)(%w+)", "%1" .. test_ext[filetype] .. ".%3")
end

function M.open_test_file(opt)
  local filename = opt.args == "%" and vim.api.nvim_buf_get_name(0) or opt.args or opt
  local basename = vim.fs.basename(filename)

  local test_name = M.make_test_name(basename)
  local test_name_matches = vim.fs.find(test_name)

  local edit_file
  if #test_name_matches == 0 then
    edit_file = vim.fs.dirname(filename) .. "/" .. test_name
  else
    edit_file = test_name_matches[1]
  end

  utils.edit_file(M.config, edit_file)
end

return M
