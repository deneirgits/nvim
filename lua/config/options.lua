-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
local window = vim.wo

opt.scrolloff = 999

window.colorcolumn = "120"

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
