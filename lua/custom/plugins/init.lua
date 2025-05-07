-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
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
}
