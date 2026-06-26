#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "==> Updating ccline"
nix-update --flake ccline

echo "==> Updating cli-proxy-api"
nix-update --flake cli-proxy-api

echo "==> Updating rime-ice"
nix-update --flake --version=branch=main rime-ice

echo "==> Updating kulala-core"
nix-update --flake kulala-core

echo "==> Updating kulala-fmt"
nix-update --flake kulala-fmt

# echo "==> Updating elegant-theme"
# nix-update --flake --version=branch=main elegant-theme

echo "==> Done"
