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
    expect("nodes", nodes, "table")
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
---node.varlist
---@param nodes table
---@param start table
---@param stop table
---@return table
local function VarList(nodes, start, stop)
    expect("nodes", nodes, "table")
    for k, n in pairs(nodes) do expect("nodes."..k, n, "node.name", "node.field") end
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { nodes = nodes, start = start, stop = stop, copy = table.copy },
        { __name = "node.varlist", __tostring = function(self)
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
            return "(body "..table.join(self.nodes, "; ")..")"
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

---node.assign
---@param vars table
---@param exprs table
---@param scoping string
---@param start table
---@param stop table
---@return table
local function Assign(vars, exprs, scoping, start, stop)
    expect("vars", vars, "node")
    expect("exprs", exprs, "node")
    expect("scoping", scoping, "string")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { vars = vars, exprs = exprs, scoping = scoping, start = start, stop = stop, copy = table.copy },
        { __name = "node.assign", __tostring = function(self)
            return "("..self.scoping.." "..tostring(self.vars).." = "..tostring(self.exprs)..")"
        end }
    )
end
---node.return
---@param node table
---@param start table
---@param stop table
---@return table
local function Return(node, start, stop)
    expect("vars", node, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.return", __tostring = function(self)
            return "(return "..tostring(self.node)..")"
        end }
    )
end
---node.goto
---@param node table
---@param start table
---@param stop table
---@return table
local function Goto(node, start, stop)
    expect("vars", node, "node.name")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.goto", __tostring = function(self)
            return "(goto "..tostring(self.node)..")"
        end }
    )
end
---node.label
---@param node table
---@param start table
---@param stop table
---@return table
local function Label(node, start, stop)
    expect("node", node, "node.name")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.label", __tostring = function(self)
            return "(:: "..tostring(self.node).." ::)"
        end }
    )
end
---node.if
---@param cond table
---@param node table
---@param conds table
---@param nodes table
---@param elseNode table
---@param start table
---@param stop table
---@return table
local function If(cond, node, conds, nodes, elseNode, start, stop)
    expect("cond", cond, "node")
    expect("node", node, "node")
    expect("conds", conds, "table")
    for k, v in pairs(conds) do expect("conds."..k, v, "node") end
    expect("nodes", nodes, "table")
    for k, v in pairs(nodes) do expect("nodes."..k, v, "node") end
    expect("elseNode", elseNode, "node", "nil")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        {
            cond = cond, node = node, conds = conds, nodes = nodes, elseNode = elseNode,
            start = start, stop = stop, copy = table.copy
        },
        {
            __name = "node.if", __tostring = function(self)
                local s = "(if "..tostring(self.cond).." then "..tostring(self.node)
                for i = 1, #self.conds do
                    s = s.." elseif "..tostring(self.conds[i]).." then "..tostring(self.nodes[i])
                end
                if self.elseNode then s = s.." else "..tostring(self.elseNode) end
                s = s.." end)"
                return s
            end
        }
    )
end
---node.while
---@param cond table
---@param node table
---@param start table
---@param stop table
---@return table
local function While(cond, node, start, stop)
    expect("cond", cond, "node")
    expect("node", node, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { cond = cond, node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.while", __tostring = function(self)
            return "(while "..tostring(self.cond).." do "..tostring(self.node).." end)"
        end}
    )
end
---node.repeat
---@param cond table
---@param node table
---@param start table
---@param stop table
---@return table
local function Repeat(cond, node, start, stop)
    expect("cond", cond, "node")
    expect("node", node, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { cond = cond, node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.repeat", __tostring = function(self)
            return "(repeat "..tostring(self.node).." until "..tostring(self.cond)..")"
        end}
    )
end
---node.do
---@param node table
---@param start table
---@param stop table
---@return table
local function Do(node, start, stop)
    expect("node", node, "node")
    expect("start", start, "position")
    expect("stop", stop, "position")
    return setmetatable(
        { node = node, start = start, stop = stop, copy = table.copy },
        { __name = "node.do", __tostring = function(self)
            return "(do "..tostring(self.node).." end)"
        end}
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
    exprlist, varlist, if_body
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
    body = function(stopTokens)
        if stopTokens == nil then stopTokens = {} end
        local start, stop = token.start:copy(), token.stop:copy()
        local nodes = {}
        while not table.contains(stopTokens, token.type) do
            local node, err = stat() if err then return nil, err end
            stop = node.stop:copy()
            table.insert(nodes, node)
        end
        if #nodes == 1 then return nodes[1] end
        return Body(nodes, start, stop)
    end
    stat = function(prefix)
        if prefix == nil then prefix = true end
        if (token.type == "local" or token.type == "export") and prefix then
            local scoping = token.type
            advance()
            local subnode, err = stat(false) if err then return nil, err end
            if metatype(subnode) ~= "node.assign" then
                return nil, error.unexpectedSymbol(file:sub(subnode.start, subnode.stop), file, subnode.start, subnode.stop)
            end
            subnode.scoping = scoping
            return subnode
        end
        if token.type == "return" then
            local start = token.start:copy()
            advance()
            local node, err = expr() if err then return nil, err end
            return Return(node, start, node.stop:copy())
        end
        if token.type == "goto" then
            local start = token.start:copy()
            advance()
            if token.type ~= "name" then
                return nil, error.expectedSymbol("name", token.type, file, token.start, token.stop)
            end
            local name = Name(token.value, token.start:copy(), token.stop:copy())
            advance()
            return Goto(name, start, name.stop:copy())
        end
        if token.type == "::" then
            local start = token.start:copy()
            advance()
            if token.type ~= "name" then
                return nil, error.expectedSymbol("name", token.type, file, token.start, token.stop)
            end
            local name = Name(token.value, token.start:copy(), token.stop:copy())
            advance()
            if token.type ~= "::" then
                return nil, error.expectedSymbol("'::'", token.type, file, token.start, token.stop)
            end
            advance()
            return Label(name, start, name.stop:copy())
        end
        if token.type == "if" then
            local start = token.start:copy()
            advance()
            local conds, nodes, cond, node, elseNode, err = {}, {}
            cond, err = expr() if err then return nil, err end
            if token.type ~= "then" then
                return nil, error.expectedSymbol("'then'", token.type, file, token.start, token.stop)
            end
            advance()
            node, err = body({"elseif", "else", "end"}) if err then return nil, err end
            while token.type == "elseif" do
                advance()
                local cond_ cond_, err = expr() if err then return nil, err end
                table.insert(conds, cond_)
                if token.type ~= "then" then
                    return nil, error.expectedSymbol("'then'", token.type, file, token.start, token.stop)
                end
                advance()
                local node_ node_, err = body({"elseif", "else", "end"}) if err then return nil, err end
                table.insert(nodes, node_)
            end
            if token.type == "else" then
                advance()
                elseNode, err = body({"end"}) if err then return nil, err end
            end
            if token.type ~= "end" then
                return nil, error.expectedSymbol("'end'", token.type, file, token.start, token.stop)
            end
            local stop = token.stop:copy()
            advance()
            return If(cond, node, conds, nodes, elseNode, start, stop)
        end
        if token.type == "while" then
            local start = token.start:copy()
            advance()
            local cond, node, err
            cond, err = expr() if err then return nil, err end
            if token.type ~= "do" then
                return nil, error.expectedSymbol("'do'", token.type, file, token.start, token.stop)
            end
            advance()
            node, err = body({"end"}) if err then return nil, err end
            local stop = token.stop:copy()
            advance()
            return While(cond, node, start, stop)
        end
        if token.type == "repeat" then
            local start = token.start:copy()
            advance()
            local cond, node, err
            node, err = body({"until"}) if err then return nil, err end
            advance()
            cond, err = expr() if err then return nil, err end
            local stop = cond.stop:copy()
            return Repeat(cond, node, start, stop)
        end
        if token.type == "do" then
            local start = token.start:copy()
            advance()
            local node, err = body({"end"}) if err then return nil, err end
            local stop = token.stop:copy()
            advance()
            return Do(node, start, stop)
        end
        local idx_ = idx
        local node, err = call() if err then return nil, err end
        if metatype(node) == "node.call" or metatype(node) == "node.selfCall" then
            return node
        end
        if metatype(node) == "node.name" or metatype(node) == "node.field" then
            idx = idx_ token = tokens[idx]
            local vars vars, err = varlist() if err then return nil, err end
            if token.type == "=" then
                advance()
                local expr_ expr_, err = exprlist() if err then return nil, err end
                return Assign(vars, expr_, "global", node.start:copy(), expr_.stop:copy())
            end
        end
        return nil, error.unexpectedSymbol(file:sub(node.start, node.stop), file, node.start, node.stop)
    end
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
    varlist = function()
        local start, stop = token.start:copy(), token.stop:copy()
        local nodes = {}
        local node, err = field() if err then return nil, err end
        table.insert(nodes, node)
        while token.type == "," do
            advance()
            node, err = field() if err then return nil, err end
            stop = node.stop:copy()
            table.insert(nodes, node)
        end
        if #nodes == 1 then return nodes[1] end
        return VarList(nodes, start, stop)
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
        while token.type == ":" do
            advance()
            if token.type ~= "name" then return nil, error.expectedSymbol("name", token.type, file, token.start, token.stop) end
            local name = Name(token.value, token.start:copy(), token.stop:copy())
            advance()
            if token.type ~= "(" then
                return nil, error.expectedSymbol("'('", token.type, file, token.start, token.stop)
            end
            advance()
            local args args, err = exprlist() if err then return nil, err end
            if token.type ~= ")" then
                return nil, error.expectedSymbol("')'", token.type, file, token.start, token.stop)
            end
            advance()
            head = SelfCall(head, name, args, head.start:copy(), args.stop:copy())
        end
        while token.type == "(" do
            advance()
            local args args, err = exprlist() if err then return nil, err end
            if token.type ~= ")" then
                return nil, error.expectedSymbol("')'", token.type, file, token.start, token.stop)
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
                return nil, error.expectedSymbol("']'", token.type, file, token.start, token.stop)
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
                return nil, error.expectedSymbol("')'", token.type, file, token.start, token.stop)
            end
            local stop = token.stop:copy()
            advance()
            return Expr(node, start, stop)
        end
        return nil, error.unexpectedSymbol(file:sub(token.start, token.stop), file, token.start:copy(), token.stop:copy())
    end
    return chunk()
end

return { parse=parse, node = {
    Number=Number, Boolean=Boolean, String=String, Nil=Nil, Table=Table, ExprList=ExprList, VarList=VarList,
    Expr=Expr, Name=Name, Field=Field, Call=Call, SelfCall=SelfCall, Body=Body, Binary=Binary, UnaryLeft=UnaryLeft,
    UnaryRight=UnaryRight
} }