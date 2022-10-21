
local Person = function(name, age)
		if type(name) ~= "string" then error("expected name to be of type string, got "..type(name), 2) end
		if type(age) ~= "number" then error("expected age to be of type number, got "..type(age), 2) end
		return setmetatable({
			name = name,
			age = age,
			greet = function(self)
				return "Hello! My name is " .. self.name .. " and I'm " .. tostring(self.age) .. " years old"
			end,
			__setter_name = function(self, v)
				if type(v) ~= "string" then error("expected v to be of type string, got "..type(v), 2) end
				self.name = v
			end,
			__setter_age = function(self, v)
				if type(v) ~= "number" then error("expected v to be of type number, got "..type(v), 2) end
				self.age = v
			end,
		}, {
			__name = "Person",
			__newindex = function(s, k, v)
				if k == "name" then return s:__setter_name(v) end
				if k == "age" then return s:__setter_age(v) end
				return rawset(s, k, v)
			end,
		})
	end
local sty = Person("sty", 18)
print(sty:greet())
return { Person=Person }