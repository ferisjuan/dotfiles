-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt

opt.textwidth = 80

opt.formatoptions = "l"
opt.formatoptions = opt.formatoptions
  + "c" -- In general, I like it when comments respect textwidth
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter in insert mode
  + "n" -- Indent past the formatlistpat, not underneath it.
