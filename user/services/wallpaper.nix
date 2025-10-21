{ pkgs, opts, ... }:
{
  environment.systemPackages = [
    (pkgs.writeScriptBin "wallpaper-daemon" ''
      set -euo pipefail

      IMG_DIR="${opts.system.wallpaper.dir}"
      STATE_FILE="$HOME/.cache/wallpaper"
      INTERVAL=${toString opts.system.wallpaper.interval}

      if [ ! -d "$IMG_DIR" ]; then
        echo "Error: IMG_DIR '$IMG_DIR' not found." >&2
        exit
      fi

      img_count=$(find "$IMG_DIR" -maxdepth 1 -type f \( -iname '*jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | wc -l)
      if [ "$img_count" -eq 0 ]; then
        echo "Error: no images found in '$IMG_DIR'." >&2
        exit
      fi

      mkdir -p "$(dirname "$STATE_FILE")"

      if ! pgrep -x swww-daemon >/dev/null; then
        swww-daemon &
        sleep 1
      fi

      # 收集并排序图片列表
      mapfile -t IMAGES < <(find "$IMG_DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | sort)


      if [ ''${#IMAGES[@]} -eq 0 ]; then
        echo "No images found in $IMG_DIR" >&2
        exit
      fi

      # 计算起始索引
      if [ -f "$STATE_FILE" ]; then
        last="$(<"$STATE_FILE")"
        idx=-1
        for i in "''${!IMAGES[@]}"; do
          [ "''${IMAGES[i]##*/}" = "$last" ] && idx=$i && break
        done
        idx=$(( idx + 1 ))
        [ $idx -ge ''${#IMAGES[@]} ] && idx=0
      else
        idx=0
      fi

      # 开始循环
      while true; do
        img="''${IMAGES[idx]}"
        name="''${img##*/}"

        # 切换壁纸
        swww img --transition-type grow --transition-fps ${toString opts.system.wallpaper.fps} "$img"

        # 记录当前文件名
        echo "$name" > "$STATE_FILE"

        idx=$(( (idx + 1) % ''${#IMAGES[@]} ))

        sleep "$INTERVAL"
      done
    '')
    pkgs.swww
  ];
}
