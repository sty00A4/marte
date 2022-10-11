---@param detail string
---@param file table
---@param start table
---@param stop table
local function Error(detail, file, start, stop)
    expect("argument #1", detail, "string")
    expect("argument #2", file, "mr.file")
    expect("argument #3", start, "mr.position")
    expect("argument #4", stop, "mr.position")
    return setmetatable(
        { detail = detail, file = file, start = start, stop = stop },
        { __name = "mr.error", __tostring = function(self)
            return file.path..":"..tostring(start.ln)..": "..detail
        end }
    )
end
---@param char string
---@param file table
---@param start table
---@param stop table
local function nearSymbol(char, file, start, stop)
    expect("argument #1", char, "string")
    expect("argument #2", file, "mr.file")
    expect("argument #3", start, "mr.position")
    expect("argument #4", stop, "mr.position")
    return Error("unexpected symbol near '"..char.."'", file, start, stop)
end

return { Error=Error, nearSymbol=nearSymbol }