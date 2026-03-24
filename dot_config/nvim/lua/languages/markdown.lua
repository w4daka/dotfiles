-- install without yarn or npm
return {
  -- ~/.config/nvim/lua/plugins.lua または init.lua 内
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install", -- 初回インストール時または更新時に依存関係をビルド
    init = function()
      vim.g.mkdp_filetypes = { "markdown" } -- Markdownファイルでのみ有効化
    end,
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
}
