-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set(
  "n",
  "<leader>q",
  vim.diagnostic.setloclist,
  { desc = "Open diagnostic [Q]uickfix list" }
)

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- 挿入モード (Insert mode) での Emacs ライクな操作
local map = vim.keymap.set

map("i", "<C-b>", "<Left>", { desc = "左へ移動" })
map("i", "<C-f>", "<Right>", { desc = "右へ移動" })
map("i", "<C-a>", "<ESC>I", { desc = "行頭へ移動" })
map("i", "<C-e>", "<End>", { desc = "行末へ移動" })
map("i", "<C-d>", "<Del>", { desc = "一文字削除" })

vim.keymap.set({ "n", "x" }, "x", '"_d', { desc = "Delete using blackhole register" })
vim.keymap.set("n", "X", '"_D', { desc = "Delete using blackhole register" })
vim.keymap.set("o", "x", "d", { desc = "Delete using x" })

vim.keymap.set("c", "<c-b>", "<left>", { desc = "Emacs like left" })
vim.keymap.set("c", "<c-f>", "<right>", { desc = "Emacs like right" })
vim.keymap.set("c", "<c-a>", "<home>", { desc = "Emacs like home" })
vim.keymap.set("c", "<c-e>", "<end>", { desc = "Emacs like end" })
vim.keymap.set("c", "<c-h>", "<bs>", { desc = "Emacs like bs" })
vim.keymap.set("c", "<c-d>", "<del>", { desc = "Emacs like del" })

vim.keymap.set("n", "<space>;", "@:", { desc = "Re-run the last command" })
vim.keymap.set("n", "<space>w", "<cmd>write<cr>", { desc = "Write" })
vim.keymap.set("c", "<c-n>", function()
  return vim.fn.wildmenumode() == 1 and "<c-n>" or "<down>"
end, { expr = true, desc = "Select next" })
vim.keymap.set("c", "<c-p>", function()
  return vim.fn.wildmenumode() == 1 and "<c-p>" or "<up>"
end, { expr = true, desc = "Select previous" })

vim.keymap.set("n", "q:", "<nop>", { desc = "Disable cmdwin" })
vim.keymap.set("n", "<leader>t", function()
  -- 1. 垂直分割して新しいバッファを作成
  vim.cmd("vnew")
  -- 2. そのバッファでターミナルを起動
  vim.cmd("terminal")
  -- 3. (任意) ターミナル特有の設定：行番号非表示など
  vim.wo.number = false
  vim.wo.relativenumber = false
  -- 4. 挿入モードへ移行
  vim.cmd("startinsert")
end, { desc = "Vertical terminal" })

-- LuaSnipをTabで展開、ジャンプ
vim.keymap.set({ "i", "s" }, "<Tab>", function()
  local ls = require("luasnip")
  if ls.expand_or_jumpable() then
    return "<Plug>luasnip-expand-or-jump"
  else
    return "<Tab>"
  end
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  local ls = require("luasnip")
  if ls.jumpable(-1) then
    return "<Plug>luasnip-jump-prev"
  else
    return "<S-Tab>"
  end
end, { expr = true, silent = true })
