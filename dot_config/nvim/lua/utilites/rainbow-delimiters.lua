return {
  'HiPhish/rainbow-delimiters.nvim',
  config = function()
    require('rainbow-delimiters.setup').setup {
      strategy = {
        [''] = 'rainbow-delimiters.strategy.global',
        vim = 'rainbow-delimiters.strategy.local',
      },
      query = {
        -- Use parentheses by default
        [''] = 'rainbow-delimiters',
        -- Use blocks for Lua
        lua = 'rainbow-blocks',
        -- Determine the query dynamically
        query = function(bufnr)
          -- Use blocks for read-only buffers like in `:InspectTree`
          local is_nofile = vim.bo[bufnr].buftype == 'nofile'
          return is_nofile and 'rainbow-blocks' or 'rainbow-delimiters'
        end,
      },
      highlight = {
        'RainbowDelimiterRed',
        'RainbowDelimiterYellow',
        'RainbowDelimiterBlue',
        'RainbowDelimiterOrange',
        'RainbowDelimiterGreen',
        'RainbowDelimiterViolet',
        'RainbowDelimiterCyan',
      },
    }
  end,
}
