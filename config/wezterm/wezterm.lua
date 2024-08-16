local Config = require "config"

require('events.centered_window').setup()

-- and finally, return the configuration to wezterm
return Config:init()
    :append(require('config.appearance'))
    :append(require('config.domains'))
    :append(require('config.fonts'))
    :append(require('config.general'))
    :append(require('config.launch')).options
