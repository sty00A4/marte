require "src.global"
local error = require "src.error"
---@param path string
---@param text string
local function File(path, text)
    expect("argument #1", path, "string")
    expect("argument #2", text, "string")
    return setmetatable(
        {
            path = path, text = text, copy = table.copy,
            sub = function(self, start, stop) return self.text:sub(start.idx, stop.idx) end
        },
        { __name = "file" }
    )
end
---@param idx number
---@param ln number
---@param col number
local function Position(idx, ln, col)
    expect("argument #1", idx, "number")
    expect("argument #2", ln, "number")
    expect("argument #3", col, "number")
    return setmetatable(
        { idx = idx, ln = ln, col = col, copy = table.copy },
        { __name = "position" }
    )
end
---@param type string
---@param start table
---@param stop table
local function Token(type, value, start, stop)
    expect("argument #1", type, "string")
    expect("argument #3", start, "position")
    expect("argument #4", stop, "position")
    return setmetatable(
        { type = type, value = value, start = start, stop = stop, copy = table.copy },
        { __name = "token", __tostring = function (self)
            if self.value then return "["..self.type..":"..self.value.."]" else return "["..self.type.."]" end
        end }
    )
end

local keywords = {
    "and", "break", "do", "else", "elseif", "end", "for", "function", "if",
    "in", "local", "not", "or", "repeat", "return", "then", "until", "while",
    "meta", "export", "setter", "getter", "metamethod"
}
local symbols = {
    "+", "-", "*", "/", "%", "^", "#", "==", "~=", "<=", ">=", "<", ">", "=",
    "(", ")", "{", "}", "[", "]", ";", ":", ",", "...", "..", "."
}

---@param file table
---@return table|nil, table|nil
local function lex(file)
    expect("argument #1", file, "file")
    local tokens = {}
    local char = ""
    local idx = 0
    local ln = 1
    local col = 0
    local function advance()
        idx = idx + 1
        col = col + 1
        if char == "\n" then ln = ln + 1 col = 1 end
        char = file.text:sub(idx,idx)
    end
    advance()
    while #char > 0 do
        if table.contains({" ","\t","\n","\r","\f"}, char) then
            advance()
        elseif table.contains(string.letters, char) then
            local start, stop = Position(idx, ln, col), Position(idx, ln, col)
            local word = char
            advance()
            while (table.contains(string.letters, char) or table.contains(string.digits, char)) and #char > 0 do
                word = word .. char
                stop = Position(idx, ln, col)
                advance()
            end
            if table.contains(keywords, word) then
                table.insert(tokens, Token(word, nil, start, stop))
            else
                if word:sub(#word-1,#word) == "_L" then word = "_" .. word end
                table.insert(tokens, Token("name", word, start, stop))
            end
        elseif table.contains(string.digits, char) then
            local start, stop = Position(idx, ln, col), Position(idx, ln, col)
            local number = char
            advance()
            while table.contains(string.digits, char) and #char > 0 do
                number = number .. char
                stop = Position(idx, ln, col)
                advance()
            end
            table.insert(tokens, Token("number", tonumber(number), start, stop))
        elseif table.containsStart(symbols, char) then
            local start, stop = Position(idx, ln, col), Position(idx, ln, col)
            local symbol = char
            advance()
            if symbol..char == "--" then
                while char ~= "\n" do advance() end
            else
                while table.containsStart(symbols, symbol..char) and #char > 0 do
                    symbol = symbol .. char
                    stop = Position(idx, ln, col)
                    advance()
                end
                table.insert(tokens, Token(symbol, nil, start, stop))
            end
        elseif char == '"' or char == "'" then
            local start, stop = Position(idx, ln, col), Position(idx, ln, col)
            local stopChar = char
            advance()
            local str = ""
            while char ~= stopChar and #char > 0 do
                if char == "\\" then
                    advance()
                    if char == "n" then str = str .. "\n" advance()
                    elseif char == "t" then str = str .. "\t" advance()
                    elseif char == "r" then str = str .. "\r" advance()
                    elseif char == "f" then str = str .. "\f" advance()
                    elseif table.contains(string.digits, char) then
                        local number = char
                        advance()
                        while table.contains(string.digits, char) and #char > 0 do
                            number = number .. char
                            stop = Position(idx, ln, col)
                            advance()
                        end
                        str = str .. string.char(math.min(tonumber(number), 255))
                    else str = str .. char advance() end
                else
                    str = str .. char
                    advance()
                end
            end
            stop = Position(idx, ln, col)
            advance()
            table.insert(tokens, Token("string", str, start, stop))
        else
            return nil, error.nearSymbol(char, file, Position(idx, ln, col), Position(idx, ln, col))
        end
    end
    table.insert(tokens, Token("<eof>", nil, Position(idx, ln, col), Position(idx, ln, col)))
    return tokens
end

return { File=File, Position=Position, Token=Token, lex=lex, keywords=keywords, symbols=symbols }