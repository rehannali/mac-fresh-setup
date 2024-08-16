local wezterm = require "wezterm"

local M = {}

M.setup = function()
    wezterm.on("gui-startup", function(cmd)
        local screen = wezterm.gui.screens().main
        local ratio = 0.88
        local width, height = screen.width * ratio, screen.height * ratio
        local tab, pane, window = wezterm.mux.spawn_window(cmd or {
            position = { x = (screen.width - width) / 2, y = (screen.height - height) / 2 },
        })
        -- window:gui_window():maximize()
        window:gui_window():set_inner_size(width, height)
    end)
end

return M
