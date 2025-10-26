{ pkgs, ... }:
{
  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "type": "small",
        "color": {
          "1": "cyan",
          "2": "green",
        },
      },
      "display": {
        "separator": " "
      },
      "modules": [
        {
          "key": "╭─󰌢 ",
          "type": "host",
          "keyColor": "magenta"
        },
        {
          "key": "├─ ",
          "type": "os",
          "keyColor": "magenta",
        },
        {
          "key": "├─ ",
          "type": "kernel",
          "keyColor": "magenta",
        },
        {
          "key": "├─󰮯 ",
          "type": "packages",
          "keyColor": "magenta",
        },
        {
          "key": "├─󱑍 ",
          "type": "uptime",
          "keyColor": "magenta",
        },
        {
          "key": "├─󰻠 ",
          "type": "cpu",
          "keyColor": "magenta",
        },
        {
          "key": "╰─󱤏 ",
          "type": "gpu",
          "format": "{1} {2}",
          "hideType": "integrated",
          "keyColor": "magenta",
        },
      ],
    }
  '';

  home.packages = with pkgs; [
    fastfetch
  ];
}
