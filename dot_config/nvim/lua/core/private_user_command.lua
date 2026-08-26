-- Open init.lua(kickstart) by :Initlua
vim.api.nvim_create_user_command('InitLua', function()
  vim.cmd.edit('~/.config/nvim/init.lua')
end, { desc = 'Open init.lua' })

vim.api.nvim_create_user_command('SayHello', 'echo "Hello!"', { desc = 'say hello' })

vim.api.nvim_create_user_command('Greet', function(args)
  print('Hello, ' .. args.args)
end, { nargs = 1, desc = 'greet command' })
vim.api.nvim_create_user_command('Scratch', function()
  vim.cmd('enew')
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'hide'
  vim.bo.swapfile = false
end, { desc = 'Open scratch buffer' })
-- モジュールとして公開する関数や値を入れるためのテーブルを作っている
local M = {}

function M.open()
  -- 現在のバッファの filetype が markdown ではない
  if vim.bo.filetype ~= 'markdown' then
    -- 警告レベルでユーザーに通知を表示
    vim.notify('Current buffer is not Markdown', vim.log.levels.WARN)
    return
  end

  -- 絶対パスを取得
  local path = vim.fn.expand('%:p')

  -- 現在のバッファにファイルパスが存在しない場合はエラー
  if path == '' then
    vim.notify('Current buffer has no file path', vim.log.levels.ERROR)
    return
  end
  -- ファイルパスをURIとして安全に使える形にエンコード
  local uri = 'obsidian://open?path=' .. vim.uri_encode(path)

  -- シェルを介さず外部コマンドを実行している
  vim.system({
    'xdg-open',
    uri,
  })
end

-- Neovimのユーザー定義Exコマンドを作成している
vim.api.nvim_create_user_command('MarkdownObsidian', function()
  M.open()
end, { desc = 'Obsidian desktop でmarkdownをプレビュー' })

-- モジュールを返す
return M
