{ config, lib, ... }:
let
  agentic = config.mo.agentic;
  agentsFile = config.lib.file.mkOutOfStoreSymlink "${config.mo.devspace}/repos/nixos/home/agentic/.agents/AGENTS.md";
in
{
  imports = [
    ./ccswitch.nix
    ./claude
    ./codex.nix
    ./pi.nix
  ];

  home.file = lib.mkMerge [
    (lib.mkIf agentic.enable {
      ".agents/AGENTS.md".source = agentsFile;
    })
    (lib.mkIf (agentic.enable && agentic.claude) {
      ".claude/CLAUDE.md".source = agentsFile;
    })
    (lib.mkIf (agentic.enable && agentic.codex) {
      ".codex/AGENTS.md".source = agentsFile;
    })
    (lib.mkIf (agentic.enable && agentic.pi) {
      ".pi/agent/AGENTS.md".source = agentsFile;
    })
  ];
}
