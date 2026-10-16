return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  enabled = false,

  config = function()
    require('copilot').setup {
      filetypes = {
        ['*'] = false, -- overrides default
        gitcommit = true, -- disallow specific filetype
        sh = function()
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
            -- disable for .env files
            return false
          end
          return true
        end,
      },
      suggestion = {
        auto_trigger = true,
      },
    }
  end,
}
