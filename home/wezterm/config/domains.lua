local platform = require('utils.platform')()

return {
  default_domain = platform.is_windows and 'WSL:ArchLinux' or 'local',
  ssh_domains = {},
  wsl_domains = {
    {
      name = 'WSL:ArchLinux',
      distribution = 'ArchLinux',
      username = 'lucas',
      default_cwd = '/home/lucas',
      default_prog = { 'zsh', '--login' },
    },
  },
}
