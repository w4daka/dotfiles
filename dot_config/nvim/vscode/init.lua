
-- ===== VSCode Neovim 最小構成 =====

-- 基本設定（軽め）
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- クリップボード連携（WSL）
vim.opt.clipboard = "unnamedplus"

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
  cache_enabled = true,
}

-- VSCode のときだけキー設定を制限
if vim.g.vscode then
  -- VSCodeでの操作に便利なキーのみ設定
  vim.keymap.set("n", "<space>w", "<cmd>w<cr>")
  vim.keymap.set("n", "<space>q", "<cmd>q<cr>")

  -- 不要なキーマップの無効化
  vim.keymap.set("n", "q:", "<nop>")
end
