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

      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        go = { "golangci-lint" },
        python = { "ruff_format" },
        ocaml = { "ocamlformat" },
        cpp = { "clang-format" },

        javascript =  { "prettierd", "prettier" }, 
        javascriptreact = {
          "prettier",
          "prettierd",
        },
        typescript = { "prettierd", "prettier" },
        typescriptreact = {
          "prettier",
          "prettierd",
        },

        -- markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
        -- ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },

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
