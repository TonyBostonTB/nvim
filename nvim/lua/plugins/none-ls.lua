-- Linters and diagnostics
return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting   -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters
    
    -- Create a custom formatter for jsonnet
    local jsonnetfmt = null_ls.register({
      name = "jsonnetfmt",
      method = null_ls.methods.FORMATTING,
      filetypes = { "jsonnet", "libsonnet" },
      generator = null_ls.formatter({
        command = vim.fn.expand("$HOME/go/bin/jsonnetfmt"),
        args = function()
          return { "--indent", "2", "--string-style", "s", "--comment-style", "s", "$FILENAME" }
        end,
        to_temp_file = true,
        from_temp_file = true,
      }),
    })


    local sources = {
      diagnostics.checkmake,
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              -- Only format if auto-format is enabled (disabled by default)
              if vim.g.enable_autoformat then
                vim.lsp.buf.format { async = false }
              end
            end,
          })
        end
      end,
    }
  end,
}
