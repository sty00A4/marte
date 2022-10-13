require "src.global"
local lexer = require "src.lexer"
local error = require "src.error"

---node.number
---@param value number
---@param start table
---@param stop table
---@return table
local function Number(value, start, stop)
    expect("value", value, "number")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { value = value, start = start, stop = stop, copy = table.copy },
        { __name = "node.name", __tostring = function(self)
            return "("..tostring(self.value)..")"
        end }
    )
end
---node.boolean
---@param value boolean
---@param start table
---@param stop table
---@return table
local function Boolean(value, start, stop)
    expect("value", value, "boolean")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { value = value, start = start, stop = stop, copy = table.copy },
        { __name = "node.name", __tostring = function(self)
            return "("..tostring(self.value)..")"
        end }
    )
end
---node.string
---@param value string
---@param start table
---@param stop table
---@return table
local function String(value, start, stop)
    expect("value", value, "string")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { value = value, start = start, stop = stop, copy = table.copy },
        { __name = "node.string", __tostring = function(self)
            return "(\""..self.value.."\")"
        end }
    )
end
---node.nil
---@param start table
---@param stop table
---@return table
local function Nil(start, stop)
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { start = start, stop = stop, copy = table.copy },
        { __name = "node.nil", __tostring = function(self)
            return "(nil)"
        end }
    )
end
---node.table
---@param nodes table
---@param start table
---@param stop table
---@return table
local function Table(nodes, start, stop)
    expect("value", nodes, "table")
    for k, n in pairs(nodes) do expect("nodes."..k, n, "node") end
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { nodes = nodes, start = start, stop = stop, copy = table.copy },
        { __name = "node.table", __tostring = function(self)
            return "({"..table.join(self.nodes, ", ").."})"
        end }
    )
end
---node.exprlist
---@param nodes table
---@param start table
---@param stop table
---@return table
local function ExprList(nodes, start, stop)
    expect("value", nodes, "table")
    for k, n in pairs(nodes) do expect("nodes."..k, n, "node") end
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { nodes = nodes, start = start, stop = stop, copy = table.copy },
        { __name = "node.exprlist", __tostring = function(self)
            return "("..table.join(self.nodes, ", ")..")"
        end }
    )
end
---node.expr
---@param node table
---@param start table
---@param stop table
---@return table
local function Expr(node, start, stop)
    expect("value", node, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.expr", __tostring = function(self)
            return tostring(self.node)
        end }
    )
end

---node.name
---@param name string
---@param start table
---@param stop table
---@return table
local function Name(name, start, stop)
    expect("name", name, "string")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { name = name, start = start, stop = stop, copy = table.copy },
        { __name = "node.name", __tostring = function(self)
            return "("..self.name..")"
        end }
    )
end
---node.field
---@param head table
---@param field table
---@param start table
---@param stop table
---@return table
local function Field(head, field, start, stop)
    expect("head", head, "node")
    expect("field", field, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { head = head, field = field, start = start, stop = stop, copy = table.copy },
        { __name = "node.field", __tostring = function(self)
            return "("..tostring(self.head).." ["..tostring(self.field).."])"
        end }
    )
end
---node.call
---@param head table
---@param args table<table>
---@param start table
---@param stop table
---@return table
local function Call(head, args, start, stop)
    expect("head", head, "node")
    expect("args", args, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { head = head, args = args, start = start, stop = stop, copy = table.copy },
        { __name = "node.call", __tostring = function(self)
            return "(call "..tostring(self.head).." "..tostring(self.args)..")"
        end }
    )
end
---node.selfCall
---@param head table
---@param name table
---@param args table<table>
---@param start table
---@param stop table
---@return table
local function SelfCall(head, name, args, start, stop)
    expect("head", head, "node")
    expect("name", name, "node.name")
    expect("args", args, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { head = head, name = name, args = args, start = start, stop = stop, copy = table.copy },
        { __name = "node.call", __tostring = function(self)
            return "(selfcall "..tostring(self.head).." : "..tostring(self.name).." "..tostring(self.args)..")"
        end }
    )
end
---node.body
---@param nodes table
---@param start table
---@param stop table
---@return table
local function Body(nodes, start, stop)
    expect("nodes", nodes, "table")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { nodes = nodes, start = start, stop = stop, copy = table.copy },
        { __name = "node.body", __tostring = function(self)
            return "(\n"..table.join(self.nodes, "\n").."\n)"
        end }
    )
end
---node.binary
---@param op table
---@param left table
---@param right table
---@param start table
---@param stop table
---@return table
local function Binary(op, left, right, start, stop)
    expect("op", op, "token")
    expect("left", left, "node")
    expect("right", right, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { op = op, left = left, right = right, start = start, stop = stop, copy = table.copy },
        { __name = "node.binary", __tostring = function(self)
            return "("..tostring(self.left).." "..op.type.." "..tostring(self.right)..")"
        end }
    )
end
---node.unaryLeft
---@param op table
---@param node table
---@param start table
---@param stop table
---@return table
local function UnaryLeft(op, node, start, stop)
    expect("op", op, "token")
    expect("node", node, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { op = op, node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.unaryLeft", __tostring = function(self)
            return "("..op.type.." "..tostring(self.node)..")"
        end }
    )
end
---node.unaryRight
---@param op table
---@param node table
---@param start table
---@param stop table
---@return table
local function UnaryRight(op, node, start, stop)
    expect("op", op, "token")
    expect("node", node, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { op = op, node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.unaryRight", __tostring = function(self)
            return "("..tostring(self.node).." "..self.op.type..")"
        end }
    )
end

---parses tokens from the lexer
---@param tokens table
---@param file table
local function parse(tokens, file)
    local idx, token = 0
    local function advance()
        idx = idx + 1
        token = tokens[idx]
    end
    advance()
    local function binop(ops, f1, f2)
        if not f2 then f2 = f1 end
        expect("ops", ops, "table")
        expect("f1", f1, "function")
        expect("f2", f2, "function")
        local left, err = f1() if err then return nil, err end
        while table.contains(ops, token.type) do
            local op = token:copy()
            advance()
            local right right, err = f2() if err then return nil, err end
            left = Binary(op, left, right, left.start:copy(), right.stop:copy())
        end
        return left
    end
    local chunk, body, stat, expr, negate, logic, comp, arith, term, power, factor, call, field, atom,
    exprlist
    chunk = function()
        local start, stop = token.start:copy(), token.stop:copy()
        local nodes = {}
        while token.type ~= "<eof>" do
            local node, err = stat() if err then return nil, err end
            stop = node.stop:copy()
            table.insert(nodes, node)
        end
        if #nodes == 1 then return nodes[1] end
        return Body(nodes, start, stop)
    end
    stat = function() return expr() end -- todo stat
    expr = function() return negate() end
    exprlist = function()
        local start, stop = token.start:copy(), token.stop:copy()
        local nodes = {}
        local node, err = expr() if err then return nil, err end
        table.insert(nodes, node)
        while token.type == "," do
            advance()
            node, err = expr() if err then return nil, err end
            stop = node.stop:copy()
            table.insert(nodes, node)
        end
        if #nodes == 1 then return nodes[1] end
        return ExprList(nodes, start, stop)
    end
    negate = function()
        if token.type == "not" then
            local op = token:copy()
            advance()
            local node, err = negate() if err then return nil, err end
            return UnaryLeft(op, node, op.start:copy(), node.stop:copy())
        end
        return logic()
    end
    logic = function() return binop({"and","or"}, comp) end
    comp = function() return binop({"==","~=","<",">","<=",">="}, arith) end
    arith = function() return binop({"+","-"}, term) end
    term = function() return binop({"*","/","//","%"}, power) end
    power = function() return binop({"^"}, factor) end
    factor = function()
        if token.type == "-" then
            local op = token:copy()
            advance()
            local node, err = factor() if err then return nil, err end
            return UnaryLeft(op, node, op.start:copy(), node.stop:copy())
        end
        return call()
    end
    call = function()
        local head, err = field() if err then return nil, err end
        if token.type == ":" then
            advance()
            if token.type ~= "name" then return nil, error.expectedNear("name", token.type, file, token.start, token.stop) end
            local name = Name(token.value, token.start:copy(), token.stop:copy())
            advance()
            if token.type ~= "(" then
                return nil, error.expectedNear("'('", token.type, file, token.start, token.stop)
            end
            advance()
            local args args, err = exprlist() if err then return nil, err end
            if token.type ~= ")" then
                return nil, error.expectedNear("')'", token.type, file, token.start, token.stop)
            end
            advance()
            head = SelfCall(head, name, args, head.start:copy(), args.stop:copy())
        end
        while token.type == "(" do
            advance()
            local args args, err = exprlist() if err then return nil, err end
            if token.type ~= ")" then
                return nil, error.expectedNear("')'", token.type, file, token.start, token.stop)
            end
            advance()
            head = Call(head, args, head.start:copy(), args.stop:copy())
        end
        return head
    end
    field = function()
        local head, err = atom() if err then return nil, err end
        while token.type == "." do
            advance()
            local field_ field_, err = atom() if err then return nil, err end
            head = Field(head, field_, head.start:copy(), field_.stop:copy())
        end
        while token.type == "[" do
            advance()
            local field_ field_, err = expr() if err then return nil, err end
            if token.type ~= "]" then
                return nil, error.expectedNear("']'", token.type, file, token.start, token.stop)
            end
            advance()
            head = Field(head, field_, head.start:copy(), field_.stop:copy())
        end
        return head
    end
    atom = function()
        local token_ = token:copy()
        if token.type == "number" then advance() return Number(token_.value, token_.start:copy(), token_.stop:copy()) end
        if token.type == "string" then advance() return String(token_.value, token_.start:copy(), token_.stop:copy()) end
        if token.type == "boolean" then advance() return Boolean(token_.value, token_.start:copy(), token_.stop:copy()) end
        if token.type == "nil" then advance() return Nil(token_.start:copy(), token_.stop:copy()) end
        if token.type == "name" then advance() return Name(token_.value, token_.start:copy(), token_.stop:copy()) end
        if token.type == "(" then
            local start = token.start:copy()
            advance()
            local node, err = expr() if err then return nil, err end
            if token.type ~= ")" then
                return nil, error.expectedNear("')'", token.type, file, token.start, token.stop)
            end
            local stop = token.stop:copy()
            advance()
            return Expr(node, start, stop)
        end
        return nil, error.nearSymbol(file:sub(token.start, token.stop), file, token.start:copy(), token.stop:copy())
    end
    return chunk()
end

return { parse=parse }