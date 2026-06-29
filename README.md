# NixOS Configuration

Personal NixOS configuration managed as a flake, with NixOS system modules, Home Manager user modules, sops-nix secrets, overlays, and reusable project templates.

This repository is written as a semi-public configuration manual: it documents structure, workflows, and module responsibilities, while avoiding secret values, private tokens, and sensitive service details.

## Overview

Key characteristics:

- **Flake-based** — reproducible inputs are pinned in `flake.lock`.
- **flake-parts** — `flake.nix` delegates host generation, overlays, checks, and templates to focused modules.
- **Multi-host** — each host gets both `nixosConfigurations.<host>` and `homeConfigurations.<host>` outputs.
- **Home Manager** — user environment, shells, editors, desktop apps, and dotfiles are declared under `home/`.
- **sops-nix** — encrypted secrets are split by category under `secrets/` and wired into system/home modules.
- **Custom option namespace** — host-specific choices are centralized under `mo.*` in `hosts/options.nix`.
- **Templates** — reusable development templates are exposed through flake templates.

## Repository Layout

```text
.
├── flake.nix              # Flake entry point; wires inputs, hosts, overlays, templates and checks
├── flake.lock             # Locked flake inputs
├── hosts/                 # Host list, shared options, common defaults, host-specific configs
│   ├── hosts.nix          # Declarative host registry used to generate flake outputs
│   ├── default.nix        # Host factory for NixOS + Home Manager outputs
│   ├── options.nix        # Custom mo.* option schema
│   ├── common.nix         # Shared defaults for all hosts
│   ├── LTB16P/            # Laptop / desktop host
│   ├── LTPT14P/           # Workstation / WSL-oriented host
│   └── RACKVPS/           # Server / VPS host
├── home/                  # Home Manager modules
│   ├── default.nix        # Home Manager module entry point
│   ├── ssh.nix            # SSH config and SSH key activation
│   ├── sops.nix           # Home-scoped secrets
│   ├── devspace.nix       # Devspace directory bootstrap
│   ├── claude/            # Claude Code and related AI tooling config
│   ├── terminal/          # Terminal emulator modules
│   ├── maven/             # Maven settings
│   ├── jetbrains/         # JetBrains settings and local support files
│   └── typora/            # Typora config and styles
├── system/                # NixOS modules and services
│   ├── default.nix        # NixOS module entry point
│   ├── modules/           # System feature modules
│   └── services/          # Service modules
├── nix/                   # Nix and nixpkgs configuration
├── overlays/              # Flake overlays
├── templates/             # Flake templates
│   └── python/            # Python 3.12 + uv + ruff template
├── lib/                   # Local helper functions
├── secrets/               # Encrypted sops-nix YAML files
└── README.md              # This document
```

## Architecture

`flake.nix` uses `flake-parts` and imports `./hosts`. The host layer reads `hosts/hosts.nix` and generates one NixOS configuration and one Home Manager configuration per host.

For each host, `hosts/default.nix` creates:

- `nixosConfigurations.<host>` — system-level NixOS configuration.
- `homeConfigurations.<host>` — user-level Home Manager configuration.

The common pattern is:

1. `hosts/hosts.nix` declares which hosts exist and which extra hardware/system modules they need.
2. `hosts/default.nix` maps that list into flake outputs.
3. `hosts/options.nix` defines the custom `mo.*` option namespace.
4. `hosts/common.nix` provides shared defaults.
5. `hosts/<HOST>/default.nix` overrides per-host behavior.
6. `system/default.nix` imports system modules and services.
7. `home/default.nix` imports Home Manager modules.

The flake also exposes:

- `templates` from `templates/default.nix`.
- `overlays` from `overlays/default.nix`.
- `checks.deadnix` for dead code detection.
- `formatter = pkgs.nixfmt`.

## Hosts

| Host      | Role                            | Notes                                               |
| --------- | ------------------------------- | --------------------------------------------------- |
| `LTB16P`  | Laptop / desktop host           | Full desktop-oriented configuration.                |
| `LTPT14P` | Workstation / WSL-oriented host | Lightweight workstation-style host entry.           |
| `RACKVPS` | Server / VPS host               | Server-focused configuration with desktop disabled. |

Host definitions live in `hosts/<HOST>/default.nix`. Hardware configuration files are included where needed through `hosts/hosts.nix`.

## Common Commands

Format the repository:

```sh
nix fmt
```

Run flake checks:

```sh
nix flake check
```

Evaluate a Home Manager configuration:

```sh
nix eval .#homeConfigurations.<host>.activationPackage.drvPath
```

Dry-build a NixOS host:

```sh
nixos-rebuild dry-build --flake .#<host>
```

Switch a NixOS host:

```sh
sudo nixos-rebuild switch --flake .#<host>
```

Apply only Home Manager configuration when needed:

```sh
home-manager switch --flake .#<host>
```

Update flake inputs:

```sh
nix flake update
```

Inspect available flake outputs:

```sh
nix flake show
```

> Flakes only see files tracked by Git or added to the Git index. If a new host directory has not been added yet, commands such as `nix eval` or `nixos-rebuild dry-build` may fail with “Path ... is not tracked by Git”. Run `git add hosts/<HOST>` before evaluating a new host.

## Configuration Model: `mo.*`

Project-specific configuration is centralized under the `mo` option namespace in `hosts/options.nix`. Host files set `mo.*` values instead of scattering conditionals throughout modules.

Main groups:

- `mo.username`, `mo.uid`, `mo.gid`, `mo.devspace` — base user and workspace settings.
- `mo.system` — system services, proxy settings, boot mode, GPU/virtualization options, and extra session variables/paths.
- `mo.desktop` — desktop enablement, window manager selection, display manager, scaling, cursor/icon themes, and wallpaper settings.
- `mo.programs` — program-level settings for terminal, git, SSH, Docker, PostgreSQL, Niri, Neovim, and related tools.
- `mo.userPackages` — host-specific user package list.

SSH-related options include:

- `mo.programs.ssh.enableHost` — controls generation of `~/.ssh/config` from declared hosts.
- `mo.programs.ssh.enableKey` — controls SSH key activation into `~/.ssh`.
- `mo.programs.ssh.hosts` — declarative SSH host entries.
- `mo.programs.ssh.ports` — SSH ports used by firewall/service modules.

## System Modules

`system/default.nix` is the system module entry point. It imports modules in several groups.

### Base modules

| Module                      | Purpose                                                 |
| --------------------------- | ------------------------------------------------------- |
| `system/user.nix`           | User and group setup.                                   |
| `system/packages.nix`       | System packages and package-related system files.       |
| `system/env.nix`            | System-wide environment variables.                      |
| `system/locale.nix`         | Locale configuration.                                   |
| `system/modules/boot.nix`   | Bootloader configuration, including EFI/BIOS selection. |
| `system/modules/opengl.nix` | Graphics/OpenGL configuration.                          |
| `system/modules/gc.nix`     | Nix garbage collection settings.                        |
| `system/modules/sops.nix`   | System-scoped sops-nix configuration.                   |

### Feature modules

| Module                         | Purpose                                            |
| ------------------------------ | -------------------------------------------------- |
| `system/modules/bluetooth.nix` | Bluetooth support.                                 |
| `system/modules/nvidia.nix`    | NVIDIA/GPU-related configuration.                  |
| `system/modules/steam.nix`     | Steam support.                                     |
| `system/modules/docker.nix`    | Docker configuration.                              |
| `system/modules/virt.nix`      | Virtualization configuration.                      |
| `system/modules/wsl.nix`       | WSL integration.                                   |
| `system/modules/desktop/`      | Desktop and window-manager related system modules. |
| `system/modules/xdg.nix`       | XDG/system integration.                            |

### Service modules

| Module                          | Purpose                              |
| ------------------------------- | ------------------------------------ |
| `system/services/pipewire.nix`  | PipeWire audio stack.                |
| `system/services/upower.nix`    | Power-related service support.       |
| `system/services/keyd.nix`      | Keyboard remapping service.          |
| `system/services/xserver.nix`   | X server / display related settings. |
| `system/services/postgres.nix`  | PostgreSQL service configuration.    |
| `system/services/others.nix`    | Miscellaneous services.              |
| `system/services/mihomo.nix`    | Proxy service configuration.         |
| `system/services/wallpaper.nix` | Wallpaper service integration.       |
| `system/services/firewall.nix`  | Firewall settings.                   |

## Home Modules

`home/default.nix` is the Home Manager entry point. It imports user-level modules for shells, development tools, desktop apps, and integrations.

### Shell and development tools

| Module            | Purpose                                          |
| ----------------- | ------------------------------------------------ |
| `home/zsh.nix`    | Zsh shell configuration.                         |
| `home/direnv.nix` | direnv integration.                              |
| `home/git.nix`    | Git user and behavior configuration.             |
| `home/node.nix`   | Node.js package manager settings.                |
| `home/uv.nix`     | uv / Python tooling support.                     |
| `home/maven/`     | Maven settings.                                  |
| `home/nvim.nix`   | Neovim configuration bridge through flake input. |

### Desktop and applications

| Module                | Purpose                                     |
| --------------------- | ------------------------------------------- |
| `home/firefox.nix`    | Firefox configuration.                      |
| `home/fcitx5/`        | Input method configuration.                 |
| `home/fonts.nix`      | User font configuration.                    |
| `home/hypr.nix`       | Hyprland user configuration.                |
| `home/niri.nix`       | Niri user configuration.                    |
| `home/noctalia.nix`   | Noctalia desktop shell configuration.       |
| `home/terminal/`      | Terminal emulator configuration.            |
| `home/typora/`        | Typora settings and CSS.                    |
| `home/jetbrains/`     | JetBrains settings and local support files. |
| `home/theme.nix`      | Theme-related settings.                     |
| `home/xsettingsd.nix` | XSettings daemon configuration.             |

### Integrations

| Module               | Purpose                                           |
| -------------------- | ------------------------------------------------- |
| `home/claude/`       | Claude Code and related AI tooling configuration. |
| `home/sops.nix`      | Home-scoped sops-nix secrets.                     |
| `home/ssh.nix`       | SSH config generation and SSH key activation.     |
| `home/devspace.nix`  | Creates the devspace directory layout.            |
| `home/fastfetch.nix` | fastfetch configuration.                          |

## Secrets

This repository uses [sops-nix](https://github.com/Mic92/sops-nix) with age recipients to manage encrypted secrets.

Secrets are split by category under `secrets/`:

| File                    | Purpose                          |
| ----------------------- | -------------------------------- |
| `secrets/home.yaml`     | Home Manager scoped secrets.     |
| `secrets/ssh.yaml`      | SSH private/public key material. |
| `secrets/ai.yaml`       | AI/API provider keys.            |
| `secrets/vps.yaml`      | VPS connection values.           |
| `secrets/system.yaml`   | System-level secrets.            |
| `secrets/postgres.yaml` | PostgreSQL secrets.              |

`.sops.yaml` matches `secrets/*.yaml`, so new encrypted YAML files under `secrets/` use the configured age recipients automatically.

### Add a new machine or age recipient

1. Generate or locate the machine's age public key.

   If the machine uses an age key directly:

   ```sh
   age-keygen -y /path/to/key.txt
   ```

   If the machine uses an SSH host/user key as the age identity, convert the SSH public key with `ssh-to-age`:

   ```sh
   nix shell nixpkgs#ssh-to-age -c ssh-to-age -i /path/to/id_ed25519.pub
   ```

2. Add the public key to `.sops.yaml`:

   ```yaml
   keys:
     - &NEW_HOST age1...
   ```

3. Add the new anchor to the `key_groups.age` list:

   ```yaml
   creation_rules:
     - path_regex: ^secrets/.*\.yaml$
       key_groups:
         - age:
             - *EXISTING_RECIPIENT
             - *NEW_HOST
   ```

4. Rotate/re-encrypt existing secret files so the new recipient can decrypt them:

   ```sh
   for f in secrets/*.yaml; do
     sops updatekeys --yes "$f"
   done
   ```

### Create a new secrets YAML file

1. Create a new YAML file under `secrets/`:

   ```sh
   sops secrets/example.yaml
   ```

2. Add the secret keys in the editor:

   ```yaml
   EXAMPLE_TOKEN: 'replace-with-secret'
   ```

3. Save and close the editor. SOPS writes encrypted values and a `sops:` metadata block.

4. Reference the file from Nix with `sopsFile`:

   ```nix
   sops.secrets.EXAMPLE_TOKEN.sopsFile = ../secrets/example.yaml;
   ```

   From modules under `system/`, adjust the relative path accordingly:

   ```nix
   sops.secrets.EXAMPLE_TOKEN.sopsFile = ../../secrets/example.yaml;
   ```

### Use secrets in Nix modules

Each module may set one default SOPS file:

```nix
sops.defaultSopsFile = ../secrets/home.yaml;
```

Secrets in the default file can be declared directly:

```nix
sops.secrets.MY_SECRET = { };
```

Secrets from another YAML file should specify `sopsFile` explicitly:

```nix
sops.secrets.OPENROUTER_API_KEY.sopsFile = ../secrets/ai.yaml;
```

The decrypted secret is exposed by sops-nix as a file path, usually through:

```nix
config.sops.secrets.OPENROUTER_API_KEY.path
```

For system services, set ownership and mode when needed:

```nix
sops.secrets.PG_INITIAL = {
  sopsFile = ../../secrets/postgres.yaml;
  mode = "0400";
  owner = config.users.users.postgres.name;
};
```

### Edit or decrypt secrets

Edit a secret file safely:

```sh
sops secrets/ai.yaml
```

Decrypt to stdout for inspection:

```sh
sops --decrypt secrets/ai.yaml
```

Check that all secret files are decryptable without printing their contents:

```sh
for f in secrets/*.yaml; do
  sops --decrypt "$f" >/dev/null
done
```

After changing secret wiring, verify the flake:

```sh
nix flake check
```

## Templates

The flake exposes project templates through `templates/default.nix`.

Bootstrap a new Python project:

```sh
nix flake new -t github:pomeluce/nixos#python ./my-project
cd my-project
nix develop
```

| Template | Description                                     |
| -------- | ----------------------------------------------- |
| `python` | Python 3.12 development shell with uv and ruff. |

## Adding a New Host

1. Create a host directory:

   ```sh
   mkdir -p hosts/<HOST>
   ```

2. Add `hosts/<HOST>/default.nix` with host-specific `mo.*` values.

3. Add `hosts/<HOST>/hardware-configuration.nix` if the host needs a hardware config imported by NixOS.

4. Register the host in `hosts/hosts.nix`:

   ```nix
   {
     host = "<HOST>";
     extraOSModules = [ ./<HOST>/hardware-configuration.nix ];
   }
   ```

   For hosts without a hardware configuration file, provide the required platform module directly:

   ```nix
   {
     host = "<HOST>";
     extraOSModules = [ { nixpkgs.hostPlatform = "x86_64-linux"; } ];
   }
   ```

5. If the host must decrypt secrets, add its age recipient to `.sops.yaml` and rotate keys:

   ```sh
   for f in secrets/*.yaml; do
     sops updatekeys --yes "$f"
   done
   ```

6. Add the new files to Git before evaluating the flake:

   ```sh
   git add hosts/<HOST>
   ```

7. Verify the new host:

   ```sh
   nix eval .#homeConfigurations.<HOST>.activationPackage.drvPath
   nixos-rebuild dry-build --flake .#<HOST>
   ```

## Maintenance Workflow

Recommended local workflow before switching or committing:

1. Format files:

   ```sh
   nix fmt
   ```

2. Run flake checks:

   ```sh
   nix flake check
   ```

3. Evaluate Home Manager outputs for changed hosts:

   ```sh
   nix eval .#homeConfigurations.<host>.activationPackage.drvPath
   ```

4. Dry-build NixOS outputs for changed hosts:

   ```sh
   nixos-rebuild dry-build --flake .#<host>
   ```

5. Switch on the target machine:

   ```sh
   sudo nixos-rebuild switch --flake .#<host>
   ```

6. Review the diff and commit:

   ```sh
   git diff --stat
   git status
   git commit
   ```

When renaming a host, update all of these together:

- `hosts/hosts.nix`
- `hosts/<OLD_HOST>/` → `hosts/<NEW_HOST>/`
- `.sops.yaml` recipient names if the host recipient name changes
- Any documentation references

Remember to stage new or renamed host directories before running flake evaluation.

