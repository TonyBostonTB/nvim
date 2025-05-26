require 'core.options'
require 'core.keymaps'
require 'core.snippets'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out,                            'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require('lazy').setup {
  require 'plugins.oil',
  require 'plugins.colortheme',
  require 'plugins.treesitter',
  require 'plugins.lsp',
  require 'plugins.none-ls',
  require 'plugins.conform',
  require 'plugins.mini',
  require 'plugins.snacks',
  require 'plugins.misc',
  require 'plugins.presenting',
  require 'plugins.vim-tmux-navigation',
  require 'plugins.markdown-preview',
  require 'plugins.hardtime',
  require 'plugins.blink-cmp',
  require 'plugins.flash',
  require 'plugins.harpoon',
  require 'plugins.undotree',
}

-- Check for required external tools
local function check_external_tools()
  local tools = {
    { command = 'go', install_cmd = 'brew install go', message = 'Go is required for some formatters' },
    {
      command = vim.fn.expand '$HOME/go/bin/jsonnetfmt',
      install_cmd = 'go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest',
      message = 'Required for jsonnet/libsonnet formatting',
    },
  }

  for _, tool in ipairs(tools) do
    -- Handle both string commands and expanded path variables
    local cmd = type(tool.command) == 'function' and tool.command() or tool.command
    local found = vim.fn.executable(cmd) == 1
    if not found then
      vim.notify(
      string.format('Warning: %s not found. Install with: %s\n%s', tool.command, tool.install_cmd, tool.message),
        vim.log.levels.WARN)
    end
  end
end

vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    check_external_tools()
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
