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
            return "[ERROR] "..file.path..":"..tostring(start.ln)..": "..detail
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
    return Error("unexpected '"..char.."'", file, start, stop)
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
    return Error(token.." expected, but got "..recvToken, file, start, stop)
end
---@param types table<string>
---@param recvType string
---@param file table
---@param start table
---@param stop table
local function expectedNode(types, recvType, file, start, stop)
    expect("argument #1", types, "table")
    expect("argument #2", recvType, "string")
    expect("argument #3", file, "file")
    expect("argument #4", start, "position")
    expect("argument #5", stop, "position")
    return Error(table.join(types, "|").." expected, but got "..recvType, file, start, stop)
end
---@param scoping string
---@param file table
---@param start table
---@param stop table
local function unexpectedScoping(scoping, file, start, stop)
    expect("argument #1", scoping, "string")
    expect("argument #3", file, "file")
    expect("argument #4", start, "position")
    expect("argument #5", stop, "position")
    return Error("unexpected scoping '"..scoping.."'", file, start, stop)
end

return {
    Error=Error, unexpectedSymbol=unexpectedSymbol, expectedSymbol=expectedSymbol, expectedNode=expectedNode,
    unexpectedScoping=unexpectedScoping
}