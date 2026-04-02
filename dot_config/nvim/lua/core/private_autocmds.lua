-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
-- augroup for this config file
local augroup = vim.api.nvim_create_augroup("init.lua", {})

-- wrapper function to use internal augroup
local function create_autocmd(event, opts)
	vim.api.nvim_create_autocmd(
		event,
		vim.tbl_extend("force", {
			group = augroup,
		}, opts)
	)
end

-- https://vim-jp.org/vim-users-jp/2011/02/20/Hack-202.html
create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(event)
		local dir = vim.fs.dirname(event.file)
		local force = vim.v.cmdbang == 1
		if
			vim.bool_fn.isdirectory(dir) == false
			and (force or vim.fn.confirm('"' .. dir .. '"dose not exist. Create?', "&Yes\n&No") == 1)
		then
			vim.fn.mkdir(vim.fn.iconv(dir, vim.opt.encoding:get(), vim.opt.termencoding:get()), "p")
		end
	end,
	desc = "Auto mkdir to save file",
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
-- init.lua または適当な場所で確認
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		print("LSP Attached: " .. client.name .. " to buffer " .. args.buf)
	end,
})
