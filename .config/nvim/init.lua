-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local hl = vim.api.nvim_set_hl

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
--
vim.opt.list = true

require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  -- ///////////////////////////////////
  -- ///////////////////////////////////
  -- ///////////////////////////////////
  -- START FORMATTERS
  {
    'neovim/nvim-lspconfig',
    'jose-elias-alvarez/null-ls.nvim',
    'MunifTanjim/prettier.nvim',
    config = function()
      local null_ls = require("null-ls")

      local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
      local event = "BufWritePre" -- or "BufWritePost"
      local async = event == "BufWritePost"

      null_ls.setup({
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<leader>f", function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
              buffer = bufnr,
              group = group,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr, async = async })
              end,
              desc = "[lsp] format on save",
            })
          end

          if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<leader>f", function()
              vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
          end
        end,
      })

      local prettier = require("prettier")

      prettier.setup({
        bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
        filetypes = {
          "css",
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "less",
          "markdown",
          "scss",
          "typescript",
          "typescriptreact",
          "yaml",
        },
      })
      prettier.setup({
        ["null-ls"] = {
          condition = function()
            return prettier.config_exists({
              -- if `false`, skips checking `package.json` for `"prettier"` key
              check_package_json = true,
            })
          end,
          runtime_condition = function(params)
            -- return false to skip running prettier
            return true
          end,
          timeout = 5000,
        }
      })
      prettier.setup({
        cli_options = {
          arrow_parens = "always",
          bracket_spacing = true,
          bracket_same_line = false,
          embedded_language_formatting = "auto",
          end_of_line = "lf",
          html_whitespace_sensitivity = "css",
          -- jsx_bracket_same_line = false,
          jsx_single_quote = false,
          print_width = 120,
          prose_wrap = "preserve",
          quote_props = "as-needed",
          semi = true,
          single_attribute_per_line = false,
          single_quote = false,
          tab_width = 2,
          trailing_comma = "es5",
          use_tabs = false,
          vue_indent_script_and_style = false,
        },
      })
    end
  },
  -- END FORMATTERS
  -- ///////////////////////////////////
  -- ///////////////////////////////////
  -- ///////////////////////////////////

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    "loctvl842/monokai-pro.nvim",
    priority = 10,
    config = function()
      local colors = require("monokai-pro.colorscheme.palette.octagon")
      local base = {
        dark = colors.dark2,
        black = colors.dark1,
        red = colors.accent1,
        green = colors.accent4,
        yellow = colors.accent3,
        orange = colors.accent2,
        magenta = colors.accent6,
        cyan = colors.accent5,
        white = colors.text,
        dimmed1 = colors.dimmed1,
        dimmed2 = colors.dimmed2,
        dimmed3 = colors.dimmed3,
        dimmed4 = colors.dimmed4,
        dimmed5 = colors.dimmed5,
      }

      require("monokai-pro").setup({
        transparent_background = true,
        filter = "octagon", -- classic | octagon | pro | machine | ristretto | spectrum
        override = function()
          return {
            Structure = { fg = base.cyan, italic = false, },
            Macro = { fg = base.cyan, italic = true, },

            -- Treesitter
            ["@keyword"] = { fg = base.red, },
            
            ["@keyword.coroutine"] = { fg = base.red, },
            ["@keyword.operator"] = { fg = base.red, },
            ["@repeat"] = { fg = base.red, },
            ["@type.qualifier"] = { fg = base.red, },
            ["@field"] = { fg = base.red, },

            ["@type"] = { fg = base.cyan, },
            ["@property"] = { fg = base.green, },
            ["@parameter"] = { fg = base.orange, },

            -- Semantic tokens
            ["@lsp.mod.interpolation"] = { fg = base.orange, },
            ["@lsp.type.annotation"] = { fg = base.cyan, italic = true, },
            ["@lsp.type.parameter"] = { link = "@parameter", },
            ["@lsp.typemod.class.defaultLibrary"] = { fg = base.green, },
            ["@lsp.typemod.property.annotation"] = { fg = base.cyan, italic = true, },
            ["@lsp.typemod.function.defaultLibrary"] = { fg = base.green, },
            ["@lsp.typemod.parameter.declaration"] = { link = "@parameter", },
            ["@lsp.typemod.variable.readonly"] = { fg = base.magenta, },

            -- Language specific
            ["@lsp.type.class.dart"] = { fg = base.cyan, italic = false, },
            ["@type.python"] = { fg = base.cyan, },
            ["@keyword.python"] = { link = "@keyword", },
            ["@text.literal.markdown_inline"] = { fg = base.orange, italic = true, }
          }
        end,
      })

      -- Enable theme
      vim.cmd.colorscheme 'monokai-pro'

      -- LspInfo floating window border color
      hl(0, "LspInfoBorder", { fg = "white", })

      -- NvimTree
      hl(0, "NvimTreeNormalFloat", { fg = "white", })
      hl(0, "NvimTreeFolderName", { fg = "white", })
      hl(0, "NvimTreeOpenedFolderName", { fg = "white", italic = true, })

      -- Leap
      hl(0, "LeapLabelPrimary", { link = "IncSearch", })
      hl(0, "LeapLabelSecondary", { fg = "#222222", bg = "#fd9353", bold = true, })

      -- Telescope
      hl(0, "TelescopeMatching", { link = "IncSearch", })
      hl(0, "TelescopeSelectionCaret", { bg = "#363537", fg = "#7bd88f", bold = true, })
      hl(0, "TelescopeResultsBorder", { fg = "white", })
      hl(0, "TelescopePromptBorder", { fg = "white", })
      hl(0, "TelescopePreviewBorder", { fg = "white", })
      hl(0, "TelescopePromptNormal", { fg = "white", })
      hl(0, "TelescopePromptPrefix", { fg = "#7bd88f", })
      hl(0, "TelescopeResultsNormal", { fg = "white", })

      -- Invisible characters highlight
      hl(0, "Whitespace", { fg = "#626064", })
      hl(0, "NonText", { link = "Whitespace", })

      -- Match paren
      hl(0, "MatchParen", { fg = "#fce566", underline = true, bold = true, })
    end,
  },

  { -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 100,
    config = function()
      require("onedark").setup {
        transparent = true;

        -- Main options
        style = 'warmer',
        term_colors = true,
        eding_tildes = false,
        cmp_itemkind_reverse = false,

        -- toggle theme style --
        toggle_style_key = nil,
        toggle_style_list = {'dark','darker','cool','deep','warm','warmer','light'},

        -- Change code style --
        -- Options are italic, bold, underline, none
        -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
        code_style = {
          comments = 'italic',
          keywords = 'none',
          functions = 'none',
          strings = 'none',
          variables = 'none'
        },
      }
      vim.cmd.colorscheme 'onedark'
    end,
  },

  { -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        -- theme = 'onedark',
        theme = 'monokai-pro',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below automatically adds your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  --
  --    An additional note is that if you only copied in the `init.lua`, you can just comment this line
  --    to get rid of the warning telling you that there are not plugins in `lua/custom/plugins/`.
  -- { import = 'custom.plugins' },
}, {})


-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

----------------------------------
----------------------------------

-- From init.vim
vim.o.guicursor = ""
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smarttab = true

vim.wo.number = true
vim.wo.relativenumber = true
vim.o.scrolloff = 8
vim.wo.wrap = true
vim.cmd("syntax on")

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>pv', ':Vex<CR>', { noremap = true })
vim.keymap.set('n', '<leader><CR>', ':luafile ~/.config/nvim/init.lua<CR>', { noremap = true })
vim.keymap.set('n', '<leader>f', ':Prettier<CR>', { noremap = true })
vim.keymap.set('n', '<leader>m', ':Mason<CR>', { noremap = true })

vim.keymap.set('n', '<C-j>', ' :cnext<CR>', { noremap = true })
vim.keymap.set('n', '<C-k>', ' :cprev<CR>', { noremap = true })

-- Move visually selected lines up or down in various modes.
-- vim.keymap.set('n', 'K', ':m .-2<CR>==', { noremap = true })
vim.keymap.set('n', 'J', ':m .+1<CR>==', { noremap = true })
vim.keymap.set('v', 'K', ':m \'<-2<CR>gv=gv', { noremap = true })
vim.keymap.set('v', 'J', ':m \'>+1<CR>gv=gv', { noremap = true })

-- Navigate Horizontally by word
vim.keymap.set('n', 'H', 'b', { noremap = true })
vim.keymap.set('n', 'L', 'w', { noremap = true })
vim.keymap.set('v', 'H', 'b', { noremap = true })
vim.keymap.set('v', 'L', 'w', { noremap = true })

vim.keymap.set('n', '<leader>sh', '<C-w>h', { noremap = true })
vim.keymap.set('n', '<leader>sj', '<C-w>j', { noremap = true })
vim.keymap.set('n', '<leader>sk', '<C-w>k', { noremap = true })
vim.keymap.set('n', '<leader>sl', '<C-w>l', { noremap = true })




----------------------------------
----------------------------------



-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {"node_modules"},
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>hh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'javascript', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},


  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
