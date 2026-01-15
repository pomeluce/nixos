{ pkgs, opts, ... }:
{
  home.file.".config/swaylock/config".text = ''
    screenshots

    clock
    timestr=%H:%M:%S
    datestr=%y-%m-%d %A

    indicator
    indicator-radius=${toString (builtins.floor (96 * opts.system.gtk.scale))}

    font=PingFang SC
    font-size=${toString opts.programs.swaylock.font-size}

    color=eff1f5

    effect-blur=7x5
    effect-vignette=0.5:0.7

    bs-hl-color=dc8a78

    caps-lock-bs-hl-color=dc8a78
    caps-lock-key-hl-color=40a02b

    inside-color=1E2125
    inside-clear-color=00000000
    inside-caps-lock-color=00000000
    inside-ver-color=00000000
    inside-wrong-color=00000000

    key-hl-color=40a02b

    layout-bg-color=00000000
    layout-border-color=00000000
    layout-text-color=4c4f69

    line-color=00000000
    line-clear-color=00000000
    line-caps-lock-color=00000000
    line-ver-color=00000000
    line-wrong-color=00000000

    ring-color=7287fd
    ring-clear-color=dc8a78
    ring-caps-lock-color=fe640b
    ring-ver-color=1e66f5
    ring-wrong-color=e64553

    separator-color=00000000

    text-clear=NoInput
    text-color=C9AD77
    text-clear-color=dc8a78
    text-caps-lock-color=fe640b

    text-ver=verify
    text-ver-color=1e66f5

    text-wrong=failed
    text-wrong-color=e64553

  '';

  home.packages = with pkgs; [
    swaylock-effects
  ];
}
