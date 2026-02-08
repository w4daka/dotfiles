return {
  'nvimtools/none-ls.nvim',
  optional = false,
  opts = function(_, opts)
    local nls = require 'null-ls'
    opts.sources = vim.list_extend(opts.sources or {}, {
      nls.builtins.diagnostics.markdownlint_cli2.with {
        method = nls.methods.DIAGNOSTICS,
      },
    })
  end,
}
