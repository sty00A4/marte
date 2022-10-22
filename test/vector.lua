
local Vector2 Vector2 = function(x, y)
		if type(y) ~= "number" then error("expected y to be of type number, got "..type(y), 2) end
		if type(x) ~= "number" then error("expected x to be of type number, got "..type(x), 2) end
		return setmetatable({
			x = x,
			y = y,
			abs = function(self)
				return Vector2(math.abs(self.x), math.abs(self.y))
			end,
			normalized = function(self)
				return Vector2(self.x / #self, self.y / #self)
			end,
			normalize = function(self)
				self = self:normalized()
			end,
		}, {
			__name = "Vector2",
			__tostring = function(self)
				return "Vector2(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ")"
			end,
			__pow = function(self, other)
				return Vector2(self.x ^ other.x, self.y ^ other.y)
			end,
			__sub = function(self, other)
				return Vector2(self.x - other.x, self.y - other.y)
			end,
			__lt = function(self, other)
				return self.x < other.x and self.y < other.y
			end,
			__div = function(self, other)
				return Vector2(self.x / other.x, self.y / other.y)
			end,
			__unm = function(self)
				return Vector2(-self.x, -self.y)
			end,
			__eq = function(self, other)
				return self.x == other.x and self.y == other.y
			end,
			__mod = function(self, other)
				return Vector2(self.x % other.x, self.y % other.y)
			end,
			__add = function(self, other)
				return Vector2(self.x + other.x, self.y + other.y)
			end,
			__le = function(self, other)
				return self.x <= other.x and self.y <= other.y
			end,
			__len = function(self)
				return math.sqrt(self.x ^ 2 + self.y ^ 2)
			end,
			__mul = function(self, other)
				return Vector2(self.x * other.x, self.y * other.y)
			end,
		})
	end
local Vector3 Vector3 = function(x, y, z)
		if type(z) ~= "number" then error("expected z to be of type number, got "..type(z), 2) end
		if type(y) ~= "number" then error("expected y to be of type number, got "..type(y), 2) end
		if type(x) ~= "number" then error("expected x to be of type number, got "..type(x), 2) end
		return setmetatable({
			x = x,
			y = y,
			z = z,
			abs = function(self)
				return Vector3(math.abs(self.x), math.abs(self.y), math.abs(self.z))
			end,
			normalized = function(self)
				return Vector3(self.x / #self, self.y / #self, self.z / #self)
			end,
			normalize = function(self)
				self = self:normalized()
			end,
		}, {
			__name = "Vector3",
			__tostring = function(self)
				return "Vector3(" .. tostring(self.x) .. ", " .. tostring(self.y) .. ", " .. tostring(self.z) .. ")"
			end,
			__pow = function(self, other)
				return Vector3(self.x ^ other.x, self.y ^ other.y, self.z ^ other.z)
			end,
			__sub = function(self, other)
				return Vector3(self.x - other.x, self.y - other.y, self.z - other.z)
			end,
			__lt = function(self, other)
				return self.x < other.x and self.y < other.y and self.z < other.z
			end,
			__div = function(self, other)
				return Vector3(self.x / other.x, self.y / other.y, self.z / other.z)
			end,
			__unm = function(self)
				return Vector3(-self.x, -self.y, -self.z)
			end,
			__eq = function(self, other)
				return self.x == other.x and self.y == other.y and self.z == other.z
			end,
			__mod = function(self, other)
				return Vector3(self.x % other.x, self.y % other.y, self.z % other.z)
			end,
			__add = function(self, other)
				return Vector3(self.x + other.x, self.y + other.y, self.z + other.z)
			end,
			__le = function(self, other)
				return self.x <= other.x and self.y <= other.y and self.z <= other.z
			end,
			__len = function(self)
				return math.sqrt(self.x ^ 2 + self.y ^ 2 + self.z ^ 2)
			end,
			__mul = function(self, other)
				return Vector3(self.x * other.x, self.y * other.y, self.z * other.z)
			end,
		})
	end
return { Vector2=Vector2, Vector3=Vector3 }