-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<C-`>", ":12sp +term<CR>", { desc = "Split Terminal", remap = true })
map("n", "<C-q>", ":qa<CR>", { desc = "Quit All", remap = true })
