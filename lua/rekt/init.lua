local utils = require("rekt.utils")

---@class RektConfig
local default_config = {
  ---@class RektSplitConfig
  split_options = {
    ---@type 'vsplit' | 'hsplit'
    direction = "vsplit",
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
  local pathname = vim.fs.dirname(filename)

  local test_name = utils.make_test_name(basename)
  local test_name_matches = vim.fs.find(test_name, { limit = math.huge, path = pathname })

  local edit_file = nil
  if #test_name_matches == 0 then
    edit_file = vim.fs.dirname(filename) .. "/" .. test_name
  elseif #test_name_matches == 1 then
    edit_file = test_name_matches[1]
  else
    local choices = utils.build_choice_list(test_name_matches)
    local choice = vim.fn.inputlist(choices)
    if choice == 0 then
      edit_file = nil
    else
      edit_file = test_name_matches[choice]
    end
  end

  if edit_file ~= nil then
    utils.edit_file(M.config.split_options, edit_file)
  end
end

return M
