-- Blink.cmp Configuration tuned for VS Code-like completion

local blink = require("blink.cmp")
blink.setup({
	keymap = {
		preset = "super-tab",
		["<CR>"] = { "accept", "fallback" },
		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
		menu = {
			auto_show = true,
			auto_show_delay_ms = 50,
			border = "rounded",
			scrollbar = true,
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
			update_delay_ms = 50,
			window = {
				border = "rounded",
			},
		},
		ghost_text = {
			enabled = true,
			show_with_selection = true,
			show_without_selection = true,
			show_without_menu = true,
		},
	},
	signature = {
		enabled = true,
		window = {
			border = "rounded",
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	cmdline = {
		keymap = {
			preset = "cmdline",
		},
		completion = {
			menu = {
				auto_show = true,
			},
			ghost_text = {
				enabled = true,
			},
		},
	},
	snippets = {
		expand = function(snippet)
			local ok, luasnip = pcall(require, "luasnip")
			if ok then
				luasnip.lsp_expand(snippet)
			end
		end,
	},
})
