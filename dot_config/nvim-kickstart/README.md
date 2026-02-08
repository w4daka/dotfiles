# kickstart.nvimの自分用レファレンス

## 概要

nvim-kickstartのコードを読む。機能のレファレンスを作るのが目標。

## kickstartとは何か？(Geminiの和訳)

  Kickstart.nvimは「配布版（ディストリビューション）」ではありません。

  Kickstart.nvimは、あなた自身の設定を作るための出発点です。 その目的は、コードを上から下まで一行ずつ読み、自分の設定が何をしているのかを理解し、ニーズに合わせて修正できるようにすることにあります。一度それができれば、自分専用のNeovimにするために、自由に探索・設定・いじくり回すことができます！ しばらくはKickstartをそのまま使い続けるのも、すぐにモジュールごとに分割して整理し直すのも、すべてはあなた次第です。

  Luaについて全く知らない場合は、ガイドを読むために少し時間を割くことをお勧めします。例えば、10〜15分程度で読める[こちらのガイド](https://learnxinyminutes.com/docs/lua/)があります

  Luaを少し理解した後は、NeovimがどのようにLuaを統合しているかのリファレンスとして :help lua-guide を活用してください。

  :help lua-guide [HTML版](https://neovim.io/doc/user/lua-guide.html)

  Kickstart ガイド

  TODO: まず最初にすべきことは、Neovimで :Tutor コマンドを実行することです。
  
  それが完了したら、この init.lua（Kickstartの設定ファイル）の残りの部分を読み進めながら作業を続けてください。

  次に、:help を実行して、その内容を読んでください。 これにより、組み込みのヘルプドキュメントの読み方、移動方法、検索方法に関する基本情報が含まれたヘルプウィンドウが開きます。

  何かに行き詰まったり混乱したりしたときは、まずここを確認するようにしてください。これはNeovimの素晴らしい機能の一つです。

  特に重要な点として、Kickstartでは `<Space>sh` というキーマップを用意しています。これはヘルプドキュメントを「search（検索）」するためのもので、何を探せばいいか正確にわからない時に非常に便利です。

  この init.lua の至る所に :help X というコメントを残しています。 これらは、Kickstartで使用されている関連設定、プラグイン、またはNeovimの機能について、より詳細な情報がどこにあるかを示すヒントです。

## 感想

luaガイドを読まずに進めてみる。

## 設定

`<space>`をリーダーキーに設定。詳しくは`:help mapleadar`を見るべし。とりあえずよさそう。

```lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
```

nerdフォントを有効化

```lua
vim.g.have_nerd_font = true
```

相対行と絶対行をどちらも表示。

```lua
-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true
```

ノーマルモード、ビジュアルモード、挿入モード、コマンドラインモードの全てでマウスを有効にする。

```lua
-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'
```

現在どのモードにいるかを表示しない。ステータスラインのプラグインがあるので不要

```lua
-- Don't show the mode, since it's already in the status line
vim.o.showmode = false
```

折り返しの行の開始位置をもとの行のインデントに合わせる。単語の途中で行を折り返さない。

```lua
-- Enable break indent
-- Avoid braaking lines in the middle of a word
vim.o.breakindent = true
vim.opt.linebreak = true
```

neovimを閉じた後でもundoを可能にする。

```lua
-- Save undo history
vim.o.undofile = true
```

検索時に大文字と小文字を区別しないようにする。

```lua
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
```

LSPの診断結果などを表示できるようにする。

```lua
-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'
```

画面更新を行う時間を250秒にする

```lua
-- Decrease update time
vim.o.updatetime = 250
```

複数のキーを組み合わせて使う操作（マッピング）を入力するときの待ち時間を短くする。

```lua
-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300
```

新しい画面を開くときに「右」と「下」に開く。

```lua
-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
```

タブ文字を`>>`とその後の空白で表す。行末の不必要な空白を`·`で表す。改行を許可しない特殊な空白（Non-breaking space）を `␣`で表す。

```lua
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = {tab = '» ', trail = '·', nbsp = '␣' }
```

置換時に

**リアルタイム・ハイライト**: 書き換える対象の文字（old）が、入力した瞬間に画面上でハイライトされる。

**ライブ・プレビュー**: 置換後の文字（new）を入力し始めると、確定前であっても、画面上の文字が一時的に新しい文字に書き換わって表示される。

**プレビューウィンドウ（'split' の効果）**: ここが 'split' 設定の最大の特徴です。置換対象が現在の画面外にある場合、自動的に画面が分割（スプリット)され、その場所を別ウィンドウで映し出してプレビューしてくれる。

```lua
-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'
```

現在カーソルがある行をハイライトする。

```lua
-- Show which line your cursor is on
vim.o.cursorline = true
```

カーソルが画面の端（一番上や一番下）に張り付かないように、常に一定の余白を保つようにする

```lua
-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
```

保存していないファイルがあるときに`E37: No write since last change (add ! to override)`のようなエラーを出さないようにし、`Save changes to "ファイル名"? [Y]es, (N)o, (C)ancel:`のような選択肢を表示させる。

```lua
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true
```

検索が終わったら`<Esc>`でハイライトを消す。

```lua
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
```

`<leader>q`画面下部に、現在のファイル内のエラー箇所を表示する。

```lua
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
```

Neovimのターミナルを使っているときに、`<Esc><Esc>`で抜ける。

```lua
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
```

テキストをヤンク（コピー）した瞬間に、その範囲を一瞬だけピカッと光らせる。

```lua
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
```

ファイルを保存しようとした際に、保存先のディレクトリがなくても自動で作成するようにする。[参考](https://zenn.dev/kawarimidoll/books/6064bf6f193b51/viewer/4e7d10)

```lua
-- augroup for this config file
local augroup = vim.api.nvim_create_augroup('init.lua', {})

-- wrapper function to use internal augroup
local function create_autocmd(event, opts)
  vim.api.nvim_create_autocmd(
    event,
    vim.tbl_extend('force', {
      group = augroup,
    }, opts)
  )
end
-- https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(event)
    local dir = vim.fs.dirname(event.file)
    local force = vim.v.cmdbang == 1
    if not vim.bool_fn.isdirectory(dir) and (force or vim.fn.confirm('"' .. dir .. '"dose not exist. Create?', '&Yes\n&No') == 1) then
      vim.fn.mkdir(vim.fn.iconv(dir, vim.opt.encoding:get(), vim.opt.termencoding:get()), 'p')
    end
  end,
  desc = 'Auto mkdir to save file',
})
```

`:InitLua`で設定ファイルを開く。

```lua
-- Open init.lua(kickstart) by :Initlua
vim.api.nvim_create_user_command(
  'InitLua',
  function()
    vim.cmd.edit( '~/.config/nvim-kickstart/init.lua')
  end,
  { desc = 'Open init.lua(kickstart)' }
)
```

Lazy.nvimのインストール先の決定

```lua
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
```

指定した場所に lazy.nvim が存在するかチェックし,なければ git clone コマンドを実行して、GitHubから最新の安定版（stable）をダウンロードします。これにより、手動でインストールする手間が省ける。

```lua
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
```

neovimへのlazy.nvim登録

```lua
---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)
```

Lazy.nvimの操作方法。

今のプラグインの状態確認は`:Lazy`、その後、helpは`?`、そのwindowを閉じるには、`:q`.

Gitで管理しているプロジェクトにおいて、行番号のすぐ左に

`+`:新しく追加された行。

`~`内容が変更された行

`_`行が削除された行

`‾`ファイルの先頭で行が削除された場合。

`~`既存の行が変更され、かつその一部が削除された場合。

という形で表示する。

```lua
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
```

`which-key-nvim`は`<leader>`などを押した後に、「次に何のキーを押せばいいか」教えてくれる。

`<leader>s`: 検索関連（Search）

`<leader>t`: 切り替え関連（Toggle）

`<leader>h`: Gitの変更箇所関連（Git Hunk）※ノーマルモードとビジュアルモード両方

```lua

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.o.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
```

`nvim-telescope`が動くために必要な依存関係をインストールする。

`plenary.nvim`: Telescopeが動くために必須のライブラリ

`fzf-native.nvim`: 検索をさらに高速化する。

`ui-select.nvim`: Neovim標準の選択メニュー（コードアクションなど）を、Telescopeのかっこいい見た目に置き換える。

```lua
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
            require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },

```

`<leader>sf`:ファイル検索

`<leader>sg`:ファイルの中身を文字列を検索

`<leader><leader>`:今開いているバッファの一覧を表示

`<leader>/`: 今開いているファイルの中だけで、あいまい検索をする（ドロップダウン形式で表示）。

`<leader>sn`([S]earch [N]eovim): Neovimの設定ファイルが置かれているフォルダ（init.lua など）を直接検索

```lua
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
```

mini.fileとmini.tablineの追加

```lua
  { -- 2. mini.files の追加
    'echasnovski/mini.files',
    version = '*',
    config = function()
      require('mini.files').setup()

      -- 使いやすいようにキーマップを設定 (例: <leader>f)
      vim.keymap.set('n', '<leader>e', function()
        if not require('mini.files').close() then
          require('mini.files').open(vim.api.nvim_buf_get_name(0), true)
        end
      end, { desc = 'Open mini.files (Directory of current file)' })
    end,
  },
  { -- 3. mini.tabline の追加
    'echasnovski/mini.tabline',
    version = '*',
    opts = {}, -- デフォルト設定で動作
  },

```

neovimの設定（lua）を書いているときに、賢い補完と型情報を出してくれる。

```lua
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
```

`nvim-lspconfig`neovimが各種言語サーバーと会話するための標準設定集

`mason.nvim`LSPサーバー、リンター、フォーマッタなどを、Neovimの中から簡単にインストール・管理できる管理画面を提供

`mason-lspconfig`Masonで入れたLSPと、lspconfigをつなぐ

`fidget.nvim`LSPが重い処理（プロジェクトの読み込みなど）をしている時、右下にこっそり進捗状況を表示してくれる

`blink.cmp`補完機能を爆速にし、LSPが持つ高度な能力を最大限引き出せるようにする

```lua
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
```

`grn` (Rename): 変数名を一括変更します。参照先もすべて自動で書き換わる。

`gra` (Code Action): エラーの自動修正案を表示する。

`grd` (Definition): 定義場所へジャンプする。戻る時は `<C-t>` 。

`grr` (References): その変数が使われている場所を一覧表示する。

`ドキュメント・ハイライト`: カーソルを単語の上で止めると、同じ変数が使われている場所をハイライトし、カーソルを動かすと消えるように設定されています。

エラーの警告

`severity_sort = true`: 重大なエラーを優先的に表示します。

`float = { border = 'rounded' }`: エラー詳細を表示する浮遊ウィンドウの角を丸くして見やすくします。

`virtual_text`: 行の右側にエラーメッセージを薄く表示します。

自動で読み込むLSPの設定→`clangd`,`gopls`,`pyright`,`rust_analyzar`,`lua_ls`が有効

```lua
    config = function()
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      --
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client any
          ---@param method any
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client:supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        clangd = {
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
        },
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                parameterNames = true,
              },
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'basic', -- 'strict'（厳格）にも変更可能
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        rust_analyzer = {
          settings = {
            ['rust-analyzer'] = {
              checkOnSave = {
                command = 'clippy', -- 保存時に強力な診断ツールClippyを実行
              },
              completion = {
                callable = { snippets = 'fill_arguments' },
              },
            },
          },
        },
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }
```

先ほどの設定で決めておいたLSPサーバーをインストールする

```lua
local ensure_installed = vim.tbl_keys(servers or {})
```

lsp以外で必要なツール（フォーマッタなど）をリストに追加する

```lua
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'black',
        'goimports',
      })
```

作成したリストを`mason-tool-installer`に渡し、これらをすべてインストールする。LSPサーバーを起動する。

```lua
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
            require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
```

ファイルを保存したときに自動的にコードを整形する（`conform.nvim`）

`<leader>f`で手動整形

pythonとjsの整形ツールも追加した。

```lua
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
```

`blink.cmp`最先端の補完プラグイン

`sources`: どこから候補を持ってくるかを決めています。

- `lsp`: プログラミング言語の知識（変数名、関数名など）。

- `path`: ファイルのパス。

- `snippets`: 定型文（スニペット）。

- `lazydev`: Neovimの設定ファイル（Lua）を書く際の特別な補完。

`signature`: 関数の引数を入力しているときに、どんな引数が必要か小さなウィンドウで教えてくれます。

世界中の人が作った定型文を使えるようにする。`friendly-snippets`

操作方法

- `<C-n>` / `<C-p>`: 候補の次 / 前を選択。

- `<C-y>`: 決定（選択した候補を確定させる）。

- `<C-space>`: 手動で補完メニューを開く。

- `<Tab>` / `<S-Tab>`: スニペットの入力箇所を次 / 前へ移動

```lua
  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.          --    See the README about individual language/framework/plugin snippets:https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        --
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        preset = 'default',

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },

      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
```

themeを`tokyonight-storm`にした。

カラースキームの設定（`tokyonight.nvim`）

```lua
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        transparent = true,
        styles = {
          comments = { italic = false }, -- Disable italics in comments
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-storm'
    end,
  },
```

`TODO:`や`HACK:`といった特定の単語を自動で検知して、色をつけて目立たせる

`opts = { signs = false }`: この設定では、画面の左端（行番号の横のサインカラム）にアイコンを表示しないように設定

`<leader>st`で`TODO`のコメントを一括表示する

```lua
  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
```

`mini.ai`

- `va)`  - [V]isually select [A]round [}}paren

- `yinq` - [Y]ank [I]nside [N]ext [Q]uote
- `ci'`  - [C]hange [I]nside [']quote

- `yi"` - ""の内側をヤンク

`mini.surround`

- `saiw)` - [S]urround [A]dd [I]nner [W]ord [)]Paren

- `sd'`   - [S]urround [D]elete [']quotes
  
- `sr)'`  - [S]urround [R]eplace [)] [']

`mini.statusline`- ステータスバーを高機能にする

`mini.starter` -ダッシュボードを表示する。

`minisession`-セッションを保存する。[参考](https://zenn.dev/kawarimidoll/books/6064bf6f193b51/viewer/86e45d)


```lua
return { -- Collection of various small independent plugins/modules
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
  end, -- ここで config 関数を閉じる
}
```

`nvim-treesitter`

新しい言語を入れたときに自動でパーサーをインストールする。および、インデントの自動化あり。

```lua
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
```

`denops.vim`-denoで書かれたプラグインを導入する

```lua
  {
    -- add denops

    'vim-denops/denops.vim',
    lazy = false,
    priority = 1000,
  },

```

`skkeleton.vim`-ddu.vimと連携してskk日本語入力を可能にする。参考のzennからコピペしてきた。azikについて調べる必要あり。

```lua
return {
  -- 参考 https://zenn.dev/kkc/articles/tk-nvim-skkeleton-setting2
  { 'vim-denops/denops.vim', lazy = false },
  { 'Shougo/ddc.vim' },
  { 'Shougo/pum.vim' },
  { 'Shougo/ddc-ui-pum' },

  {
    'delphinus/skkeleton_indicator.nvim',
    config = function()
      require('skkeleton_indicator').setup {}
    end,
  },

  {
    'vim-skk/skkeleton',
    dependencies = {
      'vim-denops/denops.vim',
      'Shougo/ddc.vim',
      't4k44/skkeleton-azik-kanatable', -- 個人設定分をk16em氏のkanatableからfork
    },
    config = function()
      vim.fn['skkeleton#azik#add_table'] 'us'
      vim.fn['skkeleton#register_kanatable']('azik', {
        q = 'katakana',
      })

      vim.fn['skkeleton#config'] {
        kanaTable = 'azik',
        globalDictionaries = {
          '~/.skk/SKK-JISYO.L',
        },
        userDictionary = '~/.skk/skk-user.dict',
        completionRankFile = '~/.skk/rank.json',
        eggLikeNewline = true,
        keepState = true,
        showCandidatesCount = 2,
        registerConvertResult = true,
      }

      vim.cmd [[ call ddc#custom#patch_global('sources', ['skkeleton']) ]]
      vim.cmd [[ call ddc#custom#patch_global('sourceOptions', {
        \ '_': {
        \   'matchers': ['matcher_head'],
        \   'sorters': ['sorter_rank'],
        \ },
        \ 'skkeleton': {
        \   'mark': 'skkeleton',
        \   'matchers': [],
        \   'sorters': [],
        \   'converters': [],
        \   'isVolatile': v:true,
        \   'minAutoCompleteLength': 1,
        \ }
        \})
      ]]
      vim.cmd [[ call ddc#enable() ]]
      vim.cmd [[ call ddc#custom#patch_global('ui', 'pum') ]]

      vim.keymap.set({ 'i', 'c', 't' }, '<C-j>', '<Plug>(skkeleton-toggle)', { noremap = false })
      vim.keymap.set({ 'i', 'c' }, '<C-n>', '<cmd>call pum#map#insert_relative(+1)<CR>')
      vim.keymap.set({ 'i', 'c' }, '<C-p>', '<cmd>call pum#map#insert_relative(-1)<CR>')
      vim.keymap.set({ 'i', 'c' }, '<C-y>', '<cmd>call pum#map#confirm()<CR>')
      vim.keymap.set({ 'i', 'c' }, '<C-e>', '<cmd>call pum#map#cancel()<CR>')
      vim.keymap.set({ 'i', 'c' }, '<PageDown>', '<cmd>call pum#map#insert_relative_page(+1)<CR>')
      vim.keymap.set({ 'i', 'c' }, '<PageUp>', '<cmd>call pum#map#insert_relative_page(-1)<CR>')
    end,
  },
}
```

`copilot.lua` github copilotと連携して補完を起こなう。blink.cmpと連携済み。

```lua
return {
  -- 1. Copilot 本体の設定
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      -- blink.cmp で表示するため、本体の UI 類は無効化する
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  -- 2. Blink と Copilot を繋ぐソース
  {
    'saghen/blink.cmp',
    dependencies = {
      'giuxtaposition/blink-cmp-copilot',
    },
    opts = {
      sources = {
        -- 'copilot' をソースリストに追加
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100, -- 補完順位を上げたい場合は調整
            async = true,
          },
        },
      },
      -- アイコン表示を綺麗にしたい場合（任意）
      appearance = {
        kind_icons = {
          Copilot = '',
        },
      },
    },
  },
}
```

`markview.nvim`-`:Markview`でmarkdownプレビュ－を可能にする。

```lua
return {
  'OXY2DEV/markview.nvim',
  lazy = false,

  -- Completion for `blink.cmp`
  dependencies = { 'saghen/blink.cmp' },
}
```

`neoterm.nvim`:`<lerder>tg`でタ－ミナルを開く `<leadeR>tc`タ－ミナルを閉じる

```lua
return {
  'OXY2DEV/markview.nvim',
  lazy = false,

  -- Completion for `blink.cmp`
  dependencies = { 'saghen/blink.cmp' },
}
```

`vimdoc-ja`vimのhelpを日本語で開く

```lua
return {
  {
    'vim-jp/vimdoc-ja',

    lazy = true,
    event = 'VeryLazy',
    config = function()
      vim.opt.helplang:prepend 'ja'
    end,
  },
}
```


`lazygit.nvim`lazygitをneovim内か開けるようにする。

```lua

-- nvim v0.8.0
return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
  },
}
```

`dial.nvim`整数と16進数と日付を`<c-a>` `<c-x>`で変えられる。true,falseはできない.追記できるようになった。

```lua
return {
  'monaqa/dial.nvim',
  keys = {
    {
      '<C-a>',
      function()
        return require('dial.map').inc_normal()
      end,
      expr = true,
      desc = 'Increment',
    },
    {
      '<C-x>',
      function()
        return require('dial.map').dec_normal()
      end,
      expr = true,
      desc = 'Decrement',
    },
  },
  config = function()
    local augend = require 'dial.augend'
    require('dial.config').augends:setup {
      default = {
        augend.integer.alias.decimal, -- 普通の整数
        augend.integer.alias.hex, -- 16進数
        augend.date.alias['%Y/%m/%d'], -- 日付
        augend.constant.alias.bool, -- true/false
        augend.constant.new {
          elements = { 'and', 'or' },
          word = true,
          cyclic = true,
        },
      },
    }
  end,
}
```
