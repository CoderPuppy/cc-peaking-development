local debug = require('debug')

local morefun = require('morefun')
local arr     = require('fn-arr')

local push; push = morefun(function(self, first, ...)
	local streams = {...}

	function start(first)
		return arr.reduce(function(acc, stream)
			return stream(acc)
		end, first)(streams)
	end

	if push.source.is(first) then
		return start(first)
	else
		return function(input)
			return start(first(input))
		end
	end
end)

push.source = morefun(function(self)
	local handlers = {}

	local self = morefun(function(self, handler)
		handlers[#handlers + 1] = handler
		local off = morefun(function()
			if arr.contains(handler)(handlers) then
				table.remove(handlers, arr.indexOf(handler)(handlers))
			end
			return self
		end)
		off.source = self
		return off
	end)
	self.source = self
	self.watch  = self

	local function emit(err, data)
		if debug then
			print('-- source.emit')
			print('err = ' .. type(err) .. ' - ' .. tostring(err))
			print('data = ' .. type(data) .. ' - ' .. tostring(data))
		end

		if err then
			for _, handler in ipairs(handlers) do
				handler(err)
			end
			if handlers.length == 0 then
				error(err)
			end
		else
			for _, handler in ipairs(handlers) do
				handler(nil, data)
			end
		end

		return self
	end

	return self, emit
end)
local function isCallable(v)
	if type(v) == 'function' then return true end
	if type(v) ~= 'table' then return false end
	local mt = getmetatable(v)
	return mt and isCallable(mt.__call)
end
push.source.is = function(stream)
	return type(stream) == 'table' and isCallable(stream) and isCallable(stream.watch)
end

return push