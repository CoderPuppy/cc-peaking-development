local log = require('cc-logilus')()
local textEscapes = require('cc-text-escapes')

log:info('Hello ' .. textEscapes.textYellow .. '{}' .. textEscapes.reset .. '!', 'World')