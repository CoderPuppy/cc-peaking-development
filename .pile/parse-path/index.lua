return require('fn').combine(
	require('fn-str').split('/'),
	require('fn-arr').filter(function(str)
		return #str > 0
	end)
)