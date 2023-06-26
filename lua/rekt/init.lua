local utils = require("rekt.utils")

---@class RektFileConfig: { [string]: RektFileOpt }

---@class RektFileOpt
---@field suffix string The value used to determine the test file name

---@alias RektOpenOpt "buffer" | "horizontal" | "vertical"
---@alias RektSearchOpt "root" | "sibling"

---@class RektConfig
local default_config = {
	---@type RektOpenOpt
	open = "vertical",
	---@type RektFileConfig
	filetypes = {
		go = { suffix = "_test", },
		js = { suffix = ".spec", },
		lua = { suffix = ".test", },
		ts = { suffix = ".spec", },
		tsx = { suffix = ".spec", },
	},
}

local M = {}

---@type RektConfig
M.config = default_config

---@param opt RektConfig | nil
function M.setup(opt)
	M.config = vim.tbl_extend("force", default_config, opt or {})
end

---@param from_path? string The path to start searching deafults to same directory
function M.open_test_file(from_path)
	local filename = vim.api.nvim_buf_get_name(0)
	local basename = vim.fs.basename(filename)

	from_path = from_path or vim.fs.dirname(filename)
	local edit_file = string.format("%s/%s", from_path, utils.make_test_name(basename, M.config.filetypes))

	utils.edit_file(edit_file, M.config.open)
end

---@param from_path? string The path to start searching deafults to same directory
function M.open_source_file(from_path)
	local filename = vim.api.nvim_buf_get_name(0)
	local basename = vim.fs.basename(filename)

	from_path = from_path or vim.fs.dirname(filename)
	local edit_file = string.format("%s/%s", from_path, utils.make_source_name(basename, M.config.filetypes))

	utils.edit_file(edit_file, M.config.open)
end

return M
