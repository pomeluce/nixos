{ config, ... }:
let
  mo = config.mo;
in
{
  home.file.".npmrc".text = ''
    cache=${mo.devroot}/var/node/npm/node_caches
  '';

  home.file.".yarnrc".text = ''
    registry "https://registry.npmjs.org/"
    cache-folder "${mo.devroot}/var/node/yarn/node_caches"
    global-folder "${mo.devroot}/var/node/yarn/node_modules"
    prefix "${mo.devroot}/var/node/yarn"
  '';

  home.file.".config/pnpm/rc".text = ''
    cache-dir=${mo.devroot}/var/node/pnpm/node_caches
    global-bin-dir=${mo.devroot}/var/node/pnpm/bin
    global-dir=${mo.devroot}/var/node/pnpm/node_modules
    state-dir=${mo.devroot}/var/node/pnpm/node_states
    store-dir=${mo.devroot}/var/node/pnpm
    auto-install-peers=true
  '';
}
