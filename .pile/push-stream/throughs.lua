local debug = require('debug')

local push = require('./core')

function through(onData)
	return function(input)
		local out, emit = push.source()
		input(function(err, data)
			if debug then
				print('-- through')
				print('err = ' .. type(err) .. ' - ' .. tostring(err))
				print('data = ' .. type(data) .. ' - ' .. tostring(data))
			end

			if err then
				emit(err)
			else
				onData(data, emit)
			end
		end)
		return out
	end
end

local throughs; throughs = {
	map = function(fn)
		return through(function(data, emit)
			if debug then
				print('-- map')
				print('data = ' .. type(data) .. ' - ' .. tostring(data))
				local res = fn(data)
				print('res = ' .. type(res) .. ' - ' .. tostring(res))
			end

			emit(nil, fn(data))
		end)
	end;

	filter = function(fn)
		return through(function(data, emit)
			if fn(data) then
				emit(nil, data)
			end
		end)
	end;
}; return throughs