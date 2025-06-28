local wezterm = require('wezterm')
local nix = require('utils.nix')

return {
  font = wezterm.font_with_fallback { 'CaskaydiaMono Nerd Font Mono', 'Inter', 'PinrgFang SC', 'Apple Color Emoji' },
  font_size = nix.font_size,
}
