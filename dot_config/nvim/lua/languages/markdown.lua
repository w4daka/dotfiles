-- install without yarn or npm
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    file_types = { "markdown" },
    ft = { "markdown" },
  },
}
