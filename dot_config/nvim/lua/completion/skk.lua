return {

  {
    "delphinus/skkeleton_indicator.nvim",
    config = function()
      require("skkeleton_indicator").setup({})
    end,
  },
  {
    "vim-skk/skkeleton",
    dependencies = { "vim-denops/denops.vim" },
    config = function()
      vim.fn["skkeleton#config"]({
        globalDictionaries = { "~/.config/dict-skk/SKK-JISYO.L" },
        eggLikeNewline = true,
      })
      vim.keymap.set({ "i", "c", "t" }, "<C-j>", "<Plug>(skkeleton-toggle)")
    end,
  },
}
