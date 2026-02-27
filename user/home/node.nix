{ sysConfig, ... }:
let
  cfg = sysConfig.myOptions;
in
{
  home.file.".npmrc".text = ''
    cache=${cfg.devroot}/env/node/npm/node_caches
  '';

  home.file.".yarnrc".text = ''
    registry "https://registry.npmjs.org/"
    cache-folder "${cfg.devroot}/env/node/yarn/node_caches"
    global-folder "${cfg.devroot}/env/node/yarn/node_modules"
    prefix "${cfg.devroot}/env/node/yarn"
  '';

  home.file.".config/pnpm/rc".text = ''
    cache-dir=${cfg.devroot}/env/node/pnpm/node_caches
    global-bin-dir=${cfg.devroot}/env/node/pnpm/bin
    global-dir=${cfg.devroot}/env/node/pnpm/node_modules
    state-dir=${cfg.devroot}/env/node/pnpm/node_states
    store-dir=${cfg.devroot}/env/node/pnpm
    auto-install-peers=true
  '';
}
