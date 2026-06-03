{ config, ... }:
let
  mo = config.mo;
in
{
  home.file.".npmrc".text = ''
    cache=${mo.devspace}/var/node/npm/node_caches
  '';

  home.file.".yarnrc".text = ''
    registry "https://registry.npmjs.org/"
    cache-folder "${mo.devspace}/var/node/yarn/node_caches"
    global-folder "${mo.devspace}/var/node/yarn/node_modules"
    prefix "${mo.devspace}/var/node/yarn"
  '';

  home.file.".config/pnpm/rc".text = ''
    cache-dir=${mo.devspace}/var/node/pnpm/node_caches
    global-bin-dir=${mo.devspace}/var/node/pnpm/bin
    global-dir=${mo.devspace}/var/node/pnpm/node_modules
    state-dir=${mo.devspace}/var/node/pnpm/node_states
    store-dir=${mo.devspace}/var/node/pnpm
    auto-install-peers=true
  '';
}
