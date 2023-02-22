local utils = require('rekt.utils')

---@class RektConfig
local default_config = {
  ---@class RektSplitConfig
  split_options = {
    ---@type 'vsplit' | 'hsplit'
    direction = 'vsplit'
  },
}

local M = {}

M.config = default_config

---@param opt RektConfig | nil
function M.setup(opt)
  if opt ~= nil then
    M.config = opt
  end
end

function M.open_test_file()
  local filename = vim.api.nvim_buf_get_name(0)
  local basename = vim.fs.basename(filename)

  local test_name = utils.make_test_name(basename)
  local test_name_matches = vim.fs.find(test_name)

  local edit_file
  if #test_name_matches == 0 then
    edit_file = vim.fs.dirname(filename) .. "/" .. test_name
  else
    edit_file = test_name_matches[1]
  end

  utils.edit_file(M.config.split_options, edit_file)
end

return M
