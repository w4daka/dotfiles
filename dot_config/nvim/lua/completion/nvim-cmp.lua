return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
      "vim-skk/skkeleton",
      "rinx/cmp-skkeleton", -- または Xantibody/blink-cmp-skkeleton を使う場合は後述
      "uga-rosa/cmp-dictionary",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- friendly-snippets を読み込み
      require("luasnip.loaders.from_vscode").lazy_load()

      -- LuaSnip の基本設定（choice node などで使う）
      luasnip.config.setup({})
      require("cmp_dictionary").setup({
        paths = { "/usr/share/dict/words" }, -- または複数指定可
        exact_length = 2, -- 2文字以上で補完開始
        first_case_insensitive = true, -- 大文字小文字区別しない
        document = false, -- document モードは重いのでオフ推奨
        sqlite = false, -- sqlite を使うと高速だが初回ビルドが必要
      })

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),

          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),

          -- <Tab> で補完確定 + スニペットジャンプ
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- choice node 選択（${1|one,two,three|} の切り替え）
          ["<C-l>"] = cmp.mapping(function()
            if luasnip.choice_active() then
              luasnip.change_choice(1)
            end
          end, { "i", "s" }),

          ["<C-h>"] = cmp.mapping(function()
            if luasnip.choice_active() then
              luasnip.change_choice(-1)
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "skkeleton", priority = 900 },
          { name = "luasnip", priority = 800 },
          { name = "dictionary", priority = 700 }, -- ← ここを追加
          { name = "path", priority = 500 },
        }, {
          { name = "buffer", keyword_length = 3, priority = 200 },
        }),

        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = {
              nvim_lsp = "[LSP]",
              skkeleton = "[SKK]",
              luasnip = "[LuaSnip]",
              dictionary = "[Dict]", -- ← ここを追加
              path = "[Path]",
              buffer = "[Buffer]",
            },
          }),
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- コマンドライン補完 (: / / ?)
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}
