local Promise = require('promise')
local fn = require('fn')
fn.arr = require('fn-arr')
fn.str = require('fn-str')

Promise(
	Promise.all(
		Promise.resolved(true, 10),
		Promise.resolved(true, 20),
		Promise.resolved(false, 'fizbuz')
	)
	--Promise.map(function(...)
	--	print('done')
	--	print(textutils.serialize({...}))
	--	print('end')
	--end),
	--Promise.orError()
)