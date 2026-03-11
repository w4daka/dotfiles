return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "Shougo/ddc-source-lsp", -- capabilities用
      "j-hui/fidget.nvim", -- 進捗表示（お好みで）
    },
    config = function()
      local lspconfig = require("lspconfig")

      -------------------------------------------------
      -- 1. UI & Diagnostics (見た目の設定)
      -------------------------------------------------
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        virtual_text = { prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        },
      })

      -- Hover等のウィンドウを丸角にする
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signatureHelp, { border = "rounded" })

      -------------------------------------------------
      -- 2. LspAttach (自動コマンド・キーマップ)
      -------------------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          -- Rustは rustaceanvim に任せるため除外
          if client.name == "rust-analyzer" or client.name == "rust_analyzer" then
            return
          end

          -- キーマップ登録用ヘルパー
          local map = function(keys, func, desc, mode)
            vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- 既存設定のキーマップを完全移植
          map("grn", vim.lsp.buf.rename, "Rename")
          map("gra", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
          map("grr", require("telescope.builtin").lsp_references, "References")
          map("gri", require("telescope.builtin").lsp_implementations, "Implementation")
          map("grd", require("telescope.builtin").lsp_definitions, "Definition")
          map("grD", vim.lsp.buf.declaration, "Declaration")
          map("gO", require("telescope.builtin").lsp_document_symbols, "Symbols")
          map("K", vim.lsp.buf.hover, "Hover")

          -- 言語固有の動的フック (gopls organize imports)
          if client.name == "gopls" then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = event.buf,
              callback = function()
                local params = vim.lsp.util.make_range_params()
                params.context = { only = { "source.organizeImports" } }
                local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
                for _, res in pairs(result or {}) do
                  for _, r in pairs(res.result or {}) do
                    if r.edit then
                      vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
                    else
                      vim.lsp.buf.execute_command(r.command)
                    end
                  end
                end
              end,
            })
          end

          -- Ruffのホバー無効化
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })

      -------------------------------------------------
      -- 3. 各サーバーの個別設定をロード
      -------------------------------------------------
      require("core.lsp_servers")
    end,
  },
}
