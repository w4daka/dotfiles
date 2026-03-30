return {
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      tools = {
        hover_actions = { replace_builtin_hover = false },
        float_win_config = { border = 'rounded' },

        inlay_hints = {
          auto = true,
          show_parameter_hints = true,
          show_other_hints = true,
        },
      },
      code_actions = { ui_select_fallback = true },

      server = {
        on_attach = function(client, bufnr)
          local opts = { silent = true, buffer = bufnr }

          vim.keymap.set('n', '<leader>ra', function()
            vim.cmd.RustLsp 'codeAction'
          end, vim.tbl_extend('force', opts, { desc = 'Rust code action' }))

          vim.keymap.set('n', '<leader>rd', function()
            vim.cmd.RustLsp 'debuggables'
          end, vim.tbl_extend('force', opts, { desc = 'Rust debuggables' }))

          vim.keymap.set('n', '<leader>rr', function()
            vim.cmd.RustLsp 'runnables'
          end, vim.tbl_extend('force', opts, { desc = 'Rust runnables' }))

          vim.keymap.set('n', '<leader>rt', function()
            vim.cmd.RustLsp 'testables'
          end, vim.tbl_extend('force', opts, { desc = 'Rust testables' }))

          vim.keymap.set('n', '<leader>rc', function()
            vim.cmd.RustLsp 'openCargo'
          end, vim.tbl_extend('force', opts, { desc = 'Open Cargo.toml' }))

          vim.keymap.set('n', '<leader>re', function()
            vim.cmd.RustLsp 'explainError'
          end, vim.tbl_extend('force', opts, { desc = 'Rust explainError' }))
          vim.keymap.set('n', 'K', function()
            vim.cmd.RustLsp { 'hover', 'actions' }
          end, vim.tbl_extend('force', opts, { desc = 'Rust hover actions' }))

          -- インレイヒントのトグル（Neovim 標準APIを使用）
          vim.keymap.set('n', '<leader>rh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr })
          end, vim.tbl_extend('force', opts, { desc = 'Toggle inlay hints' }))

          -- またはバッファローカルで有効化
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,

        default_settings = {
          ['rust-analyzer'] = {
            checkOnSave = true,

            check = {
              command = 'clippy',
              extraArgs = { '--all', '--', '-W', 'clippy::all' },
            },

            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },

            procMacro = {
              enable = true,
              attributes = { enable = true },
            },

            inlayHints = {
              enable = true,

              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                maxLength = 0,
              },

              chainingHints = {
                enable = true,
                maxLength = 0,
              },

              parameterHints = {
                enable = true,
              },

              closureReturnTypeHints = {
                enable = 'always',
              },

              lifetimeElisionHints = {
                enable = 'skip_trivial',
                useParameterNames = true,
              },

              bindingModeHints = { enable = true },
              closureCaptureHints = { enable = true },
              discriminantHints = { enable = 'fieldless' },
              expressionAdjustmentHints = { enable = 'reborrow' },
              rangeExclusiveHints = { enable = true },
            },

            completion = {
              autoimport = { enable = true },
              postfix = { enable = true },
              callable = { snippets = 'fill_arguments' },
              fullFunctionSignatures = { enable = true },
              privateEditable = { enable = true },
            },

            imports = {
              granularity = { group = 'module' },
              prefix = 'self',
            },

            diagnostics = {
              enable = true,
              experimental = { enable = true },
              styleLints = { enable = true },
            },

            semanticHighlighting = {
              operator = { specialization = { enable = true } },
              punctuation = { enable = true, specialization = { enable = true } },
              strings = { enable = true },
            },

            hover = {
              actions = {
                enable = true,
                references = { enable = true },
                run = { enable = true },
                debug = { enable = true },
                gotoTypeDef = { enable = true },
                implementations = { enable = true },
              },
              documentation = { enable = true, keywords = { enable = true } },
              links = { enable = true },
            },

            typing = {
              autoClosingAngleBrackets = { enable = true },
            },

            lens = {
              enable = true,
              references = {
                enable = true,
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = true },
              },
              implementations = { enable = true },
              run = { enable = true },
              debug = { enable = true },
            },

            workspace = {
              symbol = { search = { kind = 'all_symbols' } },
            },
          },
        },
      },
      dap = {
        adapter = {
          type = 'executable',
          command = 'lldb-dap',
          name = 'rt_lldb',
        },
      },
    }
  end,
}
