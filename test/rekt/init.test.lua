local stub = require("luassert.stub")
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
						go = { suffix = "_test", },
						js = { suffix = ".spec", },
						lua = { suffix = ".test", source_root = "lua", test_root = "test" },
						ts = { suffix = ".spec", },
						tsx = { suffix = ".spec", },
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
						go = { suffix = "_test", },
						js = { suffix = ".spec", },
						lua = { suffix = ".test", source_root = "lua", test_root = "test" },
						ts = { suffix = ".spec", },
						tsx = { suffix = ".spec", },
					},
				}
		)

		rekt.setup({ open = "horizontal", filetypes = {}, })
		assert.are_same(rekt.config, { open = "horizontal", filetypes = {}, })

		rekt.setup({ open = "vertical", filetypes = { ts = { suffix = ".test", }, }, })
		assert.are_same(rekt.config, { open = "vertical", filetypes = { ts = { suffix = ".test", }, }, })
	end)

	it("requires both source_root and test_root if one of them is set", function()
		assert.has_error(
			function() rekt.setup({ filetypes = { lua = { suffix = ".test", source_root = "lua", }, }, }) end,
			"source_root cannot be configured without test_root for filetype lua"
		)

		assert.has_error(
			function() rekt.setup({ filetypes = { lua = { suffix = ".test", test_root = "test", }, }, }) end,
			"test_root cannot be configured without source_root for filetype lua"
		)
	end)

	describe("opening test files", function()
		local edit_file
		before_each(function()
			vim.cmd.edit("fake.lua")
			edit_file = spy.on(utils, "edit_file")
		end)

		it("opens in a new buffer", function()
			rekt.setup({ open = "buffer", })
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.test.lua", "buffer")
		end)

		it("opens in a horizontal split", function()
			rekt.setup({ open = "horizontal", })
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.test.lua", "horizontal")
		end)

		it("opens in a vertical split", function()
			rekt.setup({ open = "vertical", })
			rekt.open_test_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.test.lua", "vertical")
		end)

		it("opens a test file from a different root", function()
			local dirname = stub(vim.fs, "dirname")
			dirname.returns("/rekt/lua")

			rekt.setup({ filetypes = { lua = { suffix = ".test", test_root = "test", source_root = "lua" }, }, })
			rekt.open_test_file()

			assert.spy(edit_file).was.called_with("/rekt/test/fake.test.lua", "vertical")
		end)
	end)

	describe("opening source files", function()
		local edit_file
		before_each(function()
			vim.cmd.edit("fake.test.lua")
			edit_file = spy.on(utils, "edit_file")
		end)

		it("opens in a new buffer", function()
			rekt.setup({ open = "buffer", })
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.lua", "buffer")
		end)

		it("opens in a horizontal split", function()
			rekt.setup({ open = "horizontal", })
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.lua", "horizontal")
		end)

		it("opens in a vertical split", function()
			rekt.setup({ open = "vertical", })
			rekt.open_source_file("fake_path")

			assert.spy(edit_file).was.called_with("fake_path/fake.lua", "vertical")
		end)

		it("opens a source file from a different root", function()
			local dirname = stub(vim.fs, "dirname")
			dirname.returns("/rekt/test")

			rekt.setup({ filetypes = { lua = { suffix = ".test", test_root = "test", source_root = "lua" }, }, })
			rekt.open_source_file()

			assert.spy(edit_file).was.called_with("/rekt/lua/fake.lua", "vertical")
		end)
	end)
end)
