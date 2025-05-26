return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_organize_imports', 'ruff_format' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      terraform = { 'terraform_fmt' },
      jsonnet = { 'jsonnetfmt' },
      libsonnet = { 'jsonnetfmt' },
      -- Ansible YAML files (uses ansible-lint with --fix for formatting)
      ['yaml.ansible'] = { 'ansible_lint' },
      -- HAProxy config (validation only via haproxy -c)
      haproxy = {},
    },
    format_on_save = function(bufnr)
      -- Disable format on save for specific filetypes
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return
      end
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
    formatters = {
      shfmt = {
        prepend_args = { '-i', '4' },
      },
      prettier = {
        prepend_args = { '--use-tabs', 'false', '--tab-width', '4' },
      },
      jsonnetfmt = {
        command = 'jsonnetfmt',
        args = { '--indent', '2', '--string-style', 's', '--comment-style', 's', '-' },
        stdin = true,
      },
      ruff_organize_imports = {
        command = 'ruff',
        args = { 'check', '--select', 'I', '--fix', '--stdin-filename', '$FILENAME', '-' },
        stdin = true,
      },
      ruff_format = {
        command = 'ruff',
        args = { 'format', '--stdin-filename', '$FILENAME', '-' },
        stdin = true,
      },
      ansible_lint = {
        command = 'ansible-lint',
        args = { '--fix', '-' },
        stdin = true,
      },
    },
  },
  init = function()
    -- If you want the formatters to install automatically with Mason
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}