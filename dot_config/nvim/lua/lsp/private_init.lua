return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'j-hui/fidget.nvim', -- 進捗表示（お好みで）
    },
    config = function()
      local lspconfig = require('lspconfig')

      -------------------------------------------------
      -- 1. UI & Diagnostics (見た目の設定)
      -------------------------------------------------
      vim.diagnostic.config({
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'if_many',
          header = '',
          warp = true,
        },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = {
          spacing = 2,

          prefix = '●',
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        },
      })

      vim.o.winborder = 'rounded'

      -------------------------------------------------
      -- 2. LspAttach (自動コマンド・キーマップ)
      -------------------------------------------------
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          -- LSP navigation
          vim.keymap.set(
            'n',
            'gd',
            vim.lsp.buf.definition,
            { buffer = args.buf, silent = true, desc = 'move to definition' }
          )
          vim.keymap.set(
            'n',
            'gr',
            vim.lsp.buf.references,
            { buffer = args.buf, silent = true, desc = 'move to references' }
          )
          vim.keymap.set(
            'n',
            'gI',
            vim.lsp.buf.implementation,
            { buffer = args.buf, silent = true, desc = 'move to implementation' }
          )
          vim.keymap.set(
            'n',
            'K',
            vim.lsp.buf.hover,
            { buffer = args.buf, silent = true, desc = 'hover lsp navigation' }
          )

          -- LSP actions
          vim.keymap.set(
            'n',
            '<leader>caa',
            vim.lsp.buf.code_action,
            { buffer = args.buf, silent = true, desc = 'LSP Code action' }
          )
          vim.keymap.set(
            'n',
            '<leader>rn',
            vim.lsp.buf.rename,
            { buffer = args.buf, silent = true, desc = 'LSP Rename action' }
          )

          -- Diagnostics
          vim.keymap.set('n', '<leader>dn', function()
            vim.diagnostic.jump({ count = 1 })
          end, { buffer = args.buf, silent = true, desc = 'jump next diagnostic' })

          vim.keymap.set('n', '<leader>dp', function()
            vim.diagnostic.jump({ count = -1 })
          end, { buffer = args.buf, silent = true, desc = 'jump previous diagnostic' })
          vim.keymap.set('n', '<leader>ss', vim.lsp.buf.document_symbol, {
            buffer = args.buf,
            silent = true,
            desc = 'document symbols',
          })

          vim.keymap.set('n', '<leader>sS', vim.lsp.buf.workspace_symbol, {
            buffer = args.buf,
            silent = true,
            desc = 'workspace symbols',
          })
        end,
      })
      -------------------------------------------------
      -- 3. 各サーバーの個別設定をロード
      -------------------------------------------------
      require('core.lsp_servers')
    end,
  },
}
