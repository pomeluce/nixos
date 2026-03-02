[
  {
    host = "LTB16P";
    extraOSModules = [ ./LTB16P/hardware-configuration.nix ];
  }
  {
    host = "WSN";
    extraOSModules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ];
  }
]
