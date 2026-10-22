return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  dependencies = {
    {
      'delphinus/md-render.nvim',
      version = '*',
      dependencies = {
        { 'nvim-tree/nvim-web-devicons', version = '*' }, --optional
        { 'delphinus/budoux.lua', version = '*' }, -- optional: CJKフレーズ分割
      },
    },
  },
  opts = function()
    return {
      picker = { enabled = true, preview = require('md-render.snacks').preview() },
      image = { enabled = true }, -- picker内画像プレビューはこれ。image.nvim不要
      explorer = { enabled = true },
    }
  end,

  keys = {
    {
      '<leader>sfg',
      function()
        Snacks.picker.git_files()
      end,
      desc = 'search .gitignore参照files',
    },
    {
      '<leader>sfng',
      function()
        Snacks.picker.files({ hidden = true, ignored = true })
      end,
      desc = 'search .gitignore無視files',
    },
    {
      '<leader>sg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'search rg grep_live',
    },
    -- mini helpの shv/shh/sht(縦/横/tab分割指定)はsnacksに該当なし。一本化
    {
      '<leader>shv',
      function()
        Snacks.picker.help()
      end,
      desc = 'search help',
    },
    {
      '<leader>srs',
      function()
        Snacks.picker.resume()
      end,
      desc = 'search resume',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.lines()
      end,
      desc = 'search buf_lines',
    },
    {
      '<leader>scs',
      function()
        Snacks.picker.colorschemes()
      end,
      desc = 'search colorschemes',
    },
    {
      '<leader>scc',
      function()
        Snacks.picker.commands()
      end,
      desc = 'search commands',
    },
    {
      '<leader>sdg',
      function()
        Snacks.picker.diagnostics()
      end,
      desc = 'search diagnostic',
    },
    {
      '<leader>ses',
      function()
        Snacks.explorer()
      end,
      desc = 'search explorer',
    },
    {
      '<leader>scg',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'search git_commits',
    },
    {
      '<leader>shs',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'search history',
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'search keymaps',
    },
    {
      '<leader>sn',
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath('config') })
      end,
      desc = 'search neovim config dir',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.buffers()
      end,
      desc = 'search buffers',
    },
    {
      '<leader>sv',
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = 'search visit_paths代替',
    },
    {
      '<leader>sgs',
      function()
        Snacks.picker.git_stash()
      end,
      desc = 'search git stash',
    },
    {
      '<leader>srg',
      function()
        Snacks.picker.registers()
      end,
      desc = 'search registers',
    },
  },
}
