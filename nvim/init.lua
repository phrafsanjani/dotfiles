-- Basic settings
vim.cmd('syntax on')
vim.o.ruler = true
vim.o.backspace = 'indent,eol,start'
vim.o.number = true

-- Indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.api.nvim_command('setlocal colorcolumn=80')

-- Auto-pairs
--[[
vim.api.nvim_set_keymap('i', '"', '""<left>', {noremap = true})
vim.api.nvim_set_keymap('i', "'", "''<left>", {noremap = true})
vim.api.nvim_set_keymap('i', '(', '()<left>', {noremap = true})
vim.api.nvim_set_keymap('i', '[', '[]<left>', {noremap = true})
vim.api.nvim_set_keymap('i', '<', '<><left>', {noremap = true})
vim.api.nvim_set_keymap('i', '{', '{}<left>', {noremap = true})
vim.api.nvim_set_keymap('i', '{', '{<CR>}<Esc>ko', {noremap = true})
--]]

-- Window splitting
vim.o.splitbelow = true
vim.o.splitright = true

-- Split navigations
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', {noremap = true})
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', {noremap = true})

-- Buffer management
vim.o.hidden = true

-- Clipboard (Wayland)
vim.g.clipboard = {
  name = 'wl-clipboard',
  copy = {
    ["+"] = 'wl-copy --foreground --type text/plain',
    ["*"] = 'wl-copy --foreground --type text/plain',
  },
  paste = {
    ["+"] = 'wl-paste --no-newline',
    ["*"] = 'wl-paste --no-newline',
  },
  cache_enabled = true,
}
