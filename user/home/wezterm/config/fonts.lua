local wezterm = require('wezterm')
local nix = require('utils.nix')

return {
  font = wezterm.font_with_fallback { 'Maple Mono Normal NF', 'CaskaydiaMono Nerd Font Mono', 'PingFang SC', 'Noto Sans CJK SC' },
  font_size = nix.font_size,
}
