vim.opt.shortmess:append("I")
vim.opt.fillchars = { vert = " " }
vim.opt.number = true
vim.opt.laststatus = 3

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.g.mapleader = " "

vim.cmd("aunmenu PopUp")
vim.cmd("autocmd! nvim.popupmenu")

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.fillchars:append({ foldopen = " ", foldclose = " ", foldsep = " ", foldinner = " " })

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local path = vim.fn.argv(0)
        if path ~= "" and vim.fn.isdirectory(path) == 1 then
            vim.cmd("cd " .. vim.fn.fnameescape(path))
            require("nvim-tree.api").tree.open()
        end
    end,
})

vim.pack.add({
    "https://github.com/olimorris/onedarkpro.nvim",

    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },

    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",

    "https://github.com/lewis6991/gitsigns.nvim",

    "https://github.com/windwp/nvim-autopairs",

    "https://github.com/lukas-reineke/indent-blankline.nvim",
	"https://github.com/RRethy/vim-illuminate",
    "https://github.com/wurli/visimatch.nvim",
    "https://github.com/mcauley-penney/visual-whitespace.nvim",

    "https://github.com/3rd/image.nvim",
})

require("onedarkpro").setup({ options = { cursorline = true } })
vim.cmd.colorscheme("onedark_vivid")
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2c313c" })

require("nvim-treesitter").install({ "html", "css", "javascript" })
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "css", "javascript" },
    callback = function() vim.treesitter.start() end,
})

vim.lsp.enable({ "html", "cssls", "ts_ls", "emmet_language_server" })

require("blink.cmp").setup({ keymap = { preset = "super-tab" } })

require("mini.pick").setup()
local pick = require("mini.pick")
vim.keymap.set("n", "<leader>f", pick.builtin.files)
vim.keymap.set("n", "<leader>g", pick.builtin.grep_live)
vim.keymap.set("n", "<leader>b", pick.builtin.buffers)

require("nvim-tree").setup({
    view = { side = "right", width = 40 },
    filters = { custom = { "^%.git$" } },
	renderer = { icons = { git_placement = "right_align" }},
    hijack_directories = { enable = false },

    on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.map.on_attach.default(bufnr)

		local function open_node()
			local node = api.tree.get_node_under_cursor()
			if node and not node.parent then
				return
			end
			api.node.open.edit()
		end

		vim.keymap.set("n", "<LeftRelease>", open_node, { buffer = bufnr })
		vim.keymap.set("n", "<CR>", open_node, { buffer = bufnr })
		vim.keymap.set("n", "-", "<Nop>", { buffer = bufnr })
    end,
})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

vim.opt.signcolumn = "yes"
vim.opt.statuscolumn = "%l%s%C"
vim.keymap.set("n", "<leader>h", function() require("gitsigns").preview_hunk_inline() end)

require("nvim-autopairs").setup()

require("ibl").setup({ indent = { char = "▏" } })

vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#606060" })
vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#606060" })
vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#606060" })

require("visimatch").setup({ chars_lower_limit = 1 })

vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#808080", bg = "#3a404c" })

require("image").setup()
