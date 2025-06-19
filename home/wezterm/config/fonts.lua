local wezterm = require('wezterm')
local nix = require('utils.nix')

return {
  font = wezterm.font('CaskaydiaMono Nerd Font Mono'),
  font_size = nix.font_size,
}
