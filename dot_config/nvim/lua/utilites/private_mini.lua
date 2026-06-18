return { -- Collection of various small independent plugins/modules
  {
    "nvim-mini/mini.nvim",
    version = false, -- 'false' (文字列) ではなく false (ブール値)
    config = function()
      -- MiniSessionsの設定
      local session = require("mini.sessions")
      session.setup()
      local function is_blank(arg)
        return arg == nil or arg == ""
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
      vim.api.nvim_create_user_command("SessionWrite", function(arg)
        local session_name = is_blank(arg.args) and vim.v.this_session or arg.args
        if is_blank(session_name) then
          vim.notify("Session name is required", vim.log.levels.WARN)
          return
        end
        vim.cmd("%argdelete")
        session.write(session_name)
      end, { desc = "Write session", nargs = "?", complete = get_sessions })
      vim.api.nvim_create_user_command("SessionRead", function()
        session.select("read", { verbose = true })
      end, { desc = "Load session" })
      vim.api.nvim_create_user_command("SessionEscape", function()
        vim.v.this_session = ""
      end, { desc = "Escape session" })
      vim.api.nvim_create_user_command("SessionReveal", function()
        if is_blank(vim.v.this_session) then
          vim.print("No session")
          return
        end
        vim.print(vim.fs.basename(vim.v.this_session))
      end, { desc = "Reveal current session" })
      -- 1. mini.starter の設定
      local starter = require("mini.starter")
      starter.setup({
        header = [[
███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄
███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄
███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███
███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███
███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███
 ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀

        ]],

        items = {
          starter.sections.recent_files(5, false),
          starter.sections.sessions(5, true),
          starter.sections.builtin_actions(),
        },
        content_hooks = {
          function(content)
            for _, unit in ipairs(content) do
              if unit.section == "header" then
                unit.hl = "Title"
              end
            end
            return content
          end,
          starter.gen_hook.adding_bullet(),
          starter.gen_hook.aligning("center", "center"),
        },
      })
      local misc = require("mini.misc")
      misc.setup()
      misc.setup_restore_cursor()
      vim.api.nvim_create_user_command("Zoom", function()
        misc.zoom(0, {})
      end, { desc = "Zoom current buffer" })
      vim.keymap.set("n", "mz", "<cmd>Zoom<cr>", { desc = "[Z]oom current buffer" })
      -- 2. その他の mini モジュールの設定
      require("mini.ai").setup({ n_lines = 500 })
      require("mini.surround").setup()
      require("mini.pairs").setup()
      require("mini.indentscope").setup()
      require("mini.trailspace").setup()
      require("mini.jump2d").setup()
      require("mini.cursorword").setup()
      vim.api.nvim_create_user_command("Trim", function()
        MiniTrailspace.trim()
        MiniTrailspace.trim_last_lines()
      end, { desc = "Trim trailing space and last blank lines" })
      local gen_ai_spec = require("mini.extra").gen_ai_spec
      require("mini.ai").setup({
        custom_textobjects = {
          B = gen_ai_spec.buffer(),
          D = gen_ai_spec.diagnostic(),
          I = gen_ai_spec.indent(),
          L = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
          J = { { "()%d%d%d%d%-%d%d%-%d%d()", "()%d%d%d%d%/%d%d%/%d%d()" } },
        },
      })

      require("mini.diff").setup({
        view = { style = "sign", signs = { add = "│", change = "│", delete = "-" } },
        -- デフォルトの sign スタイルで十分な場合が多い
      })
      require("mini.tabline").setup({
        tabline_use_icons = vim.g.have_nerd_font, -- Nerd Font があればアイコン表示
        -- format = nil, -- デフォルトでファイル名 + アイコン + 変更マーク
      })
      require("mini.notify").setup()

      vim.notify = require("mini.notify").make_notify({})

      vim.api.nvim_create_user_command("NotifyHistory", function()
        MiniNotify.show_history()
      end, { desc = "Show notify history" })
      require("mini.statusline").setup({ set_vim_settings = false })
      -- mini.files の設定と <leader>e キー割り当て
      require("mini.files").setup({
        -- 必要に応じてカスタマイズ（デフォルトでほぼ問題なし）
        windows = {
          preview = true,
          width_preview = 40,
        },
      })

      -- <leader>e でトグル起動（現在のファイルのディレクトリから開く）
      vim.keymap.set("n", "<leader>e", function()
        if not MiniFiles.close() then
          -- 現在のバッファがファイルならその親ディレクトリ、でなければ cwd
          local bufname = vim.api.nvim_buf_get_name(0)
          local path = vim.fn.filereadable(bufname) == 1 and vim.fn.fnamemodify(bufname, ":h")
            or vim.fn.getcwd()
          MiniFiles.open(path, true)
        end
      end, { desc = "Toggle mini.files (current dir)" })
      local hipatterns = require("mini.hipatterns")
      local hi_words = require("mini.extra").gen_highlighter.words
      hipatterns.setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = hi_words({ "FIXME", "Fixme", "fixme" }, "MiniHipatternsFixme"),
          hack = hi_words({ "HACK", "Hack", "hack" }, "MiniHipatternsHack"),
          todo = hi_words({ "TODO", "Todo", "todo" }, "MiniHipatternsTodo"),
          note = hi_words({ "NOTE", "Note", "note" }, "MiniHipatternsNote"),
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
      require("mini.operators").setup({
        replace = { prefix = "R" },
        exchange = { prefix = "/" },
      })
      require("mini.pick").setup()
      require("mini.extra").setup()

      vim.ui.select = MiniPick.ui_select

      vim.keymap.set("n", "<space>sfg", function()
        MiniPick.builtin.files({ tool = "git" })
      end, { desc = ".gitignoreを参照してのmini.pick.files" })

      vim.keymap.set("n", "<space>sfng", function()
        MiniPick.builtin.files({ tool = "rg" })
      end, { desc = ".gitignoreを参照しない上でのmini.pick.files" })
      vim.keymap.set("n", "<space>sg", function()
        MiniPick.builtin.grep_live({ tool = "rg" })
      end, { desc = "rgでのmini.pick.grep_live" })
      vim.keymap.set("n", "<space>shv", function()
        MiniPick.builtin.help({ default_split = "vertical" })
      end, { desc = "縦分割でmini.pick.help" })

      vim.keymap.set("n", "<space>shh", function()
        MiniPick.builtin.help()
      end, { desc = "横分割でmini.pick.help" })

      vim.keymap.set("n", "<space>sht", function()
        MiniPick.builtin.help({ default_split = "tab" })
      end, { desc = "tab分割でmini.pick.help" })

      vim.keymap.set("n", "<space>sr", function()
        MiniPick.builtin.resume()
      end, { desc = "mini.pick.resume" })

      vim.keymap.set("n", "<space>/", function()
        MiniExtra.pickers.buf_lines()
      end, { desc = "MiniExtra.pickers.buf_lines" })
      vim.keymap.set("n", "<space>scs", function()
        MiniExtra.pickers.colorschemes()
      end, { desc = "MiniExtra.pickers.colorschemes" })
      vim.keymap.set("n", "<space>scc", function()
        MiniExtra.pickers.commands()
      end, { desc = "MiniExtra.pickers.commands" })
      vim.keymap.set("n", "<space>sdg", function()
        MiniExtra.pickers.diagnostic()
      end, { desc = "MiniExtra.pickers.diagnostic" })
      vim.keymap.set("n", "<space>se", function()
        MiniExtra.pickers.explorer()
      end, { desc = "MiniExtra.pickers.explorer" })
      vim.keymap.set("n", "<space>scg", function()
        MiniExtra.pickers.git_commits()
      end, { desc = "MiniExtra.pickers.git_commits" })
      vim.keymap.set("n", "<space>shs", function()
        MiniExtra.pickers.history()
      end, { desc = "MiniExtra.pickers.history" })
      vim.keymap.set("n", "<space>sk", function()
        MiniExtra.pickers.keymaps()
      end, { desc = "MiniExtra.pickers.keymap" })

      vim.keymap.set("n", "<space>sn", function()
        MiniPick.builtin.files({ tool = "rg" }, {
          source = {
            cwd = vim.fn.stdpath("config"),
            name = "neovim config dir",
          },
        })
      end, { desc = "neovimの設定ファイルのディレクトリを開く" })
      vim.keymap.set("n", "<space>sb", function()
        local wipeout_cur = function()
          vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
        end
        local buffer_mappings = { wipeout = { char = "<c-d>", func = wipeout_cur } }
        MiniPick.builtin.buffers({ include_current = false }, { mappings = buffer_mappings })
      end, { desc = "mini.pick.buffers" })

      require("mini.visits").setup()
      vim.keymap.set("n", "<space>h", function()
        require("mini.extra").pickers.visit_paths()
      end, { desc = "mini.extra.visit_paths" })

      vim.keymap.set("c", "h", function()
        if vim.fn.getcmdtype() .. vim.fn.getcmdline() == ":h" then
          return "<c-u>Pick help<cr>"
        end
        return "h"
      end, { expr = true, desc = "mini.pick.help" })

      vim.keymap.set("n", "RR", "R", { desc = "Replace mode" })
    end,
  },
  { -- Icon provider
    "nvim-mini/mini.icons",
    opts = {},
    lazy = true,
    specs = {
      { "nvim-tree/nvim-web-devicons", enabled = false, optional = true },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
