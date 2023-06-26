local spy = require("luassert.spy")

local rekt = require("rekt")
local utils = require("rekt.utils")

local filetypes = rekt.config.filetypes

describe("utils", function()
	it("can rewrite the file name with test suffix", function()
		assert.equal("somefilename_test.go", utils.make_test_name("somefilename.go", filetypes))
		assert.equal("somefilename.spec.ts", utils.make_test_name("somefilename.ts", filetypes))
		assert.equal("somefilename.spec.tsx", utils.make_test_name("somefilename.tsx", filetypes))
		assert.equal("some.file.name.spec.js", utils.make_test_name("some.file.name.js", filetypes))
	end)

	it("can rewrite the file name without test suffix", function()
		assert.equal("somefilename.go", utils.make_source_name("somefilename_test.go", filetypes))
		assert.equal("somefilename.ts", utils.make_source_name("somefilename.spec.ts", filetypes))
		assert.equal("somefilename.tsx", utils.make_source_name("somefilename.spec.tsx", filetypes))
		assert.equal("some.file.name.js", utils.make_source_name("some.file.name.spec.js", filetypes))
	end)

	describe("edit_file", function()
		local edit, hsplit, vsplit

		before_each(function()
			edit = spy.on(vim.cmd, "e")
			hsplit = spy.on(vim.cmd, "split")
			vsplit = spy.on(vim.cmd, "vsplit")
		end)

		it("opens a new buffer", function()
			utils.edit_file("test.lua", "bufffer")

			assert.spy(hsplit).was.called(0)
			assert.spy(vsplit).was.called(0)
			assert.spy(edit).was.called(1)
		end)

		it("opens an hsplit", function()
			utils.edit_file("test.lua", "horizontal")

			assert.spy(hsplit).was.called(1)
			assert.spy(vsplit).was.called(0)
			assert.spy(edit).was.called(1)
		end)

		it("opens a vsplit", function()
			utils.edit_file("test.lua", "vertical")

			assert.spy(hsplit).was.called(0)
			assert.spy(vsplit).was.called(1)
			assert.spy(edit).was.called(1)
		end)
	end)
end)
