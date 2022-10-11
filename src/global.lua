---@param s string
---@param sep string
string.split = function(s, sep)
    local t = {}
    local temp = ""
    for i = 1, #s do
        if s:sub(i,i) == sep then
            if #temp > 0 then table.insert(t, temp) end
            temp = ""
        else temp = temp .. s:sub(i,i) end
    end
end
---@param t table
table.contains = function(t, e)
    for k, v in pairs(t) do if v == e then return true end end
    return false
end
---@param t table
---@param e string
table.containsStart = function(t, e)
    for k, v in pairs(t) do if v:sub(1,#e) == e then return true end end
    return false
end
---@param t table
---@param sep string
table.join = function(t, sep)
    local s = ""
    for _, v in ipairs(t) do s = s..tostring(v)..sep end
    if #s > 0 then s = s:sub(1,#s-#sep) end
    return s
end
---@param t table
table.copy = function(t)
    if metatype(t) ~= "table" then return t end
    local newT = {}
    for k, v in pairs(t) do newT[k] = table.copy(v) end
    return newT
end
---@param t table
table.tostring = function(t) return "{ "..table.join(t, ", ").." }" end
---@return string
function metatype(object)
    if type(object) == "table" then
        local meta = getmetatable(object)
        if meta then if type(meta.__name) == "string" then return meta.__name end end
    end
    return type(object)
end
---@param label string
function expect(label, value, ...)
    local types = {...}
    if not table.contains(types, metatype(value)) then error("expected "..label.." to be of type "..table.join(types, "|")..", got "..metatype(value), 3) end
end
string.letters = {
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
    "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
    "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "_"
}
string.digits = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }