-- Goファイルのときだけ効く設定
-- 既存の options.lua / lsp_servers.lua / conform.lua / keymaps は触らない

-- 1) インデント: Goは「タブ」が標準（gofmtがタブにする）
vim.bo.expandtab = false
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4

-- 2) キーマップ: <leader>go 接頭辞（<leader>t=Toggle, <leader>s=Search, <leader>f=format と衝突しない）
local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = true, desc = desc })
end

map('<leader>gor', '<cmd>w<cr><cmd>!go run .<cr>', 'Go: run')
map('<leader>got', '<cmd>w<cr><cmd>!go test ./...<cr>', 'Go: test')
map('<leader>gol', '<cmd>!golangci-lint run<cr>', 'Go: lint')
map('<leader>gob', '<cmd>!go build ./...<cr>', 'Go: build')

-- 3) LSPは触らない（core/lsp_servers.lua の vim.lsp.enable に gopls が既にある）
--    ここで vim.lsp.start すると二重起動になる
