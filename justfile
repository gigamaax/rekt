test:
  nvim --headless -c "PlenaryBustedFile lua/rekt/utils.test.lua"

watch:
  watchexec -w lua just test
