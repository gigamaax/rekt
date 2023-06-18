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

---@param from_path string The path to start searching deafults to same directory
function M.open_test_file(from_path)
	local filename = vim.api.nvim_buf_get_name(0)
	local basename = vim.fs.basename(filename)

	from_path = from_path or vim.fs.dirname(filename)
	local edit_file = string.format("%s/%s", from_path, utils.make_test_name(basename))

	utils.edit_file(M.config.split_options, edit_file)
end

---@param from_path string The path to start searching deafults to same directory
function M.open_source_file(from_path)
	local filename = vim.api.nvim_buf_get_name(0)
	local basename = vim.fs.basename(filename)

	from_path = from_path or vim.fs.dirname(filename)
	local edit_file = string.format("%s/%s", from_path, utils.make_source_name(basename))

	utils.edit_file(M.config.split_options, edit_file)
end

return M
