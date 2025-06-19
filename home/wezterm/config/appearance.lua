local colors = require('colors.monokai-pro')
local platform = require('utils.platform')()

return {
  -- 帧率配置
  animation_fps = platform.is_linux and 165 or 60,
  max_fps = platform.is_linux and 165 or 60,
  -- front_end = 'WebGpu',
  -- webgpu_power_preference = 'HighPerformance',

  -- color schema
  colors = colors,

  -- tab bar
  enable_tab_bar = platform.is_windows,

  -- windows
  window_decorations = platform.is_linux and 'NONE' or 'RESIZE',
  window_padding = {
    left = 35,
    right = 35,
    top = 25,
    bottom = 10,
  },
  window_close_confirmation = 'NeverPrompt',
}
