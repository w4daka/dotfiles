-- Open init.lua(kickstart) by :Initlua
vim.api.nvim_create_user_command("InitLua", function()
  vim.cmd.edit("~/.config/nvim/init.lua")
end, { desc = "Open init.lua" })
