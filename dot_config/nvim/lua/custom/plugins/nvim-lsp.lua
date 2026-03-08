-- ~/.config/nvim/lua/plugins/lspconfig.lua

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- LSPがアタッチされた時の共通キーマップ
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
          return
        end

        -- rust-analyzer は rustaceanvim が管理するのでスキップ
        if client.name == 'rust_analyzer' or client.name == 'rust-analyzer' then
          return
        end

        if client.name == 'gopls' then
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = event.buf,
            callback = function()
              -- organizeImports
              local params = vim.lsp.util.make_range_params()
              params.context = { only = { 'source.organizeImports' } }
              local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
              for _, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                  if r.edit then
                    vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
                  else
                    vim.lsp.buf.execute_command(r.command)
                  end
                end
              end
              -- Format
              vim.lsp.buf.format { async = false }
            end,
          })

          -- LazyVimで採用されているgoplsのセマンティックトークンの修正
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            if semantic then
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end
        end

        -- Ruff はホバーを持たないので basedpyright に任せる
        if client.name == 'ruff' then
          client.server_capabilities.hoverProvider = false
        end

        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
      end,
    })

    -- 診断表示の設定
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN]  = '󰀪 ',
          [vim.diagnostic.severity.INFO]  = '󰋽 ',
          [vim.diagnostic.severity.HINT]  = '󰌶 ',
        },
      },
      virtual_text = true,
    }

    -- ddc.vim で LSP 補完を受け取るために ddc_source_lsp のcapabilities を
    -- 標準の capabilities にマージして全サーバーに渡す
    local capabilities = vim.tbl_deep_extend(
      'force',
      vim.lsp.protocol.make_client_capabilities(),
      require('ddc_source_lsp').make_client_capabilities()
    )

    local servers = {

      -- ---------------------------------------------------------
      -- Go (gopls)
      -- ---------------------------------------------------------
      gopls = {
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
            semanticTokens = true,
          },
        },
      },

      -- ---------------------------------------------------------
      -- Python (basedpyright + ruff)
      --
      -- basedpyright → 型チェック・補完・定義ジャンプを担当
      -- ruff         → フォーマット・lint を担当（ホバーは basedpyright に任せる）
      -- ---------------------------------------------------------
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = 'basic',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      },

      ruff = {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      },

      -- ---------------------------------------------------------
      -- OCaml (opam 管理のため Mason を介さず個別に有効化)
      -- ---------------------------------------------------------
      ocamllsp = {},

      -- ---------------------------------------------------------
      -- Lua
      -- ---------------------------------------------------------
      lua_ls = {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = 'Replace' },
          },
        },
      },
    }

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
      'goimports',
      'gofumpt',
      'gomodifytags',
      'impl',
      'delve',
      'golangci-lint',
    })
    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }

    require('mason-lspconfig').setup {
      automatic_installation = {
        exclude = { 'rust_analyzer', 'ocamllsp' },
      },
      handlers = {
        function(server_name)
          if server_name == 'rust_analyzer' then return end

          local config = servers[server_name] or {}
          config.capabilities = vim.tbl_deep_extend(
            'force',
            capabilities,
            config.capabilities or {}
          )
          require('lspconfig')[server_name].setup(config)
        end,
      },
    }

    -- OCaml は Mason を介さないので個別に有効化
    vim.lsp.config('ocamllsp', { capabilities = capabilities })
    vim.lsp.enable 'ocamllsp'
  end,
}
