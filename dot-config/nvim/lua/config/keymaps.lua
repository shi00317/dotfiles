-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = false })
local map = vim.keymap.set
map("n", "SS", "<cmd>w<CR>", { desc = "Save Buffer", silent = true })
map("n", "QQ", "<cmd>q<CR>", { desc = "Quit Buffer", silent = true })
--
