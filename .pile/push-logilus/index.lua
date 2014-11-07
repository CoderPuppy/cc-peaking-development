local logilus = require('logilus')
local push    = require('push-stream')

return function(log, level)
	if log then
		if type(level) ~= 'string' then level = 'info' end
		return function(input)
			input(function(err, data)
				if err then
					log('error', err)
				else
					log(level, unpack(data))
				end
			end)
		end
	else
		local stream, emit = push.source()
		local log; log = logilus(function(self, level, str, ...)
			local args = {...}
			emit(nil, { str, args, function()
				return logilus.format(str, unpack(args))
			end })
		end)
		log.stream = stream
		return log
	end
end