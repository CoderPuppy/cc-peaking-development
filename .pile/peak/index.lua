local mountfs = require('mountfs')
local namespace = require('./namespace')

return function(opts)
	opts = type(opts) == 'table' and opts or {}

	local self = {}

	self.fs = mountfs()
	self.namespace = namespace(self)
	self.state = 'stopped'

	function self.boot(initPath)
		if self.state ~= 'stopped' then
			error('Can only boot from stopped, state = ' .. state, 2)
		end
		if type(initPath) ~= 'table' then
			error('initPath must be a table', 2)
		end

		self.namespace:spawn{
			id = 0;
			path = initPath;
		}
	end

	return self
end