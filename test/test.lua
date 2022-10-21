
local add = function(x, y)
		if type(y) ~= "number" then error("expected y to be of type number, got "..type(y), 2) end
		if type(x) ~= "number" then error("expected x to be of type number, got "..type(x), 2) end
		return x + y
	end
print(add("hello", 2))