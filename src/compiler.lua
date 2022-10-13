require "src.global"
local lexer = require("src.lexer")
local parser = require("src.parser")

local args = {...}

if #args > 0 then
    local file_ = io.open(args[1], "r")
    if not file_ then error("file doesn't exist", 2) end
    local text = file_:read("*a")
    local file = lexer.File(args[1], text)

    local tokens, err = lexer.lex(file)
    if err then print(tostring(err)) return end
    print(table.tostring(tokens))
    local node node, err = parser.parse(tokens, file)
    if err then print(tostring(err)) return end
    print(tostring(node))
else
    print([[
        Usage:
        marte comp [source file path] [target file path]
    ]])
end