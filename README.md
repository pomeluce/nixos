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
├── templates/         # Flake templates
│   └── python/        # Python dev environment
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

## Templates

```sh
# Bootstrap a new Python project
nix flake new -t github:Tso/nixos#python ./my-project
cd my-project && nix develop
```

| Template | Description             |
| -------- | ----------------------- |
| python   | Python 3.12 + uv + ruff |

## Key Features

- **Flake-based** — fully reproducible with locked inputs
- **Templates** — bootstrap new projects via `nix flake init`
- **Home Manager** — declarative user environment
- **sops-nix** — encrypted secrets management
- **Custom packages** — personal tools and patched packages

## Secrets

This repository uses [sops-nix](https://github.com/Mic92/sops-nix) with age recipients to manage encrypted secrets.

Secrets are split by category under `secrets/`:

| File                    | Purpose                                         |
| ----------------------- | ----------------------------------------------- |
| `secrets/home.yaml`     | Reserved for future Home Manager scoped secrets |
| `secrets/ssh.yaml`      | SSH private/public key material                 |
| `secrets/ai.yaml`       | AI/API provider keys                            |
| `secrets/vps.yaml`      | VPS connection values                           |
| `secrets/system.yaml`   | System-level secrets                            |
| `secrets/postgres.yaml` | PostgreSQL secrets                              |

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
             - *MARCUS
             - *LTB16P
             - *DLG5
             - *WSN
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
