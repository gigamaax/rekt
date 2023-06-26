local utils = require("rekt.utils")

---@class RektFileConfig: { [string]: RektFileOpt }

---@class RektFileOpt
---@field suffix string The value used to determine the test file name
---@field source_root string The root directory to start searching for source files
---@field test_root string The root directory to start searching for test files

---@alias RektOpenOpt "buffer" | "horizontal" | "vertical"

---@class RektConfig
local default_config = {
	---@type RektOpenOpt
	open = "vertical",
	---@type RektFileConfig
	filetypes = {
		go = { suffix = "_test", },
		js = { suffix = ".spec", },
		lua = { suffix = ".test", source_root = "lua", test_root = "test" },
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

	for type, config in pairs(M.config.filetypes) do
		local configured_opt, missing_opt

		if config.source_root and not config.test_root then
			configured_opt = "source_root"
			missing_opt = "test_root"
		end

		if config.test_root and not config.source_root then
			configured_opt = "test_root"
			missing_opt = "source_root"
		end

		if configured_opt and missing_opt then
			error(string.format(
				"%s cannot be configured without %s for filetype %s",
				configured_opt,
				missing_opt,
				type
			))
		end
	end
end

---@param from_path? string Overrides the path to start searching from the config. Defaults to current directory of the file in the buffer
function M.open_test_file(from_path)
	local filename = vim.api.nvim_buf_get_name(0)
	local basename = vim.fs.basename(filename)

	-- FIXME: handle the error if the type isn't found
	local file_config = M.config.filetypes[utils.guess_type(filename)]
	if file_config.test_root and not from_path then
		local dirname = vim.fs.dirname(filename)
		from_path = string.gsub(dirname, file_config.source_root, file_config.test_root)
	end

	from_path = from_path or vim.fs.dirname(filename)
	local edit_file = string.format("%s/%s", from_path, utils.make_test_name(basename, M.config.filetypes))

	utils.edit_file(edit_file, M.config.open)
end

---@param from_path? string The path to start searching deafults to same directory
function M.open_source_file(from_path)
	local filename = vim.api.nvim_buf_get_name(0)
	local basename = vim.fs.basename(filename)

	-- FIXME: handle the error if the type isn't found
	local file_config = M.config.filetypes[utils.guess_type(filename)]
	if file_config.source_root and not from_path then
		local dirname = vim.fs.dirname(filename)
		from_path = string.gsub(dirname, file_config.test_root, file_config.source_root)
	end

	from_path = from_path or vim.fs.dirname(filename)
	local edit_file = string.format("%s/%s", from_path, utils.make_source_name(basename, M.config.filetypes))

	utils.edit_file(edit_file, M.config.open)
end

return M
