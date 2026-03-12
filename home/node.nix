{ config, ... }:
let
  mo = config.mo;
in
{
  home.file.".npmrc".text = ''
    cache=${mo.devroot}/env/node/npm/node_caches
  '';

  home.file.".yarnrc".text = ''
    registry "https://registry.npmjs.org/"
    cache-folder "${mo.devroot}/env/node/yarn/node_caches"
    global-folder "${mo.devroot}/env/node/yarn/node_modules"
    prefix "${mo.devroot}/env/node/yarn"
  '';

  home.file.".config/pnpm/rc".text = ''
    cache-dir=${mo.devroot}/env/node/pnpm/node_caches
    global-bin-dir=${mo.devroot}/env/node/pnpm/bin
    global-dir=${mo.devroot}/env/node/pnpm/node_modules
    state-dir=${mo.devroot}/env/node/pnpm/node_states
    store-dir=${mo.devroot}/env/node/pnpm
    auto-install-peers=true
  '';
}
