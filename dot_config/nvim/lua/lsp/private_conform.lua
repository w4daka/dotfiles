return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },

  keys = {
    {
      "<leader>f",
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr):gsub("\\", "/")

        local opts = {
          async = true,
          lsp_format = "fallback",
        }

        -- Zenn の articles/*.md だけは prettier / markdown-toc を避ける
        if vim.bo[bufnr].filetype == "markdown" and filename:match("/articles/[^/]+%.md$") then
          opts.lsp_format = "never"
          opts.formatters = { "markdownlint-cli2" }
        end

        require("conform").format(opts)
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },

  opts = function()
    local function is_zenn_article(bufnr)
      local filename = vim.api.nvim_buf_get_name(bufnr):gsub("\\", "/")
      return filename:match("/articles/[^/]+%.md$") ~= nil
    end

    return {
      notify_on_error = false,

      format_on_save = function(bufnr)
        -- 大規模ファイルは自動整形しない
        if vim.api.nvim_buf_line_count(bufnr) > 5000 then
          return nil
        end

        -- c/cpp は LSP に任せる
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        end

        -- Zenn 記事だけ別設定
        if vim.bo[bufnr].filetype == "markdown" and is_zenn_article(bufnr) then
          return {
            timeout_ms = 2000,
            lsp_format = "never",
            formatters = { "markdownlint-cli2" },
          }
        end

        -- それ以外は従来どおり
        return {
          timeout_ms = 2000,
          lsp_format = "fallback",
        }
      end,

      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        go = { "gofumpt" },
        python = { "ruff_format" },
        ocaml = { "ocamlformat" },

        javascript = { { "prettierd", "prettier" }, stop_after_first = true },
        typescript = { { "prettierd", "prettier" }, stop_after_first = true },

        markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },

        json = { "prettier" },
        yaml = { "prettier" },
      },

      formatters = {
        gofumpt = {
          prepend_args = { "--lang-version=go1.23" },
        },
        ruff_format = {
          prepend_args = { "--line-length=88" },
        },
      },
    }
  end,
}
