-- Jsonnet and Libsonnet filetype detection
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.jsonnet", "*.libsonnet"},
  callback = function()
    vim.bo.filetype = "jsonnet"
    -- Best practice for Jsonnet is 2-space indentation
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
    vim.bo.softtabstop = 2
    -- Set comment style for Jsonnet (C-style single-line comments)
    vim.bo.commentstring = "// %s"
    -- Function parameters commonly use 4-space indentation in Jsonnet
    -- This is considered a standard practice
  end,
})