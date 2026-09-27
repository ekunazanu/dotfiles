-- word backspace
vim.keymap.set("i", "<C-BS>", "<C-W>", { buffer = true })

-- compilation
vim.keymap.set("n", "<F9>", ":w<CR>:term go run %<CR>i", { buffer = true, remap = true })
vim.keymap.set("i", "<F9>", "<Esc>" .. ":w<CR>:term go run %<CR>i", { buffer = true, remap = true })
vim.keymap.set("n", "<F5>", ":w<CR>:term %:p:S<CR>i", { buffer = true, remap = true })
vim.keymap.set("i", "<F5>", "<Esc>" .. ":w<CR>:term %:p:S<CR>i", { buffer = true, remap = true })
