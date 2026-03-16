local builder = require('config.builder')

require('events.startup').setup()

return builder
  :init()
  :append(require('config.appearance'))
  :append(require('config.bindings'))
  :append(require('config.domains'))
  :append(require('config.fonts'))
  :append(require('config.general'))
  :append(require('config.launch')).options
