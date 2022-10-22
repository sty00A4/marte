
local Vector2 Vector2 = function(x, y)
		if type(x) ~= "number" then error("expected x to be of type number, got "..type(x), 2) end
		if type(y) ~= "number" then error("expected y to be of type number, got "..type(y), 2) end
		return setmetatable({
			x = x,
			y = y,
		}, {
			__name = "Vector2",
			__sub = function(self, other)
				return Vector2(self.x - other.x, self.y - other.y)
			end,
			__add = function(self, other)
				return Vector2(self.x + other.x, self.y + other.y)
			end,
			__tostring = function(self)
				return "Vector2(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"
			end,
			__mul = function(self, other)
				return Vector2(self.x * other.x, self.y * other.y)
			end,
			__mod = function(self, other)
				return Vector2(self.x % other.x, self.y % other.y)
			end,
			__div = function(self, other)
				return Vector2(self.x / other.x, self.y / other.y)
			end,
		})
	end
local vec1 = Vector2(1, 2)
local vec2 = Vector2(3, 3)
print(vec1 + vec2)
return { Vector2=Vector2 }