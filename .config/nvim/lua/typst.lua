vim.lsp.config("tinymist", {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_markers = { ".git" },
})

vim.lsp.enable("tinymist")
