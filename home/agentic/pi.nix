{ config, lib, ... }:
let
  agentic = config.mo.agentic;
in
lib.mkIf (agentic.enable && agentic.pi) {
  programs.pi-coding-agent = {
    enable = true;
  };
}
