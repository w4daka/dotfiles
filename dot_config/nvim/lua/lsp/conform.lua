return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,

    format_on_save = function(bufnr)
      -- 大規模ファイル（5000行超）は自動整形を無効化（フリーズ防止）
      if vim.api.nvim_buf_line_count(bufnr) > 5000 then
        return nil
      end

      -- c/cpp は LSP に任せる（clang-format と競合しやすいため）
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end

      return {
        timeout_ms = 2000, -- ruff/ocamlformat 対策で長めに
        lsp_format = "fallback",
      }
    end,

    formatters_by_ft = {
      lua = { "stylua" },

      rust = { "rustfmt" }, -- rustaceanvim が管理する rustfmt を優先

      go = { "gofumpt" }, -- gopls の organizeImports と併用可能

      python = { "ruff_format" }, -- ruff が最速・最強

      ocaml = { "ocamlformat" },

      javascript = { { "prettierd", "prettier" }, stop_after_first = true },
      typescript = { { "prettierd", "prettier" }, stop_after_first = true },

      markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
      ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },

      -- 必要に応じて追加（例）
      json = { "prettier" },
      yaml = { "prettier" },
    },

    -- フォーマッタごとの微調整（必要に応じて）
    formatters = {
      gofumpt = {
        prepend_args = { "--lang-version=go1.23" }, -- Go 1.23 以降対応
      },
      ruff_format = {
        prepend_args = { "--line-length=88" }, -- black 互換のデフォルト
      },
    },
  },
}
