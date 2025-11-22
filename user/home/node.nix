{ opts, ... }:
{
  home.file.".npmrc".text = ''
    cache=${opts.devroot}/env/node/npm/node_caches
  '';

  home.file.".yarnrc".text = ''
    registry "https://registry.npmjs.org/"
    cache-folder "${opts.devroot}/env/node/yarn/node_caches"
    global-folder "${opts.devroot}/env/node/yarn/node_modules"
    prefix "${opts.devroot}/env/node/yarn"
  '';

  home.file.".config/pnpm/rc".text = ''
    cache-dir=${opts.devroot}/env/node/pnpm/node_caches
    global-bin-dir=${opts.devroot}/env/node/pnpm/bin
    global-dir=${opts.devroot}/env/node/pnpm/node_modules
    state-dir=${opts.devroot}/env/node/pnpm/node_states
    store-dir=${opts.devroot}/env/node/pnpm
    auto-install-peers=true
  '';
}
