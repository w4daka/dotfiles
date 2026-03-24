return {
  {
    "voldikss/vim-translator",
    cmd = { "TranslateW", "TranslateW --target_lang=en" },
    keys = {
      { "<leader>tj", "<cmd>TranslateW<CR>", mode = "n", desc = "Translate to Japanese" },
      {
        "<leader>tj",
        function()
          -- ビジュアル選択範囲を維持したまま実行
          local keys =
            vim.api.nvim_replace_termcodes(":<C-u>'<,'>TranslateW<CR>", true, false, true)
          vim.api.nvim_feedkeys(keys, "n", false)
        end,
        mode = "v",
        desc = "Translate selection to Japanese",
      },
      {
        "<leader>te",
        "<cmd>TranslateW --target_lang=en<CR>",
        mode = "n",
        desc = "Translate to English",
      },
      {
        "<leader>te",
        function()
          local keys = vim.api.nvim_replace_termcodes(
            ":<C-u>'<,'>TranslateW --target_lang=en<CR>",
            true,
            false,
            true
          )
          vim.api.nvim_feedkeys(keys, "n", false)
        end,
        mode = "v",
        desc = "Translate selection to English",
      },
    },
    config = function()
      vim.g.translator_target_lang = "ja"
      vim.g.translator_default_engines = { "google" }
      vim.g.translator_window_type = "popup"
      vim.g.translator_window_max_width = 0.5
      vim.g.translator_window_max_height = 0.9
    end,
  },
}
