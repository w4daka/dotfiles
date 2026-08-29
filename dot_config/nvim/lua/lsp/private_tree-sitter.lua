return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',

    config = function()
      local ts = require('nvim-treesitter')

      ts.setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })

      ts.install({
        'bash',
        'c',
        'cpp',
        'diff',
        'go',
        'gomod',
        'gowork',
        'gosum',
        'html',
        'javascript',
        'json',
        'latex',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'ocaml',
        'ocaml_interface',
        'python',
        'query',
        'rust',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    lazy = false,

    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
          selection_modes = {
            ['@parameter.outer'] = 'v', -- charwise
            ['@function.outer'] = 'V', -- linewise
          },
        },

        move = {
          set_jumps = true,
        },
        include_surrounding_whitespace = false,
      })

      -- You can use the capture groups defined in `textobjects.scm`
      vim.keymap.set({ 'x', 'o' }, 'am', function()
        require 'nvim-treesitter-textobjects.select'.select_textobject(
          '@function.outer',
          'textobjects'
        )
      end, { desc = 'function outer' })
      vim.keymap.set({ 'x', 'o' }, 'im', function()
        require 'nvim-treesitter-textobjects.select'.select_textobject(
          '@function.inner',
          'textobjects'
        )
      end, { desc = 'function inner' })
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        require 'nvim-treesitter-textobjects.select'.select_textobject(
          '@class.outer',
          'textobjects'
        )
      end, { desc = 'class outer' })
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        require 'nvim-treesitter-textobjects.select'.select_textobject(
          '@class.inner',
          'textobjects'
        )
      end, { desc = 'class inner' })
      -- You can also use captures from other query groups like `locals.scm`
      vim.keymap.set({ 'x', 'o' }, 'as', function()
        require 'nvim-treesitter-textobjects.select'.select_textobject('@local.scope', 'locals')
      end, { desc = 'local scope' })
      -- keymaps
      -- You can use the capture groups defined in `textobjects.scm`
      vim.keymap.set({ 'n', 'x', 'o' }, ']m', function()
        require('nvim-treesitter-textobjects.move').goto_next_start(
          '@function.outer',
          'textobjects'
        )
      end, { desc = 'Move to the beginning of the outer scope of the following function' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']]', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects')
      end, { desc = 'Move to the beginning of the outer scope of the following class' })
      -- You can also pass a list to group multiple queries.
      vim.keymap.set({ 'n', 'x', 'o' }, ']o', function()
        require('nvim-treesitter-textobjects.move').goto_next_start(
          { '@loop.inner', '@loop.outer' },
          'textobjects'
        )
      end, { desc = 'Move to the beginning of the outer scope of the following loop' })
      -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
      vim.keymap.set({ 'n', 'x', 'o' }, ']s', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals')
      end, { desc = 'Move to the beginning of the outer scope of the following local scope' })
      vim.keymap.set({ 'n', 'x', 'o' }, ']z', function()
        require('nvim-treesitter-textobjects.move').goto_next_start('@fold', 'folds')
      end, { desc = 'Move to the beginning of the outer scope of the following local fold' })

      vim.keymap.set({ 'n', 'x', 'o' }, ']M', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects')
      end, { desc = 'Move to the Ending of the outer scope of the following function' })
      vim.keymap.set({ 'n', 'x', 'o' }, '][', function()
        require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects')
      end, { desc = 'Move to the Ending of the outer scope of the following class' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[m', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start(
          '@function.outer',
          'textobjects'
        )
      end, { desc = 'Move to the beginning of the outer scope of the previous funciton' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[[', function()
        require('nvim-treesitter-textobjects.move').goto_previous_start(
          '@class.outer',
          'textobjects'
        )
      end, { desc = 'Move to the beginning of the outer scope of the previous class' })

      vim.keymap.set({ 'n', 'x', 'o' }, '[M', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end(
          '@function.outer',
          'textobjects'
        )
      end, { desc = 'Move to the Ending of the outer scope of the previous funciton' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[]', function()
        require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects')
      end, { desc = 'Move to the Ending of the outer scope of the previous class' })

      -- Go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      vim.keymap.set({ 'n', 'x', 'o' }, ']d', function()
        require('nvim-treesitter-textobjects.move').goto_next('@conditional.outer', 'textobjects')
      end, { desc = 'Move to the Ending of the outer scope of the following conditional' })
      vim.keymap.set({ 'n', 'x', 'o' }, '[d', function()
        require('nvim-treesitter-textobjects.move').goto_previous(
          '@conditional.outer',
          'textobjects'
        )
      end, { desc = 'Move to the Ending of the outer scope of the following conditional' })
      local ts_repeat_move = require 'nvim-treesitter-textobjects.repeatable_move'

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set(
        { 'n', 'x', 'o' },
        ';',
        ts_repeat_move.repeat_last_move_next,
        { desc = '. repeat in ts' }
      )
      vim.keymap.set(
        { 'n', 'x', 'o' },
        ',',
        ts_repeat_move.repeat_last_move_previous,
        { desc = '. repeat in ts' }
      )
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 3,
      min_window_height = 0,
    },
  },
}
