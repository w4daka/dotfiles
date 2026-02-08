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
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      },
      virtual_text = true,
    }

    -- サーバーごとの設定（Rustはここに入れない！）
    local servers = {
      clangd = {
        capabilities = { offsetEncoding = { 'utf-16' } },
      },
      gopls = {},
      pyright = {},
      ocamllsp = {},
      lua_ls = {
        settings = { Lua = { completion = { callSnippet = 'Replace' } } },
      },
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Masonツールインストーラーの設定
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, { 'stylua', 'black', 'goimports' })

    -- rust-analyzer を明示的に除外
    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed,
    }

    require('mason-lspconfig').setup {
      automatic_installation = {
        exclude = { 'rust_analyzer', 'ocamllsp' },
      },
      handlers = {
        function(server_name)
          -- rust_analyzer は別管理なのでスキップ
          if server_name == 'rust_analyzer' then
            return
          end

          -- 最新の書き方 (v0.11以降)
          local config = servers[server_name] or {}
          config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})

          -- ここで vim.lsp.config を使用
          vim.lsp.config(server_name, config)
          vim.lsp.enable(server_name)
        end,
      },
    }

    -- OCaml (opam) 用の個別設定
    -- Masonを介さないため、ここで明示的に有効化します
    vim.lsp.config('ocamllsp', {
      capabilities = capabilities,
    })
    vim.lsp.enable 'ocamllsp'
  end,
}
