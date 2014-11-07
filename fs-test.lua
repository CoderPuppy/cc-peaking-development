#!/bin/pile
local cfs = require('cc-fs')(fs)
local fs = require('mountfs')()
fs.mount({}, require('subfs')({'kernel-fs'}, cfs))
local Promise = require('promise')

function stat(path)
	Promise(
		fs({}, path, 'stat'),
		Promise.map(function(stat)
			print('/', table.concat(path, '/'), ' - ', textutils.serialize(stat))
		end),
		Promise.orError()
	)
end

function read(path)
	Promise(
		fs({}, path, 'open', {
			read = true;
		}),
		Promise.flatMap(function(handle)
			return Promise(
				handle.read('*a'),
				Promise.flatMap(function(data)
					print('--[===[', '/', table.concat(path, '/'), ']===]')
					print(data)
					return handle.close()
				end)
			)
		end),
		Promise.orError()
	)
end

local initPath = {'boot', 'init'}
local docPath = {'.pile', 'peak', 'doc', 'design.md'}

stat(docPath)
fs.mount({'.pile', 'peak', 'doc'}, require('subfs')({'peak-doc'}, cfs))
stat(docPath)