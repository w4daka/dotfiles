return {
  'nvim-telescope/telescope.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- optional but recommended
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  enabled = false,
  config = function()
    local builtin = require('telescope.builtin')
    local previewer = require('md-render.telescope').previewer()

    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({ previewer = previewer })
    end, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>flg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fbf', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>fgsr', builtin.grep_string, { desc = 'Telescope grep string' })
    vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Telescope  treesitter' })
    vim.keymap.set(
      'n',
      '<leader>fcb',
      builtin.current_buffer_fuzzy_find,
      { desc = 'Telescope fuzzy find current buffer' }
    )
    vim.keymap.set(
      'n',
      '<leader>fgf',
      builtin.git_files,
      { desc = 'Telescope fuzzy serch git tracked files' }
    )
    vim.keymap.set('n', '<leader>fgc', builtin.git_commits, { desc = 'Telescope list git commit' })
    vim.keymap.set('n', '<leader>fgst', builtin.git_status, { desc = 'Telescope git status' })
    vim.keymap.set('n', '<leader>fgss', builtin.git_stash, { desc = 'Telescope git stash' })
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = 'Telescope neovim config' })
    vim.keymap.set('n', '<leader>fbb', builtin.builtin, { desc = 'Telescope telescope builtin' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Find [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set(
      'n',
      '<leader>f.',
      builtin.oldfiles,
      { desc = '[F]ind Recent Files ("." for repeat)' }
    )
    vim.keymap.set('n', '<leader>fcm', builtin.commands, { desc = '[F]ind [C]ommands' })
  end,
}
