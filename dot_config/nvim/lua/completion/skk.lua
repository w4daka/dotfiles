return {

  {
    "delphinus/skkeleton_indicator.nvim",
    config = function()
      require("skkeleton_indicator").setup({})
    end,
  },
  {
    "vim-skk/skkeleton",
    dependencies = {
      "vim-denops/denops.vim",
      "k16em/skkeleton-azik-kanatable",
    },

    config = function()
      vim.fn["skkeleton#azik#add_table"]("jis")
      vim.fn["skkeleton#config"]({
        kanaTable = "azik",

        eggLikeNewline = true,

        globalDictionaries = {
          "~/.config/skk/SKK-JISYO.L",
          "~/.config/skk/SKK-JISYO.jinmei",
          "~/.config/skk/SKK-JISYO.geo",
        },

        userDictionary = "~/.config/skk/user_dict",
        completionRankFile = "~/.config/skk/rank.json",
      })
      vim.fn["skkeleton#register_kanatable"]("azik", {

        -- 基本
        [";"] = { "ん" },

        ["n"] = { "ん" },
        ["nn"] = { "ん" },
        ["n'"] = { "ん" },

        ["l"] = { "っ" },
        ["L"] = { "っ" },

        ["-"] = { "ー" },
        [":"] = { "ー" },

        -- 小文字
        ["xxa"] = { "ぁ" },
        ["xxi"] = { "ぃ" },
        ["xxu"] = { "ぅ" },
        ["xxe"] = { "ぇ" },
        ["xxo"] = { "ぉ" },

        ["xya"] = { "ゃ" },
        ["xyu"] = { "ゅ" },
        ["xyo"] = { "ょ" },

        ["xxwa"] = { "ゎ" },

        -- AZIK系
        ["kt"] = { "こと" },
        ["sk"] = { "する" },
        ["st"] = { "した" },
        ["tt"] = { "った" },
        ["tk"] = { "てき" },

        -- 記号
        ["z/"] = { "・" },
        ["z "] = { "　" },

        ["z~"] = { "～" },
        ["z-"] = { "～" },

        ["z."] = { "…" },

        ["z:"] = { "：" },

        ["z["] = { "『" },
        ["z]"] = { "』" },
      })

      -- IME toggle
      vim.keymap.set({ "i", "c", "t" }, "<C-j>", "<Plug>(skkeleton-toggle)")

      -- モード
      local fn = vim.fn
      -- カタカナ
      fn["skkeleton#register_keymap"]("input", "q", "katakana")

      -- 半角カタカナ
      fn["skkeleton#register_keymap"]("input", "Q", "hankatakana")

      -- 全角英数
      fn["skkeleton#register_keymap"]("input", "@", "zenkaku")
      fn["skkeleton#register_keymap"]("input", "/", "abbrev")

      vim.keymap.set("i", "'", "<Plug>(skkeleton-disable)")
    end,
  },
}
