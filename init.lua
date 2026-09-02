vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("i", "<C-e>", "<Plug>(emmet-expand-abbr)")
vim.keymap.set("i", "<C-n>", "<Plug>(emmet-move-next)")

vim.g.user_emmet_settings = {
    html = {
        snippets = {
            ["html:5"] = "<!DOCTYPE html>\n"
                .. '<html lang="${lang}">\n'
                .. "<head>\n"
                .. '\t<meta charset="${charset}">\n'
                .. '\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n'
                .. '\t<title>${1}</title>\n'
                .. "</head>\n"
                .. "<body>\n"
                .. "\t${2}\n"
                .. "</body>\n"
                .. "</html>",

            ["script"] = '<script type="module" src="${1}"></script>',
        },
    },
}

vim.g.mapleader = " "

vim.api.nvim_set_hl(0, "Normal", {
    bg = "#202020",
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "LineNr", {
    fg = "#606060",
})

vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#9f9f9f",
})

vim.api.nvim_set_hl(0, "CursorLine", {
    bg = "#404040",
})

vim.api.nvim_set_hl(0, "NormalFloat", {
    bg = "#606060",
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "FloatBorder", {
    bg = "#606060",
    fg = "#606060",
})

vim.api.nvim_set_hl(0, "Pmenu", {
    bg = "#606060",
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "PmenuSel", {
    bg = "#dfdfdf",
    fg = "#606060",
})

vim.api.nvim_set_hl(0, "PmenuThumb", {
    bg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "PmenuSbar", {
    bg = "#606060",
})

vim.api.nvim_set_hl(0, "Visual", {
    bg = "#404040",
    fg = "#bfbfbf",
})

vim.api.nvim_set_hl(0, "StatusLine", {
    fg = "#202020",
    bg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "StatusLineNC", {
    fg = "#202020",
    bg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "StatusLineTerm", {
    fg = "#202020",
    bg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "StatusLineTermNC", {
    fg = "#202020",
    bg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "Comment", {
    fg = "#9f9f9f",
})

vim.api.nvim_set_hl(0, "@string", {
    fg = "#80ff80",
})

vim.api.nvim_set_hl(0, "@tag", {
    fg = "#ff8080",
})

vim.api.nvim_set_hl(0, "@tag.builtin", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@tag.attribute", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@string.special.url.html", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@markup.heading.html", {
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "@markup.heading.1.html", {
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "@constant.html", {
    fg = "#ff8080",
})

vim.api.nvim_set_hl(0, "@operator.html", {
    fg = "#ffff80",
})

vim.opt.shortmess:append("I")
vim.opt.number = true
vim.opt.cursorline = true

vim.opt.fillchars = {
    eob = " ",
    vert = " ",
}

vim.opt.laststatus = 3

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.cmd("aunmenu PopUp")
vim.cmd("autocmd! nvim.popupmenu")

vim.pack.add({
    "https://github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/neovim/nvim-lspconfig",
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/RRethy/vim-illuminate",
    "https://github.com/wurli/visimatch.nvim",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/mcauley-penney/visual-whitespace.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/windwp/nvim-autopairs",
    "https://github.com/mattn/emmet-vim",
    "https://github.com/3rd/image.nvim",
    "https://github.com/uga-rosa/ccc.nvim",
})

require("ccc").setup()

vim.keymap.set("n", "<leader>c", "<cmd>CccPick<CR>")

require("visimatch").setup()
require("image").setup()

vim.api.nvim_set_hl(0, "IlluminatedWordText", {
    bg = "#606060",
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "IlluminatedWordRead", {
    bg = "#606060",
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "IlluminatedWordWrite", {
    bg = "#606060",
    fg = "#dfdfdf",
})

require("mini.pick").setup()

require("mini.pick").setup({
    window = {
        prompt_prefix = "❯ ",
    },
})

vim.api.nvim_set_hl(0, "MiniPickPrompt", {
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "MiniPickPromptPrefix", {
    fg = "#80ff80",
})

vim.api.nvim_set_hl(0, "MiniPickBorderText", {
    bg = "#202020",
    fg = "#dfdfdf",
})

require("nvim-autopairs").setup()

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")

vim.lsp.enable({
    'html',
    'cssls',
    'ts_ls', 
})

require("blink.cmp").setup({
    keymap = {
        preset = "super-tab",
    },
})

vim.lsp.config('*', {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.opt.signcolumn = "yes"
vim.opt.statuscolumn = "%l%s"
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#202020" })

local pick = require("mini.pick")

vim.keymap.set("n", "<leader>ff", pick.builtin.files)
vim.keymap.set("n", "<leader>fg", pick.builtin.grep_live)
vim.keymap.set("n", "<leader>fb", pick.builtin.buffers)

vim.api.nvim_set_hl(0, "IblIndent", { fg = "#404040" })

require("ibl").setup({
    indent = {
        char = "▏",
        highlight = "IblIndent",
    },
})

require("nvim-treesitter").install({
    "html",
    "css",
    "javascript",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "html",
        "css",
	    "javascript",
    },

    callback = function()
        vim.treesitter.start()
    end,
})

require("nvim-tree").setup({
    sync_root_with_cwd = true,

    filters = { custom = { "^.git$" } },

    view = {    
        side = "right",
        width = 40, 
    },

    hijack_directories = {
        enable = false,
    },

    renderer = {
	    icons = {
            show = {
		        file = false,
		        folder = false,
	            folder_arrow = false,
            },

	        git_placement = "after",
        },
    },

    on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.map.on_attach.default(bufnr)
        vim.keymap.del("n", "<2-LeftMouse>", { buffer = bufnr })

        vim.keymap.set("n", "<LeftRelease>", function()
            if vim.fn.line(".") == 1 then
                return
            end

            api.node.open.edit()
        end, {
            buffer = bufnr,
            noremap = true,
            silent = true,
        })

        local function open_node()
            local node = api.tree.get_node_under_cursor()

            if node and not node.parent then
                return
            end

            api.node.open.edit()
        end

        vim.keymap.set("n", "<CR>", open_node, {
            buffer = bufnr,
            noremap = true,
            silent = true,
        })
    end,
})

vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = "#dfdfdf" })

vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = "#9f9f9f" })

vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = "#0000ff" })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = "#8080ff" })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = "#0000ff" })

vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = "#dfdfdf" })
vim.api.nvim_set_hl(0, "NvimTreeImageFile", { fg = "#dfdfdf" })
vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = "#dfdfdf" })

vim.api.nvim_set_hl(0, "WinSeparator", {
    fg = "NONE", 
    bg = "NONE",
})

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local path = vim.fn.argv(0)

        if path ~= "" and vim.fn.isdirectory(path) == 1 then
            vim.cmd("cd " .. vim.fn.fnameescape(path))

            require("nvim-tree.api").tree.open({
                current_window = false,
            })
        end
    end,
})

vim.api.nvim_set_hl(0, "@property.css", {
    fg = "#dfdfdf",
})

vim.api.nvim_set_hl(0, "@variable.css", {
    fg = "#ff8080",
})

vim.api.nvim_set_hl(0, "@type.css", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@function.css", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@number.css", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@number.float.css", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@constant.css", {
    fg = "#ff0000",
})

vim.api.nvim_set_hl(0, "@punctuation.bracket.css", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@punctuation.delimiter.css", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@character.special.css", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@keyword.directive.css", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@operator.css", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@attribute.css", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@constant.css", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@keyword.modifier.css", {
    fg = "#ff80ff",
})

vim.treesitter.query.set("css", "highlights", [[
;; extends

((plain_value) @string.special.css (#not-match? @string.special.css "^--"))
]])

vim.api.nvim_set_hl(0, "@string.special.css", { fg = "#ffff80" })

vim.api.nvim_set_hl(0, "NvimTreeGitDirtyIcon",   { fg = "#ffff80" })
vim.api.nvim_set_hl(0, "NvimTreeGitStagedIcon",  { fg = "#80ff80" })
vim.api.nvim_set_hl(0, "NvimTreeGitNewIcon",     { fg = "#80ff80" })
vim.api.nvim_set_hl(0, "NvimTreeGitRenamedIcon", { fg = "#80ffff" })
vim.api.nvim_set_hl(0, "NvimTreeGitDeletedIcon", { fg = "#ff8080" })
vim.api.nvim_set_hl(0, "NvimTreeGitMergeIcon",   { fg = "#ff80ff" })
vim.api.nvim_set_hl(0, "NvimTreeGitIgnoredIcon", { fg = "#808080" })

vim.api.nvim_set_hl(0, "@keyword.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@keyword.import.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@keyword.coroutine.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@keyword.conditional.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@punctuation.bracket.javascript", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@variable.javascript", {
    fg = "#ff8080",
})

vim.api.nvim_set_hl(0, "@lsp.mod.declaration.javascript", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@lsp.mod.readonly.javascript", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@function.method.call.javascript", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@lsp.typemod.function.readonly.javascript", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@operator.javascript", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@lsp.type.property.javascript", {
    fg = "#ff8080",
})

vim.api.nvim_set_hl(0, "@lsp.type.variable.javascript", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@lsp.type.parameter.javascript", {
    fg = "#ff8080",
})

vim.api.nvim_set_hl(0, "@lsp.type.function.javascript", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@number.javascript", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@variable.member.javascript", {
    fg = "#ff8080",
})

vim.api.nvim_set_hl(0, "@punctuation.special.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@keyword.exception.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@keyword.operator.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@boolean.javascript", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@keyword.return.javascript", {
    fg = "#ff80ff",
})

vim.api.nvim_set_hl(0, "@function.call.javascript", {
    fg = "#8080ff",
})

vim.api.nvim_set_hl(0, "@constant.builtin.javascript", {
    fg = "#ffff80",
})

vim.api.nvim_set_hl(0, "@lsp.typemod.property.declaration.javascript", {
    fg = "#ff8080",
})
