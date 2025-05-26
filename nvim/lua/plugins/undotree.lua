-- UndoTree - Visual undo history browser
-- Provides a graphical tree view of your undo history
-- Never lose changes again - see and navigate through all your edits
-- Press <leader>ut to open the undo tree sidebar
return {
  'mbbill/undotree',
  config = function()
    vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { desc = 'Toggle UndoTree' })
    
    -- Configure undotree window
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_SplitWidth = 40
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}