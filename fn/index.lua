return function(v, ...)
	local ops = {...}
	for _, op in ipairs(ops) do
		v = op(v)
	end
	return v
end