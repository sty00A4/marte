---@param name string
---@param age number
---@return Person
local function Person(name, age)
	if type(name) ~= "string" then error("expected arguement #1 to be of type string", 2) end
	if type(age) ~= "number" then error("expected arguement #2 to be of type number", 2) end
	return setmetatable(
		{
			name = name,
			age = age,
			---@param self Person
			greet = function(self)
				if type(self) ~= "Person" then error("expected arguement #1 to be of type Person", 2) end
				return "Hello! My name is "..self.name.." and I'm "..tostring(self.age).." years old"
			end,
			---@param self Person
			---@param v string
			__setter_name = function(self, v)
				if type(self) ~= "Person" then error("expected arguement #1 to be of type Person", 3) end
				if type(v) ~= "string" then error("expected arguement #2 to be of type string", 3) end
				self.name = v
			end,
			---@param self Person
			---@param v number
			__setter_age = function(self, v)
				if type(self) ~= "Person" then error("expected arguement #1 to be of type string", 3) end
				if type(v) ~= "number" then error("expected arguement #2 to be of type number", 3) end
				self.age = v
			end,
		},
		{
			__name = "Person",
			__newindex = function(self, k, v)
				if k == "name" then self:__setter_name(v) end
				if k == "age" then self:__setter_age(v) end
				rawset(self, k, v)
			end,
		}
	)
end

return { Person=Person }