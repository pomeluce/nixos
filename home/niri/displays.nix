{
  config,
  lib,
  pkgs,
  ...
}:
let
  layoutPath = "${config.xdg.configHome}/kanshi/config";

  initializeLayout = pkgs.writeShellApplication {
    name = "niri-initialize-layout";
    runtimeInputs = [
      pkgs.niri
      pkgs.systemd
    ];
    text = ''
      exec ${lib.getExe pkgs.python3} ${./init_displays.py} ${lib.escapeShellArg layoutPath} "$@"
    '';
  };

  wdisplays = pkgs.symlinkJoin {
    name = "wdisplays-with-kanshi";
    paths = [ pkgs.wdisplays ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/wdisplays" \
        --add-flags "--kanshi --no-auto-apply" \
        --set WDISPLAYS_KANSHI_CONFIG ${lib.escapeShellArg layoutPath} \
        --prefix PATH : ${lib.makeBinPath [ pkgs.kanshi ]}
    '';
  };
in
lib.mkIf (config.mo.desktop.enable && config.mo.desktop.wm.niri) {
  home.packages = [ wdisplays ];

  services.kanshi = {
    enable = true;
    systemdTarget = "niri.service";
  };

  systemd.user.services.kanshi.Service = {
    ExecStartPre = "${lib.getExe initializeLayout} --ensure";
    ExecStart = lib.mkForce "${lib.getExe pkgs.kanshi} --config ${lib.escapeShellArg layoutPath}";
    RestartSec = 2;
  };

  # Capture the old output settings before linking config.kdl triggers a reload.
  home.activation.initializeNiriLayout =
    lib.hm.dag.entryBetween
      [ "linkGeneration" ]
      [
        "writeBoundary"
      ]
      ''
        run ${lib.getExe initializeLayout}
      '';

  home.activation.startNiriDisplayManager = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
    if XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/${toString config.mo.uid}}" \
      ${lib.getExe' pkgs.systemd "systemctl"} --user --quiet is-active niri.service; then
      run ${pkgs.coreutils}/bin/env XDG_RUNTIME_DIR="''${XDG_RUNTIME_DIR:-/run/user/${toString config.mo.uid}}" \
        ${lib.getExe' pkgs.systemd "systemctl"} --user start kanshi.service
    fi
  '';
}
