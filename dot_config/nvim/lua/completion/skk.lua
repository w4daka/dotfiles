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
      "shg-eo/skkeleton-azik",
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
      -- IME toggle
      vim.keymap.set({ "i", "c", "t" }, "<C-j>", "<Plug>(skkeleton-toggle)")
    end,
  },
}
