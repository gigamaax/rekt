local M = {}

---@param filename string
---@return string
function M.guess_type(filename)
	local tokens = vim.split(filename, ".", { plain = true, trimempty = true, })
	return tokens[#tokens]
end

---@param filename string
---@param filetypes RektFileConfig
---@return string
function M.make_test_name(filename, filetypes)
	local type = M.guess_type(filename)
	local config = filetypes[type]

	return (string.gsub(filename, "(.*)(%.)(%w+)", "%1" .. config.suffix .. ".%3"))
end

---@param filename string
---@param filetypes RektFileConfig
---@return string
function M.make_source_name(filename, filetypes)
	local type = M.guess_type(filename)
	local config = filetypes[type]

	return (string.gsub(filename, "(.*)" .. config.suffix .. ".(%w+)", "%1.%2"))
end

---@param file string
---@param open RektOpenOpt
function M.edit_file(file, open)
	if open == "horizontal" then
		vim.cmd.split()
	elseif open == "vertical" then
		vim.cmd.vsplit()
	end

	-- TOOD: will need to handle multiple file names or when the file doesn't exist
	vim.cmd.e(file)
end

return M
