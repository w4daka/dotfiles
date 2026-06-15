-- -- 1. Capabilities の準備
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local status, ddc_lsp = pcall(require, "ddc_source_lsp")
-- if status then
--   capabilities = vim.tbl_deep_extend("force", capabilities, ddc_lsp.make_client_capabilities())
-- end
--
-- -- 2. サーバー設定の定義
-- local servers = {
--
--   gopls = {
--     settings = {
--       gopls = {
--         gofumpt = true,
--         staticcheck = true,
--       },
--     },
--   },
--   pyright = {
--     settings = {
--       pyright = {
--         disableOrganizeImports = true,
--       },
--       python = {
--         analysis = {
--           autoImportCompletions = false,
--           diagnosticMode = "workspace",
--           ignore = { "*" },
--           typeCheckingMode = "strict",
--         },
--       },
--     },
--   },
--   ruff = {},
--   ocamllsp = {},
--   ts_ls = {},
--   clangd = {},
-- Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("html", {
  capabilities = capabilities,
})
vim.lsp.config("cssls", {
  capabilities = capabilities,
})
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    if not base_on_attach then
      return
    end

    base_on_attach(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "LspEslintFixAll",
    })
  end,
})
vim.lsp.config("denols", {
  cmd = { "deno", "lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_maekers = {
    "deno.lock",
    "deno.json",
    "denojsonc",
  },
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
  },
  "ts_ls",
  {
    cmd = { "typescript-language-server" },
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
    },
    root_maekers = {
      "package-lock.json",
      "yarn.lock",
      "pnpm-lock.yaml",
      "bun.lockb",
      "bun.lock",
    },
    settings = {
      enable = true,
    },
  },
  "nixd",
  {
    settings = {
      nixd = {
        nixpkgs = {
          -- 補完を有効にするための設定
          expr = "import <nixpkgs> { }",
        },
        formatting = {
          command = { "nixfmt" }, -- 先ほど flake.nix に入れた nixfmt-rfc-style を使う
        },
        options = {
          -- NixOSの設定やFlakeのオプションも補完したい場合はここに追加
          nixos = {
            expr = "(attributes)._module.args.options",
          },
        },
      },
    },
  },
})
vim.lsp.enable({
  "lua_ls",
  "pyright",
  "denols",
  "nixd",
  "ts_ls",
  "html",
  "cssls",
  "eslint",
  "clangd",
})
