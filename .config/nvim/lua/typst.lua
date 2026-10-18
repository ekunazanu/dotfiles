vim.lsp.config("tinymist", {
    cmd = { "tinymist", "lsp" },
    filetypes = { "typst" },
    root_markers = { ".git" },
    settings = {
        exportPdf = "never",
        preview = {
            refresh = "onSave",
            partialRendering = true,
        },
    },
    on_attach = function(client, _)
        vim.keymap.set("n", "<leader>tp", function()
            client:exec_cmd({
                command = "tinymist.startDefaultPreview",
                arguments = {},
            })
        end, {
            buffer = bufnr,
            desc = "Typst: Start preview",
        })
    end,
})

vim.lsp.enable("tinymist")
