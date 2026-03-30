return {
  "lambdalisue/vim-kensaku",
  vim.keymap.set("n", "<leader>sj", function()
    vim.cmd("KensakuSearch")
  end),
}
