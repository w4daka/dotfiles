-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.hl_op()
  end,
})
-- augroup for this config file
local augroup = vim.api.nvim_create_augroup("init.lua", {})

-- wrapper function to use internal augroup
local function create_autocmd(event, opts)
  vim.api.nvim_create_autocmd(
    event,
    vim.tbl_extend("force", {
      group = augroup,
    }, opts)
  )
end

-- https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(event)
    local dir = vim.fs.dirname(event.file)
    local force = vim.v.cmdbang == 1
    if
      vim.bool_fn.isdirectory(dir) == false
      and (force or vim.fn.confirm('"' .. dir .. '"dose not exist. Create?', "&Yes\n&No") == 1)
    then
      vim.fn.mkdir(vim.fn.iconv(dir, vim.opt.encoding:get(), vim.opt.termencoding:get()), "p")
    end
  end,
  desc = "Auto mkdir to save file",
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
-- init.lua または適当な場所で確認
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    print("LSP Attached: " .. client.name .. " to buffer " .. args.buf)
  end,
})

-- IME (Fcitx5) を強制的に英語入力にする関数
local function fcitx_off()
  -- fcitx5-remote が存在するか確認してから実行（エラー防止）
  if vim.fn.executable("fcitx5-remote") == 1 then
    vim.fn.jobstart("fcitx5-remote -c")
  elseif vim.fn.executable("fcitx-remote") == 1 then
    -- 旧バージョンのFcitxの場合
    vim.fn.jobstart("fcitx-remote -c")
  end
end
-- 以下のタイミングで実行
vim.api.nvim_create_autocmd({
  "VimEnter", -- Neovim起動時
  "InsertEnter", -- 挿入モード開始時（常に英語から打ちたい場合）
  "FocusGained", -- ブラウザからNeovimに戻ってきた時
}, {
  callback = fcitx_off,
})
-- 空のテーブルを定義
local M = {}

function M.open()
  -- Markdownファイルでない場合は警告
  if vim.bo.filetype ~= "markdown" then
    -- 警告レベルでlogを出力
    vim.notify("Current buffer is not Markdown", vim.log.levels.WARN)
    return
  end

  -- 絶対パスを取得
  local path = vim.fn.expand("%:p")

  -- 空ファイルを開いたらエラー
  if path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.ERROR)
    return
  end
  -- URIを展開
  local uri = "obsidian://open?path=" .. vim.uri_encode(path)

  -- command を直接(「シェル」内ではなく直接実行
  vim.system({
    "xdg-open",
    uri,
  })
end

-- user_commandに登録
vim.api.nvim_create_user_command("MarkdownObsidian", function()
  M.open()
end, {})

-- Mを返す
return M
