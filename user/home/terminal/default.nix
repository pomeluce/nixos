{ sysConfig, lib, ... }:
let
  cfg = sysConfig.myOptions;
in
{
  imports =
    lib.optionals ("ghostty" == cfg.programs.terminal) [ ./ghostty ]
    ++ lib.optionals ("wezterm" == cfg.programs.terminal) [ ./wezterm ];
}
