--  NOTE: Esse módulo é um complemento ao `helpers`.
--  No entanto, ele pode ser importado pela config do user
--  já que o módulo helpers não pode ser importado, pois
--  gera um loop de imports e crasha o Neovim.
local M = {}
local helpers = require "better-vim-core.helpers"

M.statusline = helpers.statusline

---@deprecated use `should_load_theme` instead. This function will be removed in the next major release
M.load_theme = helpers.load_theme

M.should_load_theme = helpers.should_load_theme

return M
