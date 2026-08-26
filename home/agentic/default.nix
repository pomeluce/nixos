{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  agentic = config.mo.agentic;
  reconcileArguments = lib.escapeShellArgs (
    [ "--reconcile" ]
    ++ lib.optional agentic.claude "--claude"
    ++ lib.optional agentic.codex "--codex"
    ++ lib.optional agentic.pi "--pi"
    ++ [
      "--collection"
      "${inputs.mattpocock-skills}/skills"
      "--skill"
      "ppt-master=${inputs.ppt-master}/skills/ppt-master"
      "--skill"
      "humanizer=${inputs.humanizer}"
      "--skill"
      "humanizer-zh=${inputs.humanizer-zh}"
    ]
  );
in
{
  imports = [
    ./akmux.nix
    ./claude
    ./codex.nix
    ./pi.nix
  ];

  home.activation = lib.mkMerge [
    {
      installAgentResources = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        set -euo pipefail

        export PATH="${
          lib.makeBinPath [
            pkgs.bash
            pkgs.coreutils
            pkgs.findutils
            pkgs.gnugrep
            pkgs.rsync
            pkgs.util-linux
          ]
        }:$PATH"

        ${./.agents}/agentup.sh ${if agentic.enable then reconcileArguments else "--disable"}
      '';
    }
    (lib.mkIf agentic.enable {
      ensureWorkbench = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        set -euo pipefail
        mkdir -p "${config.home.homeDirectory}/workbench"
      '';
    })
  ];
}
