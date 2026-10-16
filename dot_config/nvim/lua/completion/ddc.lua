vim.g.copilot_no_maps = true

return {
  'Shougo/ddc.vim',
  dependencies = {
    'Shougo/ddc-source-around',
    'Shougo/ddc-filter-matcher_head',
    'Shougo/ddc-filter-sorter_rank',
    'Shougo/ddc-ui-pum',
    'Shougo/ddc-source-lsp',
    'Shougo/pum.vim',
    'vim-denops/denops.vim',
    'tani/ddc-fuzzy',
    'LumaKernel/ddc-source-file',
    'matsui54/ddc-source-buffer',
    'matsui54/ddc-source-dictionary',
    'Shougo/ddc-source-cmdline',
    'Shougo/ddc-source-cmdline_history',
    'L3MON4D3/LuaSnip',
    'rafamadriz/friendly-snippets',
    'hrsh7th/vim-vsnip',
    'uga-rosa/ddc-source-vsnip',
    'Shougo/ddc-source-copilot',
  },
  config = function()
    -- 	-- " Customize global settings
    vim.fn['ddc#custom#patch_global']({
      ui = 'pum',
      autoCompleteEvents = {
        'InsertEnter',
        'TextChangedI',
        'TextChangedP',
        'CmdlineEnter',
        'CmdlineChanged',
      },
      cmdlineSources = {
        [':'] = { 'cmdline', 'cmdline_history', 'around' },
      },
    })
    --
    -- 	-- " Use around source.
    -- " https://github.com/Shougo/ddc-source-around
    vim.fn['ddc#custom#patch_global']('sources', {
      'skkeleton',
      'skkeleton_okuri',
      'lsp',
      -- 'copilot',
      'vsnip',
      'file',
      'buffer',
      'around',
      'dictionary',
    })
    vim.fn['ddc#custom#patch_global']('sourceOptions', {
      _ = {
        matchers = { 'matcher_head' },
        sorters = { 'sorter_rank' },
      },
      skkeleton = {
        mark = '[SKK]',
        matchers = {},
        sorters = {},
        converters = {},
        isVolatile = true,
        minAutoCompleteLength = 1,
      },
      skkeleton_okuri = {
        mark = '[SKK*]',
        matchers = {},
        sorters = {},
        converters = {},
        isVolatile = true,
      },
      vsnip = { mark = '[V]' },
      around = { mark = '[A]' },
      file = {
        mark = '[F]',
        isVolatile = true,
        forceCompletionPattern = [[\S/\S*]],
      },
      lsp = {
        isVolatile = true,
        mark = '[L]',
        forceCompletionPattern = [[\.\w*|:\w*|->\w*]],
      },
      buffer = { mark = '[B]' },
      dictionary = {
        mark = '[d]',
      },
      -- copilot = {
      --   mark = '[C]',
      --   matchers = {},
      --   minAutoCompleteLength = 0,
      -- },
    })
    vim.fn['ddc#custom#patch_global']('sourceParams', {
      around = { maxSize = 500 },
      dictionary = {
        dictPaths = { '/usr/share/dict/words' },
        smartCase = true,
        isVolatile = true,
      },
      -- copilot = {
      --   copilot = 'lua',
      -- },
    })

    vim.keymap.set('i', '<C-n>', '<Cmd>call pum#map#insert_relative(+1)<CR>')
    vim.keymap.set('i', '<C-p>', '<Cmd>call pum#map#insert_relative(-1)<CR>')
    vim.keymap.set('i', '<C-y>', '<Cmd>call pum#map#confirm()<CR>')
    vim.keymap.set('i', '<C-e>', '<Cmd>call pum#map#cancel()<CR>')

    vim.keymap.set('i', '<Tab>', function()
      if vim.fn['pum#visible']() then
        return '<Cmd>call pum#map#insert_relative(+1)<CR>'
      end
      local col = vim.fn.col('.')
      if col <= 1 or vim.api.nvim_get_current_line():sub(col - 1, col - 1):match('%s') then
        return '<Tab>'
      end
      return vim.fn['ddc#map#manual_complete']()
    end, { expr = true, silent = true })
    vim.keymap.set('i', '<S-Tab>', '<Cmd>call pum#map#insert_relative(-1)<CR>')

    local function commandline_post()
      pcall(vim.keymap.del, 'c', '<Tab>')
      pcall(vim.keymap.del, 'c', '<S-Tab>')
      pcall(vim.keymap.del, 'c', '<C-n>')
      pcall(vim.keymap.del, 'c', '<C-p>')
      pcall(vim.keymap.del, 'c', '<C-y>')
      pcall(vim.keymap.del, 'c', '<C-e>')
    end

    local function commandline_pre()
      vim.keymap.set('c', '<Tab>', '<Cmd>call pum#map#insert_relative(+1)<CR>')
      vim.keymap.set('c', '<S-Tab>', '<Cmd>call pum#map#insert_relative(-1)<CR>')
      vim.keymap.set('c', '<C-n>', '<Cmd>call pum#map#insert_relative(+1)<CR>')
      vim.keymap.set('c', '<C-p>', '<Cmd>call pum#map#insert_relative(-1)<CR>')
      vim.keymap.set('c', '<C-y>', '<Cmd>call pum#map#confirm()<CR>')
      vim.keymap.set('c', '<C-e>', '<Cmd>call pum#map#cancel()<CR>')

      vim.api.nvim_create_autocmd('User', {
        pattern = 'DDCCmdlineLeave',
        once = true,
        callback = commandline_post,
      })

      vim.fn['ddc#enable_cmdline_completion']()
    end

    vim.keymap.set('n', ':', function()
      commandline_pre()
      return ':'
    end, { expr = true })
    vim.fn['pum#set_option']({
      highlight_columns = {
        kind = 'PmenuKind',
        menu = 'PmenuExtra',
      },
      blend = 30,
    })
    vim.cmd([[
     call ddc#custom#patch_global('sourceParams', #{
       \   lsp: #{
       \     snippetEngine: denops#callback#register(
       \       { body -> vsnip#anonymous(body) }
       \     ),
       \     enableResolveItem: v:true,
       \     enableAdditionalTextEdit: v:true,
       \   },
       \ })
   ]])
    vim.fn['ddc#enable']()
  end,
}
