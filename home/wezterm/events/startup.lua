local wezterm = require('wezterm')
local mux = wezterm.mux
local platform = require('utils.platform')()

local M = {}

function M.setup()
  if platform.is_windows then
    wezterm.on('gui-startup', function(cmd)
      local _, _, window = mux.spawn_window(cmd or {})
      window:gui_window():maximize()
    end)
  end
end

return M
