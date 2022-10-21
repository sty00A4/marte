
Person = function(name, age)
		if type(name) ~= "string" then error("expected name to be of type string, got "..type(name), 2) end
		if type(age) ~= "number" then error("expected age to be of type number, got "..type(age), 2) end
		return setmetatable({
			name = name,
			age = age,
			greet = function(self)
				return "Hello! My name is " .. self.name .. " and I'm " .. tostring(self.age) .. " years old."
			end,
			__setter_name = function(self, newName)
				if type(newName) ~= "string" then error("expected newName to be of type string, got "..type(newName), 2) end
				self.name = newName
			end,
			__getter_nameAge = function(self)
				return self.name .. " " .. tostring(self.age)
			end,
		}, {
			__name = "Person",
			__newindex = function(s, k, v)
				if k == "name" then return s:__setter_name(v) end
				return rawset(s, k, v)
			end,
			__index = function(s, k)
				if k == "nameAge" then return s:__getter_nameAge() end
				return rawget(s, k)
			end,
		})
	end
local sty = Person("sty", 18)
print(sty.nameAge)