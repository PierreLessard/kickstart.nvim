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
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
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
}
