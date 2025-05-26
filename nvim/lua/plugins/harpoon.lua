-- Harpoon - Quick file bookmarking and navigation
-- Allows you to mark important files and jump between them instantly
-- More efficient than recent files - you manually curate your most important files
-- Use <leader>h to mark files, <leader>1-4 to jump to specific marks
return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')
    harpoon:setup()

    vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon: Add file' })
    vim.keymap.set('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: Toggle menu' })

    vim.keymap.set('n', '<leader>h1', function() harpoon:list():select(1) end, { desc = 'Harpoon: Go to file 1' })
    vim.keymap.set('n', '<leader>h2', function() harpoon:list():select(2) end, { desc = 'Harpoon: Go to file 2' })
    vim.keymap.set('n', '<leader>h3', function() harpoon:list():select(3) end, { desc = 'Harpoon: Go to file 3' })
    vim.keymap.set('n', '<leader>h4', function() harpoon:list():select(4) end, { desc = 'Harpoon: Go to file 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>hp', function() harpoon:list():prev() end, { desc = 'Harpoon: Previous' })
    vim.keymap.set('n', '<leader>hn', function() harpoon:list():next() end, { desc = 'Harpoon: Next' })
  end,
}