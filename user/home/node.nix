{ opts, ... }:
{
  home.file.".npmrc".text = ''
    cache=${opts.devroot}/env/node/npm/node_caches
    store-dir=${opts.devroot}/env/node/pnpm
    global-bin-dir=${opts.devroot}/env/node/pnpm/bin
    cache-dir=${opts.devroot}/env/node/pnpm/node_caches
    state-dir=${opts.devroot}/env/node/pnpm/node_states
    global-dir=${opts.devroot}/env/node/pnpm/node_modules
    auto-install-peers=true
  '';

  home.file.".yarnrc".text = ''
    registry "https://registry.npmjs.org/"
    cache-folder "${opts.devroot}/env/node/yarn/node_caches"
    global-folder "${opts.devroot}/env/node/yarn/node_modules"
    prefix "${opts.devroot}/env/node/yarn"
  '';
}
