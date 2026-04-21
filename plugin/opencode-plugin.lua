vim.api.nvim_create_user_command('Opencode', function()
  require("opencode-plugin").open()
end, {})

vim.keymap.set('n', '<leader>oc', '<cmd>Opencode<CR>', { desc = "Open Opencode dialog" })