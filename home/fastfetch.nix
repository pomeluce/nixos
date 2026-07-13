{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
        color = {
          "1" = "cyan";
          "2" = "green";
        };
      };
      display = {
        separator = " ";
      };
      modules = [
        {
          key = "╭─󰌢 ";
          type = "host";
          keyColor = "magenta";
        }
        {
          key = "├─ ";
          type = "os";
          keyColor = "magenta";
        }
        {
          key = "├─ ";
          type = "kernel";
          keyColor = "magenta";
        }
        {
          key = "├─󰮯 ";
          type = "packages";
          keyColor = "magenta";
        }
        {
          key = "├─󱑍 ";
          type = "uptime";
          keyColor = "magenta";
        }
        {
          key = "├─󰻠 ";
          type = "cpu";
          keyColor = "magenta";
        }
        {
          key = "╰─󱤏 ";
          type = "gpu";
          format = "{1} {2}";
          hideType = "integrated";
          keyColor = "magenta";
        }
      ];
    };
  };
}
