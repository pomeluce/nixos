local wezterm = require('wezterm')
local nix = require('utils.nix')

return {
  font = wezterm.font_with_fallback { 'CaskaydiaMono Nerd Font Mono', 'PinrgFang SC' },
  font_size = nix.font_size,
}
