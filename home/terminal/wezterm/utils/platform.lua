local wezterm = require('wezterm')

local function platform()
  return {
    is_windows = string.find(wezterm.target_triple, 'windows') ~= nil,
    is_linux = string.find(wezterm.target_triple, 'linux') ~= nil,
    is_macos = string.find(wezterm.target_triple, 'darwin') ~= nil,
  }
end

return platform
