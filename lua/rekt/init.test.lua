local spy = require("luassert.spy")

local rekt = require("rekt")
local utils = require("rekt.utils")

describe("config", function()
	it("adds a defualt config", function()
		rekt.setup()
		assert.are_same(rekt.config, { open = "vertical" })
	end)

	it("sets the config", function()
		rekt.setup({ open = "buffer" })
		assert.are_same(rekt.config, { open = "buffer" })

		rekt.setup({ open = "horizontal" })
		assert.are_same(rekt.config, { open = "horizontal" })

		rekt.setup({ open = "vertical" })
		assert.are_same(rekt.config, { open = "vertical" })
	end)

	describe("opening test files", function()
		local edit_file
		before_each(function()
			edit_file = spy.on(utils, "edit_file")
		end)

		it("opens in a new buffer", function()
			rekt.setup({ open = "buffer" })
			vim.cmd.edit("fake.lua")
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with({ open = "buffer" }, "fake_path/fake.test.lua")
		end)

		it("opens in a horizontal split", function()
			rekt.setup({ open = "horizontal" })
			vim.cmd.edit("fake.lua")
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with({ open = "horizontal" }, "fake_path/fake.test.lua")
		end)

		it("opens in a vertical split", function()
			rekt.setup({ open = "vertical" })
			vim.cmd.edit("fake.lua")
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with({ open = "vertical" }, "fake_path/fake.test.lua")
		end)
	end)

	describe("opening source files", function()
		local edit_file
		before_each(function()
			edit_file = spy.on(utils, "edit_file")
		end)

		it("opens in a new buffer", function()
			rekt.setup({ open = "buffer" })
			vim.cmd.edit("fake.test.lua")
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with({ open = "buffer" }, "fake_path/fake.lua")
		end)

		it("opens in a horizontal split", function()
			rekt.setup({ open = "horizontal" })
			vim.cmd.edit("fake.test.lua")
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with({ open = "horizontal" }, "fake_path/fake.lua")
		end)

		it("opens in a vertical split", function()
			rekt.setup({ open = "vertical" })
			vim.cmd.edit("fake.test.lua")
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with({ open = "vertical" }, "fake_path/fake.lua")
		end)
	end)
end)
