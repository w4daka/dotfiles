-- install without yarn or npm
return {
  -- ~/.config/nvim/lua/plugins.lua または init.lua 内
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      local app_dir = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
      vim.fn.system("cd " .. app_dir .. " && npm install")
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browser = "/usr/bin/vivaldi-stable" -- 明示指定で環境変数依存を排除
    end,
    ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      render_modes = { "n", "c" },
      heading = { enabled = false },
      link = { enabled = false },
      pipe_table = { enabled = false },
    },
  },
}
