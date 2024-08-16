-- vim.o.background = "dark"
-- vim.cmd [[ colorscheme dracula ]]
-- vim.g.material_style = "darker"
-- vim.cmd 'colorscheme material'
-- Lua initialization file
return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyTransparent = true
    vim.cmd [[colorscheme moonfly]]
  end,
}
