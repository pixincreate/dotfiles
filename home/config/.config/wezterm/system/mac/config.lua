local utils = require 'utils'

return function(config)
    config.native_macos_fullscreen_mode = true

    config.font_size = 13

    config.use_ime = false

    config.initial_cols = 128
    config.initial_rows = 36

    return config
end
