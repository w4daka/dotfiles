return {
  'vlime/vlime',
  ft = { 'lisp', 'commonlisp' },

  config = function()
    local vlime_path = vim.fn.stdpath 'data' .. '/lazy/vlime'
    vim.opt.runtimepath:append(vlime_path .. '/vim')

    vim.g.vlime_ncat_path = '/usr/bin/ncat'
    vim.g.vlime_neovim_connector = 'ncat'
    vim.g.vlime_debug = true
    vim.g.vlime_address = { '127.0.0.1', 7002 }
    vim.g.vlime_leader = '\\'
    vim.g.vlime_cl_impl = 'sbcl'

    -- サーバー起動コマンド
    vim.api.nvim_create_user_command('VlimeServerStart', function()
      local server_path = vlime_path .. '/lisp/start-vlime.lisp'

      -- サーバーをバックグラウンドで起動
      vim.fn.jobstart({ 'sbcl', '--load', server_path }, {
        detach = true,
        on_stdout = function(_, data)
          if data then
            for _, line in ipairs(data) do
              if line:match 'Swank started' or line:match 'port' then
                vim.notify('Vlime server: ' .. line, vim.log.levels.INFO)
              end
            end
          end
        end,
      })

      vim.notify('Starting Vlime server on port 7002...', vim.log.levels.INFO)
      vim.notify('Wait a few seconds, then press \\cc to connect', vim.log.levels.INFO)
    end, {})

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'lisp', 'commonlisp' },
      callback = function()
        vim.notify('Vlime loaded. Use :VlimeServerStart to start server, then \\cc to connect', vim.log.levels.INFO)
      end,
    })
  end,
}
