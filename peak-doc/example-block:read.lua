local sys; sys = setmetatable({}, {
	__index = function(self, group)
		return setmetatable({}, {
			__index = function(self, name)
				local function op(...)
					return coroutine.yield(group, name, ...)
				end

				if name:sub(1, 2) == 'do' then
					name = name[1]:lower() .. name:sub(2):lower()
					return function(self, ...)
						return sys.wait(op(...))
					end
				else
					return op
				end
			end
		})
	end
})

local err, fd = sys.file.doOpen({'boot', 'init'}, { read = true; })
local err, data = sys.block.doRead(fd)
print(data)
sys.file.doClose(fd)