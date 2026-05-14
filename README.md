# NixOS Configuration

My NixOS configuration, flake-based and managed with home-manager.

```
├── flake.nix          # Flake entry point
├── hosts/             # Host-specific configurations
│   ├── LTB16P/        # Laptop
│   └── WSN/           # Workstation
├── home/              # Home Manager modules
├── system/            # System-level modules & services
├── pkgs/              # Custom packages
├── overlays/          # Package overlays
├── lib/               # Helper functions
└── nix/               # Nix configuration
```

## Hosts

| Host   | Type        |
| ------ | ----------- |
| LTB16P | Laptop      |
| WSN    | Workstation |

## Deploy

```sh
sudo nixos-rebuild switch --flake .#<host>
```

## Key Features

- **Flake-based** — fully reproducible with locked inputs
- **Home Manager** — declarative user environment
- **sops-nix** — encrypted secrets management
- **Custom packages** — personal tools and patched packages

