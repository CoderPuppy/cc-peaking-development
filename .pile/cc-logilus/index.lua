local textEscapes = require('cc-text-escapes')
local logilus     = require('logilus')

return function(redirect)
	return logilus(function(self, level, str, ...)
		local old
		if type(redirect) == 'table' then
			old = term.redirect(redirect)
		end
		textEscapes.print(logilus.format(str, ...))
		if type(redirect) == 'table' then
			term.redirect(old)
		end
	end)
end