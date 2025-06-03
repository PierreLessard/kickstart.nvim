-- Define the on_attach function
local function my_on_attach(bufnr)
  local api = require 'nvim-tree.api'

  -- Helper function for setting options
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Apply default mappings (necessary to retain default functionality)
  api.config.mappings.default_on_attach(bufnr)

  -- Custom mappings
  vim.keymap.set('n', '<CR>', api.node.open.tab_drop, opts 'Open: New Tab')

  -- Example: You can remove or change default mappings
  -- vim.keymap.del('n', '<BS>', opts('Close Directory'))
end

return {
  -- Add the auto-save plugin
  {
    'pocco81/auto-save.nvim',
    config = function()
      require('auto-save').setup {
        enabled = true,
        execution_message = { enabled = false },
        trigger_events = { 'InsertLeave', 'TextChanged' },
        condition = function(buf)
          -- Disable autosave for init.lua or any other specific file
          local filename = vim.api.nvim_buf_get_name(buf)
          return not filename:match 'init.lua$'
        end,
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require('nvim-tree').setup {
        on_attach = my_on_attach,
        -- Optional customizations here
        view = {
          width = 30, -- Set the width of the file tree
          side = 'right', -- Position the file tree on the left
        },
        renderer = {
          highlight_opened_files = 'name', -- Highlight opened files
          add_trailing = true, -- Add trailing slash to folders
        },
        git = {
          enable = true, -- Enable git integration
        },
        filters = {
          dotfiles = false, -- Show dotfiles (set to true to hide them)
        },
      }
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    lazy = false, -- install & load immediately
    enabled = true,
  },
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup {
        options = {
          mode = 'buffers',
          separator_style = 'thick', -- try "padded_slant", "thick", "thin"
          truncate_names = true,
          left_trunc_marker = '--',
          right_trunc_marker = '--',
          indicator = {
            style = 'underline',
          },
          diagnostics = 'nvim_lsp',
          show_buffer_close_icons = false,
          show_close_icon = false,
          always_show_bufferline = true,
          diagnostics_indicator = function(count, level, diagnostics_dict, _context)
            local s = ' '
            for e, n in pairs(diagnostics_dict) do
              local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or (e == 'info' and ' ' or ' '))
              s = s .. sym .. n
            end
            return s
          end,
        },
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      current_line_blame = false,
    },
  },
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup()

      -- Optional handlers
      require('scrollbar.handlers.gitsigns').setup()
      require('scrollbar.handlers.diagnostic').setup()
    end,
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('diffview').setup {}
    end,
  },
  {
    'mfussenegger/nvim-jdtls'
  },
}
