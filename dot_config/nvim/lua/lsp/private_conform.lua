return {
  -- 読み込むプラグインの宣言
  'stevearc/conform.nvim',
  -- bufferが保存される前に起動する(自分の仮説) => "BufWritePre"イベントが発生したときに、このプラグインをlazy.nvimがロードする。(chatGPTのレビュー)
  event = { 'BufWritePre' },
  -- わからない(自分)=>":ConformInfo"を実行したときにConform.nvimをロードする。なお"event"と"cmd"と"key"は全部「Conformをロードするためのlazy.nvim側の条件」
  cmd = { 'ConformInfo' },

  -- keyの宣言(自分の仮説)=>lazy.nvimにkeymapを登録させる設定
  keys = {
    {
      -- keyは<leader>->f
      '<leader>f',
      function()
        -- conformのapiのformatを呼んでいる
        require('conform').format({
          -- falseの場合フォーマットが完了する前にバッファが変更された場合そのフォーマットは捨てられる。(自分の仮説)=>trueなら非同期で実行し、formatter完了前にbufferが変更された場合はformat結果を破棄する
          async = true,
          -- formatterがない場合はlspのフォーマッターにフォールバックする
          lsp_format = 'fallback',
        })
      end,
      -- ノーマルモードなどのneovimのモード
      mode = '',
      -- keymapの説明
      desc = '[F]ormat buffer',
    },
  },
  -- lazy.nvimに対して、Conformのsetup()を渡す設定を指定。
  --lazy.nvim => ▽require("conform").setup(opts)と考える
  opts = {
    -- フォーマッターがバッファにない場合は通知しない。(通知したいからtrueにしたい=>falseの場合フォーマッターが失敗しても通知しない。
    notify_on_error = true,

    notify_no_formatters = true,

    -- filetype別にフォーマッターを定義 docのconform-formatterを参照するべし
    formatters_by_ft = {
      -- luaはstylua
      lua = { 'stylua' },
      -- rustはrustfmt。mrcjkb/rustaceanvimの設定と衝突しない？
      rust = { 'rustfmt' },
      -- goのフォーマッターはgolangci-lint=>この設定ではGoのformatterとしてgolangci-lintを指定している.Goにはgofmt等もある。
      go = { 'golangci-lint' },
      -- pythonはruff_format
      python = { 'ruff_format' },
      -- ocamlはocamlformat
      ocaml = { 'ocamlformat' },
      -- cppは▽clang-format
      cpp = { 'clang-format' },

      -- javascriptはprettierdかprettier。実行可能なほうだけ実行する
      javascript = {
        'prettierd',
        'prettier',
        -- 実行可能なほうだけ実行するようにするオプション
        stop_after_first = true,
      },
      -- javascriptと同
      javascriptreact = {
        'prettierd',
        'prettier',
        stop_after_first = true,
      },
      -- javascriptと同
      typescript = {
        'prettierd',
        'prettier',
        stop_after_first = true,
      },
      -- javascriptと同
      typescriptreact = {
        'prettierd',
        'prettier',
        stop_after_first = true,
      },
      -- jsonはprittier、prettierdに変えられないか？=>変えた
      json = {
        'prettierd',
        'prettier',
        stop_after_first = true,
      },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
    },

    --保存時にConformがformatを実行するための設定
    format_on_save = function(bufnr)
      -- file名がmarkdownもしくはmarkdown.mdxたったら終了する(自分の仮説)=>bufferのfiletypeがmarkdownまたはmarkdown.mdxだったらformat-on-saveを無効にする
      if vim.bo[bufnr].filetype == 'markdown' or vim.bo[bufnr].filetype == 'markdown.mdx' then
        return
      end

      -- この設定でformat-on-saveを実行する
      return {
        -- timeoutまで500秒(自分の仮説)=>format-on-saveでformat処理を待つ最大時間を500msに設定する
        timeout_ms = 500,
        -- lspにフォーマットをフォーマッタがない場合はフォールバック
        lsp_format = 'fallback',
      }
    end,
    -- fomatter固有の設定
    formatters = {
      -- ruffは1行の最大文字数が88字でformatする(自分の仮説) => Conformがruff_formatを実行するときの引数として--line-length=88を追加する。
      ruff_format = {
        prepend_args = { '--line-length=88' },
      },
    },
  },
}
