local morefun = require('morefun')

local logilus = morefun(function(self, fn)
	local log = morefun(function(self, level, str, ...)
		local args = {...}
		if type(level) ~= 'string' then error('level must be a string, got: ' .. level) end
		if type(str) ~= 'string' then
			table.insert(args, 1, str)
			str = ''
		end
		-- this should have no result
		fn(self, level, str, unpack(args))
	end)

	for _, level in ipairs({ 'error', 'warn', 'info', 'debug', 'trace' }) do
		log[level] = function(self, ...)
			log(level, ...)
		end
	end

	return log
end)

logilus.format = function(str, ...)
	local args = {...}
	local index = 1
	local res = str:match('^([^{]*)')
	for text in str:gmatch('{}([^{]*)') do
		res = res .. args[index]
		index = index + 1
		res = res .. text
	end
	return res
end

return logilus