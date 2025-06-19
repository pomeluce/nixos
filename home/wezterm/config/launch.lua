local platform = require('utils.platform')()

return {
  default_prog = platform.is_linux and { 'zsh' } or { 'pwsh.exe', '-NoLogo' },
  launch_menu = platform.is_linux and {
    { label = ' Zsh', args = { 'zsh' } },
    { label = ' Bash', args = { 'bash' } },
  } or {
    { label = ' PowerShell v7', args = { 'pwsh', '-NoLogo' } },
    { label = ' PowerShell v1', args = { 'powershell' } },
    { label = ' Cmd', args = { 'cmd' } },
    { label = ' GitBash', args = { 'C:\\User\\lucas\\scoop\\app\\Git\\current\\bash.exe' } },
  },
}
