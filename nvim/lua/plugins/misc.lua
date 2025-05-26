-- Miscellaneous plugins - Small utility plugins with minimal configuration
-- Contains essential tools: auto-indentation detection, Git integration, 
-- keybind hints, TODO highlighting, and color preview functionality
return {
  {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },
  {
    -- Powerful Git integration for Vim
    'tpope/vim-fugitive',
  },
  {
    -- GitHub integration for vim-fugitive
    'tpope/vim-rhubarb',
  },
  {
    -- Hints keybinds
    'folke/which-key.nvim',
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  {
    -- Color highlighting via mini.hipatterns
    'echasnovski/mini.hipatterns',
    event = 'BufReadPre',
    config = function()
      require('mini.hipatterns').setup({
        highlighters = {
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })
    end,
  },
}
