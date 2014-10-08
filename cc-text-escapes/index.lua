-- Text Escapes API by CoderPuppy
-- Usage:
--  textEscapes.print(textEscapes.textLime .. "Hello World!" .. textEscapes.textWhite)
--    Prints "Hello World!" in lime
--  textEscapes.print(textEscapes.textGrey .. textEscapes.backYellow .. "HI!!!" .. textEscapes.reset)
--    Prints "HI!!!" in grey with a yellow background

local textEscapes; textEscapes = {
	defaultOpts = {
		textColor  = true;
		backColor  = true;
		moveCursor = true;
		scroll     = true;
		blink      = true;
		clear      = true;
		clearLine  = true;
	};

	write = function(text, _opts)
		local opts = {}
		for k, v in pairs(textEscapes.defaultOpts) do
			opts[k] = v
		end
		if type(_opts) == "table" then
			for k, v in pairs(_opts) do
				opts[k] = v
			end
		end
		
		text = tostring(text)
		
		local offset = text:find(":[", 1, true)
		
		if offset == nil then
			offset = #text + 1
		end

		_G.write(text:sub(1, offset - 1))

		for code in text:gmatch(":%[([^%]]+)%]") do
			offset = offset + 2 + #code + 1
		
			local match
			
			match = {code:match("^tc([0-9a-f])")}
			if opts.textColor and #match > 0 then
				local n = match[1]:byte()
				if n >= 97 then
					-- "a":byte() = 97
					-- a = 10
					n = n - 97 + 10
				else
					-- "0":byte() = 48
					n = n - 48
				end
				term.setTextColor(math.pow(2, n))
			end
			
			match = {code:match("^bc([0-9a-f])$")}
			if opts.backColor and #match > 0 then
				local n = match[1]:byte()
				if n >= 97 then
					-- "a":byte() = 97
					-- a = 10
					n = n - 97 + 10
				else
					-- "0":byte() = 48
					n = n - 48
				end
				term.setBackgroundColor(math.pow(2, n))
			end
			
			match = {code:match("^mc(%d+),(%d+)$")}
			if opts.moveCursor and #match > 0 then
				local x = tonumber(match[1])
				local y = tonumber(match[2])
				term.setCursorPos(x, y)
			end
			
			if opts.blink and code == "bn" then
				term.setCursorBlink(true)
			end
			
			if opts.blink and code == "bf" then
				term.setCursorBlink(false)
			end
			
			if opts.clear and code == "c" then
				term.clear()
			end
			
			if opts.clearLine and code == "cl" then
				term.clearLine()
			end
			
			match = {code:match("^s([%d%-]+)$")}
			if opts.scroll and #match > 0 then
				term.scroll(tonumber(match[1]))
			end

			local nextEscape = text:find(":[", offset, true)
			if nextEscape == nil then
				nextEscape = #text + 1
			end
			_G.write(text:sub(offset, nextEscape - 1))
			offset = nextEscape
		end

		_G.write(text:sub(offset))
	end;

	print = function(text, opts)
		textEscapes.write(tostring(text) .. "\n", opts)
	end;

	hexColor = function(color)
		local n = math.log(color) / math.log(2)
		if n >= 10 then
			n = string.char(97 + n - 10)
		end
		return tostring(n)
	end;

	textColor = function(color)
		return ":[tc" .. textEscapes.hexColor(color) .. "]"
	end;

	backColor = function(color)
		return ":[bc" .. textEscapes.hexColor(color) .. "]"
	end;

	moveCursor = function(x, y)
		return ":[mc" .. tostring(x) .. "," .. tostring(y) .. "]"
	end;

	scroll = function(n)
		return ":[s" .. tostring(n) .. "]"
	end;

	blinkOn  = ":[bn]";
	blinkOff = ":[bf]";

	clear     = ":[c]";
	clearLine = ":[cl]";
}

for name, v in pairs(colors) do
	if type(v) == "number" then
		textEscapes["text" .. name:sub(1, 1):upper() .. name:sub(2)] = textEscapes.textColor(v)
		textEscapes["back" .. name:sub(1, 1):upper() .. name:sub(2)] = textEscapes.backColor(v)
	end
end

textEscapes.reset = textEscapes.textWhite .. textEscapes.backBlack;

return textEscapes