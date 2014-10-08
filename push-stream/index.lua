local push = require('./core')

for _, name in ipairs({ 'sources', 'throughs', 'sinks' }) do
	for k, v in pairs(require('./' .. name)) do
		push[k] = v
	end
end

return push