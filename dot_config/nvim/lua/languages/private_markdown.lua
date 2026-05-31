-- install without yarn or npm
return {
  -- ~/.config/nvim/lua/plugins.lua または init.lua 内
  {
    -- "iamcco/markdown-preview.nvim",
    -- cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    -- build = function()
    --   local app_dir = vim.fn.stdpath("data") .. "/lazy/markdown-preview.nvim/app"
    --   vim.fn.system("cd " .. app_dir .. " && npm install")
    -- end,
    -- init = function()
    --   vim.g.mkdp_filetypes = { "markdown" }
    --   vim.g.mkdp_browser = "/usr/bin/vivaldi-stable" -- 明示指定で環境変数依存を排除
    -- end,
    -- ft = { "markdown" },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    config = function()
      require("markdown_preview").setup({
        -- all optional; sane defaults shown
        instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        debounce_ms = 300,
      })
      vim.keymap.set(
        "n",
        "<leader>mps",
        "<cmd>MarkdownPreview<cr>",
        { desc = "Markdown: Start preview" }
      )
      vim.keymap.set(
        "n",
        "<leader>mpS",
        "<cmd>MarkdownPreviewStop<cr>",
        { desc = "Markdown: Stop preview" }
      )
      vim.keymap.set(
        "n",
        "<leader>mpr",
        "<cmd>MarkdownPreviewRefresh<cr>",
        { desc = "Markdown: Refresh preview" }
      )
    end,
  },
}
