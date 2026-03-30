return {
  -- 1. Python用のツールをMasonで管理
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'basedpyright', 'ruff' })
    end,
  },

  -- 2. 最新の Neovim 0.11+ 方式での LSP 設定
  {
    'neovim/nvim-lspconfig',
    config = function()
      -- ddc-source-lsp 用の共通設定
      local capabilities = require('ddc_source_lsp').make_client_capabilities()

      -- Basedpyright の設定 (vim.lsp.config を使用)
      vim.lsp.config('basedpyright', {
        cmd = { 'basedpyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git' },
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'basic',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      vim.lsp.enable 'basedpyright'

      -- Ruff の設定
      vim.lsp.config('ruff', {
        cmd = { 'ruff', 'server' },
        filetypes = { 'python' },
        capabilities = capabilities,
        on_attach = function(client)
          -- 補完は basedpyright に任せるため Ruff のホバーを無効化
          client.server_capabilities.hoverProvider = false
        end,
      })
      vim.lsp.enable 'ruff'
    end,
  },

  -- 3. ddc.vim の Python 用設定
  {
    'Shougo/ddc.vim',
    optional = true, -- 既存の ddc 設定がある前提
    opts = function()
      vim.fn['ddc#custom#patch_filetype']('python', {
        sources = { 'lsp', 'around' },
        sourceOptions = {
          lsp = {
            mark = 'LSP',
            forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
          },
        },
      })
    end,
  },
}
