local Promise = require('promise')

local fn = require('fn')
fn.arr = require('fn-arr')

return function(cfs)
	return function(ctx, path, op, ...)
		local pathStr = fn(path, fn.arr.join('/'))
		return (({
			open = function(mode)
				if type(mode) ~= 'table' then return Promise.resolved(false, 'mode must be a table') end
				local chandle
				do
					local cmode
					if mode.read and mode.write then
						error('how can read y write at time that is equal')
					elseif mode.read then
						cmode = 'r'
					elseif mode.write then
						cmode = 'w'
					else
						error('huh wha')
					end
					if mode.binary then
						cmode = cmode .. 'b'
					end
					chandle = cfs.open(pathStr, cmode)
				end
				local handle = {}
				function handle.close()
					chandle.close()
					return Promise.resolved(true)
				end

				if cfs.isDir(pathStr) then
				else
					local offset = 0

					if mode.read then
						local done = false
						local data = ''
						function handle.read(length)
							if length == '*l' then
								length = data:find('\n', offset, true)
								if not length and not done then
									local read = chandle.readLine()
									if read then
										if #data == 0 then
											data = tostring(read)
										else
											data = data .. '\n' .. read
										end
										length = data:find('\n', offset, true)
										if not length then
											length = #data - offset
										end
									else
										length = 0
										done = true
									end
								end
							end

							if length == '*a' then
								if not done then
									local read = chandle.readAll()
									if read then
										data = data .. read
									else
										done = true
									end
								end
								length = #data - offset
							end

							if type(length) == 'number' then
								return Promise.resolved(true, data:sub(offset + 1, offset + length + 1))
							else
								return Promise.resolved(false, 'Length must be a \'*l\', \'*a\' or a number, got: ' .. tostring(length))
							end
						end
					end
				end

				return Promise.resolved(true, handle)
			end;

			stat = function()
				local stat = {}
				if cfs.exists(pathStr) then
					stat.exists = true
					stat.type = cfs.isDir(pathStr) and 'directory' or 'block'
				else
					stat.exists = false
				end
				--print('cc-fs stat[/', table.concat(path, '/'),'] = ', textutils.serialize(stat))
				-- TODO: owner, perms
				return Promise.resolved(true, stat)
			end;
		})[op] or function() error('Cannot handle ' .. op, 2) end)(...)
	end
end