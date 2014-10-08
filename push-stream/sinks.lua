function sink(onData, onError)
	if not onError then onError = function(err) error(err, 2) end end
	return function(input)
		input(function(err, data)
			if err then
				onError(err)
			else
				onData(data)
			end
		end)
	end
end

local sinks; sinks = {
	drain = sink;
}; return sinks