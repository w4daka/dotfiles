return{
	cmd = {'clangd'},
	filetypes = {'c','cpp','objc','objcpp'},
	settings = {
		clangd = {
		argument = {
			'--compile-commands-dir=.',
			'--background-index',
			'--pch-storage=disk',
			}
		}
	}
}
