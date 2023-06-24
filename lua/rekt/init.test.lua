local spy = require("luassert.spy")

local rekt = require("rekt")
local utils = require("rekt.utils")

describe("config", function()
	it("adds a defualt config", function()
		rekt.setup()
		assert.are_same(
		rekt.config,
				{
					open = "vertical",
					filetypes = {
						go = "_test",
						javascript = ".spec",
						lua = ".test",
						typescript = ".spec",
						typescriptreact = ".spec",
					},
				}
		)
	end)

	it("merges the config", function()
		rekt.setup({ open = "buffer", })
		assert.are_same(
		rekt.config,
				{
					open = "buffer",
					filetypes = {
						go = "_test",
						javascript = ".spec",
						lua = ".test",
						typescript = ".spec",
						typescriptreact = ".spec",
					},
				}
		)

		rekt.setup({ open = "horizontal", filetypes = {}, })
		assert.are_same(rekt.config, { open = "horizontal", filetypes = {}, })

		rekt.setup({ open = "vertical", filetypes = { typescript = ".test", }, })
		assert.are_same(rekt.config, { open = "vertical", filetypes = { typescript = ".test", }, })
	end)

	describe("opening test files", function()
		local edit_file
		before_each(function()
			edit_file = spy.on(utils, "edit_file")
		end)

		it("opens in a new buffer", function()
			rekt.setup({ open = "buffer", })
			vim.cmd.edit("fake.lua")
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.test.lua", "buffer")
		end)

		it("opens in a horizontal split", function()
			rekt.setup({ open = "horizontal", })
			vim.cmd.edit("fake.lua")
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.test.lua", "horizontal")
		end)

		it("opens in a vertical split", function()
			rekt.setup({ open = "vertical", })
			vim.cmd.edit("fake.lua")
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.test.lua", "vertical")
		end)
	end)

	describe("opening source files", function()
		local edit_file
		before_each(function()
			edit_file = spy.on(utils, "edit_file")
		end)

		it("opens in a new buffer", function()
			rekt.setup({ open = "buffer", })
			vim.cmd.edit("fake.test.lua")
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.lua", "buffer")
		end)

		it("opens in a horizontal split", function()
			rekt.setup({ open = "horizontal", })
			vim.cmd.edit("fake.test.lua")
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.lua", "horizontal")
		end)

		it("opens in a vertical split", function()
			rekt.setup({ open = "vertical", })
			vim.cmd.edit("fake.test.lua")
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.lua", "vertical")
		end)
	end)
end)
