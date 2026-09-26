vim.lsp.config('gopls', {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork' },
    root_markers = { 'go.work', 'go.mod' },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                unusedwrite = true,
                modernize = true,
                shadow = true,
            },
            gofumpt = true,
            usePlaceholders = true,
            semanticTokens = true,
            completionDocumentation = false,
            linksInHover = false,
            deepCompletion = true,
            staticcheck = false,
        },
    },
})

vim.lsp.enable('gopls')
