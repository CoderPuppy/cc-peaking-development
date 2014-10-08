return function(fn)
	return setmetatable({}, { __call = fn })
end