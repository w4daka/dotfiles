-- 1. Capabilities の準備
local capabilities = vim.lsp.protocol.make_client_capabilities()
local status, ddc_lsp = pcall(require, "ddc_source_lsp")
if status then
  capabilities = vim.tbl_deep_extend("force", capabilities, ddc_lsp.make_client_capabilities())
end

local group = vim.api.nvim_create_augroup("kyoh86-plug-denols-deno-docs", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  pattern = { "deno:/*" },
  callback = function()
    vim.bo.bufhidden = "wipe"
  end,
})

-- 2. サーバー設定の定義
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          ignoreDir = { ".devbox", ".git" },
          library = vim.api.nvim_get_runtime_file("", true),
          preloadFileSize = 1000,
          maxPreload = 2000,
        },
        hint = {
          enable = true,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        staticcheck = true,
      },
    },
  },
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          autoImportCompletions = false,
          diagnosticMode = "workspace",
          ignore = { "*" },
          typeCheckingMode = "strict",
        },
      },
    },
  },
  ruff = {},
  ocamllsp = {},
  ts_ls = {},
  denols = {
    settings = {
      lint = true,
      unstable = false,
      suggest = {
        completeFunctionCalls = true,
        names = true,
        paths = true,
        autoImports = true,
        imports = {
          autoDiscover = true,
          hosts = vim.empty_dict(),
        },
      },
    },
    single_file_support = false,
    ---@param bufnr number
    ---@param callback fun(root_dir?: string)
    root_dir = function(bufnr, callback)
      local path = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":p:h")
      local marker = require("climbdir.marker")
      local found = require("climbdir").climb(
        path,
        marker.one_of(
          marker.has_readable_file("deno.json"),
          marker.has_readable_file("deno.jsonc"),
          marker.has_directory("denops")
        ),
        {}
      )
      if found then
        vim.b[vim.fn.bufnr()].deno_deps_candidate = found .. "/deps.ts"
        callback(found)
      end
    end,
  },
  clangd = {},
  nixd = {
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
}

-- 3. 新しい API (vim.lsp.config) によるセットアップ
for server_name, config in pairs(servers) do
  config.capabilities = vim.tbl_deep_extend("force", capabilities, config.capabilities or {})

  -- 新しい API (Neovim 0.11+)
  vim.lsp.config(server_name, config)
  vim.lsp.enable(server_name)
end
