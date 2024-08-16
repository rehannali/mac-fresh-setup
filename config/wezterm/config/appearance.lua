local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local colors = require('colors.custom')

return {
    animation_fps = 60,
    max_fps = 60,
    front_end = 'WebGpu',
    webgpu_power_preference = 'HighPerformance',
    webgpu_preferred_adapter = gpu_adapters:pick_best(),

    -- color scheme
    colors = colors,

    -- background
    -- background = {
    --     {
    --         source = { File = wezterm.GLOBAL.background },
    --         horizontal_align = 'Center',
    --     },
    --     {
    --         source = { Color = colors.background },
    --         height = '100%',
    --         width = '100%',
    --         opacity = 0.96,
    --     },
    -- },

    -- scrollbar
    enable_scroll_bar = true,

    -- tab bar
    enable_tab_bar = false,
    hide_tab_bar_if_only_one_tab = false,
    use_fancy_tab_bar = false,
    tab_max_width = 25,
    show_tab_index_in_tab_bar = false,
    switch_to_last_active_tab_when_closing_tab = true,

    -- window
    use_dead_keys = false,
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = true,
    initial_rows = 50,
    initial_cols = 180,
    default_cursor_style = "SteadyBar",
    window_background_opacity = 0.75,
    macos_window_background_blur = 30,
    window_decorations = "RESIZE",
    window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5,
    },
    window_close_confirmation = 'NeverPrompt',
    -- window_frame = {
    --     active_titlebar_bg = '#090909',
    --     -- font = fonts.font,
    --     -- font_size = fonts.font_size,
    -- },
    -- inactive_pane_hsb = {
    --     saturation = 0.9,
    --     brightness = 0.65,
    -- },
}
