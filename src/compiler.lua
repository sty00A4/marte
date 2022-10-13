require "src.global"
local error = require("src.error")
local lexer = require("src.lexer")
local parser = require("src.parser")

---returns the string version of the node
---@param node table
---@param file table
---@return string|nil, table|nil
local function getString(node, file)
    expect("node", node, "node")
    expect("file", file, "file")
    match = {
        ["node.number"] = function()
            return tostring(node.value)
        end,
        ["node.boolean"] = function()
            return tostring(node.value)
        end,
        ["node.string"] = function()
            return "\""..node.value.."\""
        end,
        ["node.nil"] = function()
            return "nil"
        end,
        ["node.name"] = function()
            return node.name
        end,
    }
    local func = match[metatype(node)]
    if not func then return nil, error.Error("todo: "..metatype(node), file, node.start, node.stop) end
    return func()
end

---returns the compiled version of the file
---@param file table
---@param debug boolean|nil
---@return string|nil, table|nil
local function compile(file, debug)
    expect("file", file, "file")
    expect("debug", debug, "boolean", "nil")
    local tokens, err = lexer.lex(file) if err then return nil, err end
    if debug then print(table.tostring(tokens)) end
    local node node, err = parser.parse(tokens, file) if err then return nil, err end
    if debug then print(tostring(node)) end
    return getString(node, file)
end

local args = {...}
if #args > 0 then
    local file_ = io.open(args[1], "r")
    if not file_ then error("file doesn't exist", 2) end
    local text = file_:read("*a")
    local file = lexer.File(args[1], text)

    local str, err = compile(file, true) if err then print(tostring(err)) return end
else
    print([[
        Usage:
        marte comp [source file path] [target file path]
    ]])
end