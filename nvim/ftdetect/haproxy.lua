-- HAProxy configuration filetype detection
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.cfg',
  callback = function()
    vim.bo.filetype = 'haproxy'
  end,
})