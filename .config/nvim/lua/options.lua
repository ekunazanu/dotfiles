-- colors
vim.cmd.colorscheme("ocean")
vim.opt.termguicolors = false

-- column
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes:3"
vim.opt.foldcolumn = "1"
vim.opt.statuscolumn = " %s %C %=%{v:relnum ? v:relnum : v:lnum} "

-- misc
vim.opt.cursorline = true
vim.opt.fixeol = true
vim.opt.clipboard = "unnamedplus"
vim.opt.fillchars:append({ eob = " " })

-- paddings
vim.opt.scrolloff = 5
vim.opt.cmdheight = 5
vim.opt.tabstop = 4
vim.opt.winborder = "rounded"

-- tabline
vim.opt.showtabline = 2
vim.opt.tabpagemax = 10

-- folds
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.fillchars:append({ fold = " " })

-- tabs
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
