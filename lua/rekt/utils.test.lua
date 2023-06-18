local spy = require("luassert.spy")

local utils = require("rekt.utils")

describe("utils", function()
	it("can rewrite the file name with test suffix", function()
		assert.equal("somefilename_test.go", utils.make_test_name("somefilename.go"))
		assert.equal("somefilename.spec.ts", utils.make_test_name("somefilename.ts"))
		assert.equal("somefilename.spec.tsx", utils.make_test_name("somefilename.tsx"))
		assert.equal("some.file.name.spec.js", utils.make_test_name("some.file.name.js"))
	end)

	it("can rewrite the file name without test suffix", function()
		assert.equal("somefilename.go", utils.make_source_name("somefilename_test.go"))
		assert.equal("somefilename.ts", utils.make_source_name("somefilename.spec.ts"))
		assert.equal("somefilename.tsx", utils.make_source_name("somefilename.spec.tsx"))
		assert.equal("some.file.name.js", utils.make_source_name("some.file.name.spec.js"))
	end)

	describe("edit_file", function()
		local edit, hsplit, vsplit

		before_each(function()
			edit = spy.on(vim.cmd, "e")
			hsplit = spy.on(vim.cmd, "split")
			vsplit = spy.on(vim.cmd, "vsplit")
		end)

		it("opens a new buffer", function()
			utils.edit_file({ open = "buffer" }, "test.lua")

			assert.spy(hsplit).was.called(0)
			assert.spy(vsplit).was.called(0)
			assert.spy(edit).was.called(1)
		end)

		it("opens an hsplit", function()
			utils.edit_file({ open = "horizontal" }, "test.lua")

			assert.spy(hsplit).was.called(1)
			assert.spy(vsplit).was.called(0)
			assert.spy(edit).was.called(1)
		end)

		it("opens a vsplit", function()
			utils.edit_file({ open = "vertical" }, "test.lua")

			assert.spy(hsplit).was.called(0)
			assert.spy(vsplit).was.called(1)
			assert.spy(edit).was.called(1)
		end)
	end)
end)
