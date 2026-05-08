#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Updating cli-proxy-api"
nix-update --flake cli-proxy-api

echo "==> Updating perry"
nix-update --flake perry

echo "==> Updating rime-ice"
nix-update --flake --version=branch=main rime-ice

echo "==> Updating elegant-theme"
nix-update --flake --version=branch=main elegant-theme

echo "==> Done"

