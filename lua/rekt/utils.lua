local M = {}

---@param config RektConfig
---@param file string
function M.edit_file(config, file)
  if config.open_type == 'split' then
    vim.cmd.vnew()
  end

  -- TOOD: will need to handle multiple file names or when the file doesn't exist
  vim.cmd.e(file)
end

return M
