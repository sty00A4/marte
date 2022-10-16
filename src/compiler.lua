require "src.global"
local error = require("src.error")
local lexer = require("src.lexer")
local parser = require("src.parser")

---returns the string version of the node
---@param node table
---@param file table
---@param context table
---@return string|nil, table|nil
local function getString(node, file, context, indent)
    if indent == nil then indent = 0 end
    expect("node", node, "node")
    expect("file", file, "file")
    expect("context", context, "table")
    expect("indent", indent, "number")
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
        ["node.table"] = function()
            local str = "{ "
            for _, n in ipairs(node.nodes) do
                local s, err = getString(n, file, context) if err then return nil, err end
                str = str .. s .. ", "
            end
            if #str == 2 then return "{}" else str = str:sub(1, #str-2) end
            str = str .. " }"
            return str
        end,
        ["node.exprlist"] = function()
            local str = ""
            for _, n in ipairs(node.nodes) do
                local s, err = getString(n, file, context) if err then return nil, err end
                str = str..s..", "
            end
            if #str > 0 then str = str:sub(1, #str-2) end
            return str
        end,
        ["node.varlist"] = function()
            local str = ""
            for _, n in ipairs(node.nodes) do
                local s, err = getString(n, file, context) if err then return nil, err end
                str = str .. s .. ", "
            end
            if #str > 0 then str = str:sub(1, #str-2) end
            return str
        end,
        ["node.params"] = function()
            local str = ""
            for _, n in ipairs(node.nodes) do
                local s, err = getString(n, file, context) if err then return nil, err end
                str = str .. s .. ", "
            end
            if #str > 0 then str = str:sub(1, #str-2) end
            return str
        end,
        ["node.expr"] = function()
            local s, err = getString(node.node, file, context) if err then return nil, err end
            return "("..s..")"
        end,
        ["node.name"] = function()
            return node.name
        end,
        ["node.index"] = function()
            local head, err = getString(node.head, file, context) if err then return nil, err end
            local index index, err = getString(node.index, file, context) if err then return nil, err end
            if metatype(node.index) == "node.name" then
                return head.."."..index
            end
            return head.."["..index.."]"
        end,
        ["node.call"] = function()
            local head, err = getString(node.head, file, context) if err then return nil, err end
            local args args, err = getString(node.args, file, context) if err then return nil, err end
            return head.."("..args..")"
        end,
        ["node.selfCall"] = function()
            local head, err = getString(node.head, file, context) if err then return nil, err end
            local field field, err = getString(node.field, file, context) if err then return nil, err end
            local args args, err = getString(node.args, file, context) if err then return nil, err end
            return head..":"..field.."("..args..")"
        end,
        ["node.body"] = function()
            local str = ""
            for _, n in ipairs(node.nodes) do
                local s, err = getString(n, file, context, indent+1) if err then return nil, err end
                str = str.."\n"..("\t"):rep(indent)..s
            end
            if #str == 0 then str = " " end
            return str
        end,
        ["node.assign"] = function()
            local vars, err = getString(node.vars, file, context) if err then return nil, err end
            local exprs exprs, err = getString(node.exprs, file, context) if err then return nil, err end
            if node.scoping == "local" then
                return "local "..vars.." = "..exprs
            end
            if node.scoping == "export" then
                table.insert(context.exports, node.vars)
                return "local "..vars.." = "..exprs
            end
            return vars.." = "..exprs
        end,
        ["node.return"] = function()
            local str, err = getString(node.node, file, context) if err then return nil, err end
            return "return "..str
        end,
        ["node.field"] = function()
            local key, err = getString(node.key, file, context) if err then return nil, err end
            local value value, err = getString(node.value, file, context) if err then return nil, err end
            if metatype(node.key) == "node.name" then
                return key.." = "..value
            end
            return "["..key.."] = "..value
        end,
    }
    local func = match[metatype(node)]
    if not func then return nil, error.Error("todo: "..metatype(node), file, node.start, node.stop) end
    return func(indent)
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
    local context = { exports = {} }
    local str str, err = getString(node, file, context) if err then return nil, err end
    if #context.exports > 0 then
        str = str.."\nreturn { "
        for _, n in ipairs(context.exports) do
            if metatype(n) == "node.name" or metatype(n) == "node.param" or
            metatype(n) == "node.function" or metatype(n) == "node.meta" then
                str = str..n.name.."="..n.name..", "
            end
            if metatype(n) == "node.varlist" then
                for _, var in ipairs(n.nodes) do
                    if metatype(var) == "node.name" then
                        str = str..var.name.."="..var.name..", "
                    end
                end
            end
        end
        str = str.." }"
    end
    if debug then print(str) end
    return str, err
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