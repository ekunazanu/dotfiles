vim.opt.completeopt = 'menuone,noselect,popup'
vim.opt.shortmess:append('c')

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

local function pumap(key, fallback)
    vim.keymap.set('i', key, function()
        return vim.fn.pumvisible() == 1 and fallback or key
    end, { expr = true })
end

local function snippet_jump(key, direction)
    vim.keymap.set({ 'i', 's' }, key, function()
        if vim.fn.pumvisible() == 1 then
            return direction == 1 and '<C-n>' or '<C-p>'
        elseif vim.snippet.active({ direction = direction }) then
            return '<cmd>lua vim.snippet.jump(' .. direction .. ')<cr>'
        end
        return key
    end, { expr = true })
end

snippet_jump('<Tab>', 1)
snippet_jump('<S-Tab>', -1)
pumap('<CR>', '<C-y>')

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        vim.keymap.set('n', '<C-e>', vim.diagnostic.open_float, { buffer = args.buf })

        if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        if client and client:supports_method('textDocument/foldingRange') then
            vim.wo[0].foldmethod = "expr"
            vim.wo[0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end

        if client and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('UserLspFormat' .. args.buf, { clear = true }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, async = false })
                end,
            })
        end
    end,
})
