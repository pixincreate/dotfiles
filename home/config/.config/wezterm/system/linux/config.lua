local utils = require 'utils'

return function(config)
    config.enable_wayland = false
    config.front_end = "WebGpu"

    config.font_size = 13

    config.window_padding = {
        left = '1cell',
        right = '1cell',
        top = 4,
        bottom = 4,
    }
    config.adjust_window_size_when_changing_font_size = false

    config.use_ime = false

    return config
end
