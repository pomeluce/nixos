{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "hid-access";
      runtimeInputs = [
        pkgs.acl
        pkgs.coreutils
      ];
      text = ''
        export LC_ALL=C

        usage() {
          cat <<'EOF'
        Usage:
          hid-access --list
          hid-access VID:PID
          hid-access --revoke VID:PID

        Options:
          --list      List connected USB HID nodes
          --revoke    Remove the current user's named ACL entry
          -h, --help  Show this help

        Run without sudo; ACL changes request sudo authentication internally.
        All connected devices with the same VID:PID are matched.
        Access lasts until the device node is recreated, its ACL changes, or --revoke.
        Revoking does not restore an earlier ACL or close already-open connections.
        EOF
        }

        # Search the USB ancestors, rather than assuming a fixed sysfs depth.
        find_usb_id() {
          local path vendor product

          path="$(readlink -e "$1/device")" || return 1

          while [[ "$path" != "/" ]]; do
            if [[ -r "$path/idVendor" && -r "$path/idProduct" ]]; then
              read -r vendor <"$path/idVendor" || return 1
              read -r product <"$path/idProduct" || return 1
              printf '%s:%s\n' "''${vendor,,}" "''${product,,}"
              return 0
            fi

            path="''${path%/*}"
            [[ -n "$path" ]] || path="/"
          done

          return 1
        }

        action="grant"

        case "''${1:-}" in
        --list | -h | --help)
          if [[ $# -ne 1 ]]; then
            usage >&2
            exit 2
          fi
          if [[ "$1" != "--list" ]]; then
            usage
            exit 0
          fi
          printf '%-12s %s\n' "VID:PID" "DEVICE"
          for entry in /sys/class/hidraw/hidraw*; do
            [[ -c "/dev/''${entry##*/}" ]] || continue
            if usb_id="$(find_usb_id "$entry")"; then
              printf '%-12s /dev/%s\n' "$usb_id" "''${entry##*/}"
            fi
          done
          exit 0
          ;;
        --revoke)
          action="revoke"
          shift
          ;;
        esac

        if [[ $# -ne 1 ]]; then
          usage >&2
          exit 2
        fi

        if [[ ! "$1" =~ ^([[:xdigit:]]{4}):([[:xdigit:]]{4})$ ]]; then
          echo "Invalid VID:PID, expected XXXX:XXXX" >&2
          exit 2
        fi

        target="''${BASH_REMATCH[1],,}:''${BASH_REMATCH[2],,}"

        if [[ "$EUID" -eq 0 ]]; then
          echo "Run hid-access without sudo." >&2
          exit 1
        fi

        nodes=()
        for entry in /sys/class/hidraw/hidraw*; do
          [[ -c "/dev/''${entry##*/}" ]] || continue
          if usb_id="$(find_usb_id "$entry")" && [[ "$usb_id" == "$target" ]]; then
            nodes+=("/dev/''${entry##*/}")
          fi
        done

        if ((''${#nodes[@]} == 0)); then
          echo "No connected HID device found for $target" >&2
          exit 1
        fi

        uid="$(id -u)"
        setfacl_bin="$(command -v setfacl)"

        printf 'Matched %s:\n' "$target"
        printf '  %s\n' "''${nodes[@]}"

        # Authenticate before rechecking nodes: a password prompt can take a while.
        /run/wrappers/bin/sudo -v
        for node in "''${nodes[@]}"; do
          if [[ ! -c "$node" ]] ||
            ! usb_id="$(find_usb_id "/sys/class/hidraw/''${node##*/}")" ||
            [[ "$usb_id" != "$target" ]]; then
            echo "Device changed or disconnected: $node; run hid-access again." >&2
            exit 1
          fi
        done

        # NixOS needs its setuid sudo wrapper, not the unwrapped nixpkgs binary.
        if [[ "$action" == "grant" ]]; then
          /run/wrappers/bin/sudo -n -- "$setfacl_bin" -m "u:$uid:rw" -- "''${nodes[@]}"
          echo "Read/write access granted to UID $uid."
        else
          /run/wrappers/bin/sudo -n -- "$setfacl_bin" --no-mask -x "u:$uid" -- "''${nodes[@]}"
          echo "Named ACL entry removed for UID $uid; existing connections remain open."
        fi
      '';
    })
  ];
}
