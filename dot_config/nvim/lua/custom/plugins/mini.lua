return { -- Collection of various small independent plugins/modules
  {
    'echasnovski/mini.nvim',
    version = false, -- 'false' (文字列) ではなく false (ブール値)
    config = function()
      -- MiniSessionsの設定
      local session = require 'mini.sessions'
      session.setup()

      local function is_blank(arg)
        return arg == nil or arg == ''
      end
      local function get_sessions(lead)
        local dir = session.config.dir
        if not dir then
          return {}
        end
        return vim
          .iter(vim.fs.dir(session.config.dir))
          :map(function(v)
            local name = vim.fs.basename(v)
            return vim.startswith(name, lead) and name or nil
          end)
          :totable()
      end
      vim.api.nvim_create_user_command('SessionWrite', function(arg)
        local session_name = is_blank(arg.args) and vim.v.this_session or arg.args
        if is_blank(session_name) then
          vim.notify('Session name is required', vim.log.levels.WARN)
          return
        end
        vim.cmd '%argdelete'
        session.write(session_name)
      end, { desc = 'Write session', nargs = '?', complete = get_sessions })

      vim.api.nvim_create_user_command('SessionRead', function()
        session.select('read', { verbose = true })
      end, { desc = 'Load session' })

      vim.api.nvim_create_user_command('SessionEscape', function()
        vim.v.this_session = ''
      end, { desc = 'Escape session' })
      vim.api.nvim_create_user_command('SessionReveal', function()
        if is_blank(vim.v.this_session) then
          vim.print 'No session'
          return
        end
        vim.print(vim.fs.basename(vim.v.this_session))
      end, { desc = 'Reveal current session' })
      -- 1. mini.starter の設定
      local starter = require 'mini.starter'
      starter.setup {
        header = [[
      ███╗   ██╗██╗   ██╗███████╗██╗██████╗ ███████╗
      ████╗  ██║██║   ██║██╔════╝██║██╔══██╗██╔════╝
      ██╔██╗ ██║██║   ██║█████╗  ██║██████╔╝█████╗  
      ██║╚██╗██║╚██╗ ██╔╝██╔══╝  ██║██╔══██╗██╔══╝  
      ██║ ╚████║ ╚████╔╝ ██║     ██║██║  ██║███████╗
      ╚═╝  ╚═══╝  ╚═══╝  ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝
        ]],
        items = {
          starter.sections.recent_files(5, false),
          starter.sections.sessions(5, true),
          starter.sections.builtin_actions(),
        },
        content_hooks = {
          function(content)
            for _, unit in ipairs(content) do
              if unit.section == 'header' then
                unit.hl = 'Title'
              end
            end
            return content
          end,
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning('center', 'center'),
        },
      }
      local misc = require 'mini.misc'
      misc.setup()

      misc.setup_restore_cursor()
      vim.api.nvim_create_user_command('Zoom', function()
        misc.zoom(0, {})
      end, { desc = 'Zoom current buffer' })
      vim.keymap.set('n', 'mz', '<cmd>Zoom<cr>', { desc = '[Z]oom current buffer' })

      -- 2. その他の mini モジュールの設定
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.pairs').setup()
      require('mini.indentscope').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  { -- Icon provider
    'echasnovski/mini.icons',
    opts = {},
    lazy = true,
    specs = {
      { 'nvim-tree/nvim-web-devicons', enabled = false, optional = true },
    },
    init = function()
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },
}
