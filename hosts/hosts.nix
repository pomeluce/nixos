[
  {
    host = "LTB16P";
    extraOSModules = [ ./LTB16P/hardware-configuration.nix ];
  }
  {
    host = "LTPT14P";
    extraOSModules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ];
  }
  {
    host = "RACKVPS";
    extraOSModules = [ ./RACKVPS/hardware-configuration.nix ];
  }
]
