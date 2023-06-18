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
	return (string.gsub(filename, "(.*)(%.)(%w+)", "%1" .. test_ext[filetype] .. ".%3"))
end

---@param filename string
---@return string
function M.make_source_name(filename)
	local filetype = M.guess_type(filename)
	return (string.gsub(filename, "(.*)" .. test_ext[filetype] .. ".(%w+)", "%1.%2"))
end

---@param config RektConfig
---@param file string
function M.edit_file(config, file)
	if config.open == "horizontal" then
		vim.cmd.split()
	elseif config.open == "vertical" then
		vim.cmd.vsplit()
	end

	-- TOOD: will need to handle multiple file names or when the file doesn't exist
	vim.cmd.e(file)
end

return M
