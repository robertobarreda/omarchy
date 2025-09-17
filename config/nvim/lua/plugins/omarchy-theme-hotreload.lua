return {
	{
		name = "omarchy-theme-hotreload",
		dir = vim.fn.stdpath("config"),
		lazy = false,
		priority = 1000,
		config = function()
			-- Listen to Lazy's reload event to apply the new colorscheme
			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyReload",
				callback = function()
					package.loaded["plugins.theme"] = nil

					local ok, theme_spec = pcall(require, "plugins.theme")
					if ok and theme_spec then
						for _, spec in ipairs(theme_spec) do
							if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
								vim.schedule(function()
									require("lazy.core.loader").colorscheme(spec.opts.colorscheme)
								end)
								break
							end
						end
					end
				end,
			})
		end,
	},
}
