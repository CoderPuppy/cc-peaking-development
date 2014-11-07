return function(kernel)
	local namespace = {
		type = 'peak:namespace';

		kernel = kernel;
	}

	function namespace.spawn(opts)
		opts = type(opts) == 'table' and opts or {}

		opts.id = type(opts.id) == 'number' and opts.id or namespace:genPID()

		if type(opts.path) ~= 'table' then error('a path is required (expected table, got ' .. textutils.serialize(opts.path) .. ')', 2) end
		opts.args = type(opts.args) == 'table' and opts.args or {}

		opts.cwd = type(opts.cwd) == 'table' and opts.cwd or {}
		opts.env = type(opts.env) == 'table' and opts.env or {}

		local proc = {
			type = 'peak:process';

			namespace = namespace;
			id = opts.id;
			
			path = opts.path; -- the path of the file to run
			args = opts.args; -- the args

			cwd = opts.cwd; -- current working directory
			env = opts.env; -- environment variables

			handles = {}; -- what file descriptors this has open
			waiting = nil; -- what promise this is waiting on
		}

		--local handle = kernel.fs({}, proc.path, 'open')
		--handle.close()

		return proc
	end

	return namespace
end