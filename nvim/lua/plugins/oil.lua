-- Oil.nvim - File manager that treats directories like buffers
-- Navigate and edit your filesystem just like editing text
-- Create, delete, rename files/directories with normal vim commands
-- Press '-' to open current directory, edit like a normal buffer
return {
    'stevearc/oil.nvim',
    -- dependencies = { 'nvim-tree/nvim-web-devicons' },
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    config = function()
      require('oil').setup {
        columns = {
          'icon',
          'permissions',
          'size',
          'mtime',
        },
        keymaps = {
          ['<C-h>'] = false,
          ['<M-h>'] = 'actions.select_split',
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          sort = {
            -- sort order can be "asc" or "desc"
            -- see :help oil-columns to see which columns are sortable
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
        },
      }

      -- Open parent directory in current window
      vim.keymap.set('n', '<space>-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

      -- Open parent directory in floating window
      vim.keymap.set('n', '-', require('oil').toggle_float)
    end,
}

