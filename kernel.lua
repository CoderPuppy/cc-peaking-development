#!/bin/pile
local peak = require('peak'){}
peak.fs.mount('/', require('subfs')({'kernel-fs'}, require('cc-fs')(fs)))
peak.fs.mount('/proc', require('peak-procfs')(peak.namespace))
--peak.fs({}, {'proc'}, 'delete')
--peak.boot({'boot', 'init'})