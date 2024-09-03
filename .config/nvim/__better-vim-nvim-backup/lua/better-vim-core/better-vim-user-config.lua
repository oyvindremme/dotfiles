local M = {
  user_config = {}
}
package.loaded[...] = M

M.user_config = require "better-vim.better-vim"

return M
