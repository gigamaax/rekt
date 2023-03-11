local utils = require("rekt.utils")

describe("utils", function()
  it("can guess the file type from a filename", function()
    assert.equal("go", utils.guess_type("somefilename.go"))
    assert.equal("typescript", utils.guess_type("somefilename.ts"))
    assert.equal("javascript", utils.guess_type("some.file.name.js"))
  end)

  it("can rewrite the file name with test suffix", function()
    assert.equal("somefilename_test.go", utils.make_test_name("somefilename.go"))
    assert.equal("somefilename.spec.ts", utils.make_test_name("somefilename.ts"))
    assert.equal("somefilename.spec.tsx", utils.make_test_name("somefilename.tsx"))
    assert.equal("some.file.name.spec.js", utils.make_test_name("some.file.name.js"))
  end)

  it("can build a choice list", function()
    assert.same(
      { "Select a file", "1. Option 1", "2. Option 2", },
      utils.build_choice_list({ "Option 1", "Option 2", })
    )
  end)
end)
