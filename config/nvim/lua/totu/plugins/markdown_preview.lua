return {
  "toppair/peek.nvim",
  event = { "VeryLazy" },
  build = "deno task --quiet build:fast",
  config = function()
    local peek = require("peek")
    local api = vim.api
    peek.setup()
    api.nvim_create_user_command("PeekOpen", peek.open, {})
    api.nvim_create_user_command("PeekClose", peek.close, {})
  end,
}
