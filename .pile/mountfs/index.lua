local Promise = require('promise')
local fn = require('fn')
fn.arr = require('fn-arr')
fn.str = require('fn-str')
local parsePath = require('parse-path')

return function()
	local self = fn.more(function(self, ctx, path, op, ...)
		local mountAcc = {}
		for mountPathStr, mounts in pairs(self.mounts) do
		  local mountPath = fn(mountPathStr, parsePath)
			local subPath = fn(path, fn.arr.slice(#mountPath + 1))
			local match = fn(path, fn.arr.slice(1, #mountPath))
			local matches = fn(match, fn.arr.equals(mountPath))
			--print(textutils.serialize({
				--mountPath = mountPath;
				--subPath = subPath;
				--match = match;
				--mounts = #mounts;
				--matches = matches;
			--}))
			if matches then
				for _, mount in ipairs(mounts) do
					if op ~= 'delete' or #subPath == 0 then
						mountAcc[#mountAcc + 1] = {mountPath, mount, subPath}
					end
				end
			end
		end
		if op == 'open' then
			local mode = ...
			return fn(mountAcc,
				fn.arr.map(function(mount)
					return Promise.all(
						Promise.resolved(true, mount),
						mount[2](ctx, mount[3], 'stat')
					)
				end),
				unpack, Promise.all,
				Promise.map(fn.combine(
					function(...) return {...} end,
					fn.arr.map(function(stat)
						return {stat[1][1], stat[2][1]}
					end),
					fn.arr.find(function(stat)
						return stat[2].exists and stat[2].type == 'block'
					end),
					function(stat) return stat[1] end
				)),
				Promise.flatMap(function(mount)
					return mount[2](ctx, mount[3], 'open', mode)
				end)
			)
		elseif op == 'stat' then
			return fn(mountAcc,
				fn.arr.map(function(mount)
					return mount[2](ctx, mount[3], 'stat')
				end),
				unpack, Promise.all,
				Promise.map(fn.combine(
					function(...) return {...} end,
					fn.arr.map(function(stat) return stat[1] end),
					fn.arr.find(function(stat) return stat.exists end),
					function(stat)
						if stat then
							return stat
						else
							return {
								exists = false;
							}
						end
					end
				))
			)
		else
			error('mountfs - TODO: generic ' .. op)
		end
	end)

	self.mounts = {}
	function self.mount(path, fs)
		if type(path) == 'string' then path = parsePath(path) end
		path = fn(path, fn.arr.join('/'))
		if type(self.mounts[path]) ~= 'table' then self.mounts[path] = {} end
		local mounts = self.mounts[path]
		if fn(mounts, fn.arr.indexOf(fs)) == -1 then
			mounts[#mounts + 1] = fs
		else
			error('mountfs.mount(): Already mounted here', 2)
		end
	end
	function self.unmount(path, fs)
		if fs == nil then
			self.mounts[path] = nil
			return true
		end
		local mounts = self.mounts[path]
		if type(mounts) ~= 'table' then error('Not mounted there', 2) end
		local index = fn(mounts, fn.arr.indexOf(fs))
		if index == -1 then
			error('Not mounted there', 2)
		else
			table.remove(mounts, index)
		end
	end

	return self
end