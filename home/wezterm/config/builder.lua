local wezterm = require('wezterm')

--- 配置生成器
---@class ConfigBuilder
---@field options table options
local ConfigBuilder = {}

ConfigBuilder.__index = ConfigBuilder

--- initialize config
---@return ConfigBuilder
function ConfigBuilder:init()
  return setmetatable({ options = {} }, self)
end

--- append to `ConfigBuilder.options`
---@param new_options table new options to append
---@return ConfigBuilder
function ConfigBuilder:append(new_options)
  for k, v in pairs(new_options) do
    if self.options[k] ~= nil then
      wezterm.log_warn('duplicate config option detected: ', { old = self.options[k], new = new_options[k] })
    else
      self.options[k] = v
    end
  end
  return self
end

return ConfigBuilder
