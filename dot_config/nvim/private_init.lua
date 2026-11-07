vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('core.options')
require('core.autocmds')
require('core.user_command')
require('keymaps.core')
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.bool_fn = setmetatable({}, {
  __index = function(_, key)
    return function(...)
      local v = vim.fn[key](...)
      if not v or v == 0 or v == '' then
        return false
      elseif type(v) == 'table' and next(v) == nil then
        return false
      end
      return true
    end
  end,
})
local ok, coreui2 = pcall(require, 'vim._core.ui2')
if ok then
  coreui2.enable({
    enable = true, -- core.ui2を有効化
    msg = {
      pos = 'box', -- 'box'か'cmd'だがcmdheight=0だとどっちでも良い？（記事後述）
      box = {
        timeout = 5000, -- boxメッセージの表示時間 ミリ秒
      },
    },
  })
end
-- mermaid を有効化（デフォルトで true のことが多いが念のため）
vim.g.mkdp_preview_options = {
  mmarkdown = 1,
  description_container = 1,
  mermaid = 1, -- これ！
}
-- example:
-- if vim.bool_fn.has('mac') then ... end

-- Rustup が Nix ツールチェーンを「カスタム」として誤認するのを防ぐ
vim.env.RUSTUP_TOOLCHAIN = nil
vim.env.RUSTUP_AUTO_INSTALL = '0'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out =
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  { import = 'lsp' },
  { import = 'completion' },
  { import = 'utilites' },
  { import = 'ai' },
  { import = 'languages' },
}, {
  performance = {
    reset_packpath = false,
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.g.t0 = vim.uv.hrtime()
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(a)
    local c = vim.lsp.get_client_by_id(a.data.client_id)
    if c and c.name == 'lua_ls' then
      print(('[lua_ls] %.0f ms'):format((vim.uv.hrtime() - vim.g.t0) / 1e6))
    end
  end,
})
