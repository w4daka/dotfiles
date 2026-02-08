-- use 2-spaces indent vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
-- scroll offset as 3 lines
vim.opt.scrolloff = 3
-- move the cursor to the previous/next line across the first/last character
vim.opt.whichwrap = 'b,s,h,l,<,>,[,],~'
vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = true,  -- これが重要
}
require('w4daka/bool_fn')

vim.opt.clipboard = 'unnamedplus'
