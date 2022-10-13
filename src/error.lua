---@param detail string
---@param file table
---@param start table
---@param stop table
local function Error(detail, file, start, stop)
    expect("argument #1", detail, "string")
    expect("argument #2", file, "file")
    expect("argument #3", start, "position")
    expect("argument #4", stop, "position")
    return setmetatable(
        { detail = detail, file = file, start = start, stop = stop },
        { __name = "error", __tostring = function(self)
            return file.path..":"..tostring(start.ln)..": "..detail
        end }
    )
end
---@param char string
---@param file table
---@param start table
---@param stop table
local function unexpectedSymbol(char, file, start, stop)
    expect("argument #1", char, "string")
    expect("argument #2", file, "file")
    expect("argument #3", start, "position")
    expect("argument #4", stop, "position")
    return Error("unexpected symbol near '"..char.."'", file, start, stop)
end
---@param token string
---@param recvToken string
---@param file table
---@param start table
---@param stop table
local function expectedSymbol(token, recvToken, file, start, stop)
    expect("argument #1", token, "string")
    expect("argument #2", recvToken, "string")
    expect("argument #3", file, "file")
    expect("argument #4", start, "position")
    expect("argument #5", stop, "position")
    return Error(token.." expected near "..recvToken, file, start, stop)
end

return { Error=Error, unexpectedSymbol=unexpectedSymbol, expectedSymbol=expectedSymbol }