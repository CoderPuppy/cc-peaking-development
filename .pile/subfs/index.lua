local fn = require('fn')
fn.arr = require('fn-arr')

return function(basePath, fs)
	return function(ctx, path, op, ...)
		return fs(ctx, {unpack(basePath), unpack(path)}, op, ...)
	end
end