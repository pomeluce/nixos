{ lib, opts, ... }:
{
  imports =
    lib.optionals ("ghostty" == opts.programs.terminal) [ ./ghostty ]
    ++ lib.optionals ("wezterm" == opts.programs.terminal) [ ./wezterm ];

}
