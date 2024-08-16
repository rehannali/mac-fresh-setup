return {
  "vim-test/vim-test",
  config = function()
    vim.cmd [[
      let test#strategy = "vimux"
    ]]
    local keymap = vim.keymap
    keymap.set('n', '<leader>t', ':TestNearest<CR>')
    keymap.set('n', '<leader>T', ':TestFile<CR>')
  end,
}
