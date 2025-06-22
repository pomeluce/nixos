{ pkgs, ... }:
{
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "small",
        "color": {
          "1": "cyan",
          "2": "default",
        },
      },
      "modules": [
        {
          "key": " OS ",
          "type": "os",
          "keyColor": "red",
        },
        {
          "key": " VER",
          "type": "kernel",
          "format": "{2}",
          "keyColor": "green",
        },
        {
          "key": " UP ",
          "type": "uptime",
          "keyColor": "yellow",
        },
        {
          "key": " PKG",
          "type": "packages",
          "keyColor": "blue",
        },
        {
          "key": "󰻠 CPU",
          "type": "cpu",
          "keyColor": "magenta",
        },
        {
          "key": " GPU",
          "type": "gpu",
          "format": "{1} {2}",
          "hideType": "integrated",
          "keyColor": "cyan",
        },
        {
          "key": "󰍛 MEM",
          "type": "memory",
          "keyColor": "white",
        },
      ],
    }
  '';

  home.packages = with pkgs; [
    fastfetch
  ];
}
