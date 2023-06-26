# rekt

neovim plugin for easy test file opening

## Features

- Open tests for the current buffer
- Open source for the buffer

## Configuration

```lua
local rekt = require("rekt")

rekt.setup()
```

The default behavior is to open new buffers vertically

### Default options

```lua
{
	open = "vertical",
	filetypes = {
		go = { suffix = "_test", },
		js = { suffix = ".spec", },
		lua = { suffix = ".test", source_root = "lua", test_root = "test" },
		ts = { suffix = ".spec", },
		tsx = { suffix = ".spec", }
	},
}
```

#### open

Controls how to open the file

- `buffer`: opens in a new buffer
- `horizontal`: opens in a new horizontal split
- `vertical`: opens in a new vertical split

#### filetypes

Filetype configuration.

- `suffix` how to specify test. The separator is important (`.`, `_`, `-`)
- `source_root` optional field useful for when the test and source files are
stored separately
- `test_root` optional field useful for when the test and source files are
stored separately

**NOTE:** if either `source_root` or `test_root` is defined, the other must also
be defined. This is for opening files that haven't been created yet.

## API

### `open_test_file`

```lua
rekt.open_test_file()
```

Based on the file in the current buffer, find a test file that matches the name.
You may optionally pass in a `from_path` which will be the starting path to
begin the search. If no `from_path` is provided, it will default to the
directory of the file in the buffer.

### `open_source_file`

```lua
rekt.open_source_file()
```

Based on the file in the current buffer, find a source file that maches the
name. You may optionally pass in a `from_path` which will be the starting path
to begin the search. If no `from_path` is provided, it will default to the
directory of the file in the buffer.
