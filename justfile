test: test_init test_util

test_init:
  nvim --headless -c "PlenaryBustedFile lua/rekt/init.test.lua"

test_util:
  nvim --headless -c "PlenaryBustedFile lua/rekt/utils.test.lua"

watch:
  watchexec -w lua just test
