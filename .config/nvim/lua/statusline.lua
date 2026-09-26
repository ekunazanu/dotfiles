local augroup = vim.api.nvim_create_augroup('InitStatusline', { clear = true })
vim.opt.showmode = false
vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave' }, {
    group = augroup,
    pattern = '*',
    callback = function()
        vim.opt.relativenumber = true
        vim.api.nvim_set_hl(0, 'StatuslineMode', { ctermfg = 0, ctermbg = 15 })
    end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'InsertEnter' }, {
    group = augroup,
    pattern = '*',
    callback = function()
        vim.opt.relativenumber = false
        vim.api.nvim_set_hl(0, 'StatuslineMode', { ctermfg = 0, ctermbg = 1 })
    end,
})

-- mode
local currentmode = {
    n = 'N',
    i = 'I',
    R = 'R',
    c = 'C',
    v = 'V',
    s = 'S',
    t = 'T',
    ce = 'E',
    cv = 'VE',
    V = 'V Line',
    S = 'S Line',
    Rv = 'V Replace',
    no = 'Pending',
    r = 'Prompt',
    rm = 'More',
    ['r?'] = 'Confirm',
    ['!'] = 'Shell',
}
currentmode[vim.api.nvim_replace_termcodes('<C-V>', true, true, true)] = 'V Block'
currentmode[vim.api.nvim_replace_termcodes('<C-S>', true, true, true)] = 'S Block'
vim.g.currentmode = currentmode

-- statusline
vim.opt.laststatus = 2
vim.opt.statusline = table.concat({
    '%#StatuslineMode#',
    ' %{toupper(g:currentmode[mode()])} ',
    '%#StatuslineColor#',
    ' %.20f',
    ' %m',
    '%=',
    ' %y',
    ' %{&fileencoding?&fileencoding:&encoding}',
    '[%{&fileformat}]',
    ' %3p%% ',
    '%#StatuslineMode#',
    ' %3l:%-3c',
})
