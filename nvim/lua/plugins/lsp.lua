-- LSP Configuration - Language Server Protocol setup
-- Provides intelligent code features: completions, diagnostics, go-to-definition
-- Auto-installs language servers via Mason for multiple programming languages
-- Includes Rust, Python, Lua, JSON, Terraform, Ansible, and more
return { -- LSP Configuration & Plugins
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- JSON Schema support
    'b0o/schemastore.nvim',

    -- Modern replacement for neodev - configures Lua LSP for Neovim
    { 'folke/lazydev.nvim', ft = 'lua', opts = {} },

    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    {
      'j-hui/fidget.nvim',
      tag = 'v1.4.0',
      opts = {
        progress = {
          display = {
            done_icon = '✓', -- Icon shown when all LSP progress tasks are complete
          },
        },
        notification = {
          window = {
            winblend = 0, -- Background color opacity in the notification window
          },
        },
      },
    },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      -- Create a function that lets us more easily define mappings specific LSP related items.
      -- It sets the mode, buffer and description for us each time.
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-T>.
        map('<leader>gd', function()
          Snacks.picker.lsp_definitions()
        end, '[G]oto [D]efinition')

        -- Find references for the word under your cursor.
        map('gr', function()
          Snacks.picker.lsp_references()
        end, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', function()
          Snacks.picker.lsp_implementations()
        end, '[G]oto [I]mplementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', function()
          Snacks.picker.lsp_type_definitions()
        end, 'Type [D]efinition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', function()
          Snacks.picker.lsp_symbols()
        end, '[D]ocument [S]ymbols')

        -- Fuzzy find all the symbols in your current workspace
        --  Similar to document symbols, except searches over your whole project.
        map('<leader>ws', function()
          Snacks.picker.lsp_workspace_symbols()
        end, '[W]orkspace [S]ymbols')

        -- Rename the variable under your cursor
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

        -- Opens a popup that displays documentation about the word under your cursor
        --  See `:help K` for why this keymap
        map('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        map('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

    -- Enable the following language servers
    local servers = {
      html = { filetypes = { 'html', 'twig', 'hbs' } },
      lua_ls = {
        -- cmd = {...},
        -- filetypes { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              -- Tells lua_ls where to find all the Lua files that you have loaded
              -- for your neovim configuration.
              library = {
                '${3rd}/luv/library',
                unpack(vim.api.nvim_get_runtime_file('', true)),
              },
              -- If lua_ls is really slow on your computer, you can try this instead:
              -- library = { vim.env.VIMRUNTIME },
            },
            completion = {
              callSnippet = 'Replace',
            },
            telemetry = { enable = false },
            diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      dockerls = {},
      docker_compose_language_service = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              pyflakes = { enabled = false },
              pycodestyle = { enabled = false },
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              mccabe = { enabled = false },
              pylsp_mypy = { enabled = false },
              pylsp_black = { enabled = false },
              pylsp_isort = { enabled = false },
            },
          },
        },
      },
      -- basedpyright = {
      --   -- Config options: https://github.com/DetachHead/basedpyright/blob/main/docs/settings.md
      --   settings = {
      --     basedpyright = {
      --       disableOrganizeImports = true, -- Using Ruff's import organizer
      --       disableLanguageServices = false,
      --       analysis = {
      --         ignore = { '*' },                 -- Ignore all files for analysis to exclusively use Ruff for linting
      --         typeCheckingMode = 'off',
      --         diagnosticMode = 'openFilesOnly', -- Only analyze open files
      --         useLibraryCodeForTypes = true,
      --         autoImportCompletions = true,     -- whether pyright offers auto-import completions
      --       },
      --     },
      --   },
      -- },
      ruff = {
        -- Notes on code actions: https://github.com/astral-sh/ruff-lsp/issues/119#issuecomment-1595628355
        -- Get isort like behavior: https://github.com/astral-sh/ruff/issues/8926#issuecomment-1834048218
        commands = {
          RuffAutofix = {
            function()
              vim.lsp.buf.execute_command {
                command = 'ruff.applyAutofix',
                arguments = {
                  { uri = vim.uri_from_bufnr(0) },
                },
              }
            end,
            description = 'Ruff: Fix all auto-fixable problems',
          },
          RuffOrganizeImports = {
            function()
              vim.lsp.buf.execute_command {
                command = 'ruff.applyOrganizeImports',
                arguments = {
                  { uri = vim.uri_from_bufnr(0) },
                },
              }
            end,
            description = 'Ruff: Format imports',
          },
        },
      },
      jsonls = {
        settings = {
          json = {
            format = {
              enable = true,
              indentSize = 4,
              tabSize = 4,
              insertSpaces = true,
            },
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      },
      sqlls = {},
      terraformls = {},
      yamlls = {},
      bashls = {},
      graphql = {},
      ansiblels = {},
      rust_analyzer = {
        settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = 'clippy',
              extraArgs = { '--no-deps' },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
      jsonnet_ls = {
        cmd = { vim.fn.expand('~/.local/bin/jsonnet-language-server') },
        filetypes = { 'jsonnet', 'libsonnet' },
      },
    }

    -- Ensure the servers and tools above are installed
    require('mason').setup()

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    -- Exclude jsonnet_ls from Mason management (using manual installation)
    ensure_installed = vim.tbl_filter(function(server) return server ~= 'jsonnet_ls' end, ensure_installed)
    vim.list_extend(ensure_installed, {
      'stylua', -- Used to format lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Setup jsonnet_ls manually (outside Mason management)
    require('lspconfig').jsonnet_ls.setup {
      cmd = { vim.fn.expand('~/.local/bin/jsonnet-language-server') },
      filetypes = { 'jsonnet', 'libsonnet' },
      capabilities = capabilities,
    }

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          -- Skip jsonnet_ls since it's manually configured
          if server_name == 'jsonnet_ls' then
            return
          end
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

  end,
}
