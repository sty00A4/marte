local lexer = require("src.lexer")

local file = io.open("test/test.mr", "r")
if not file then error("file doesn't exist", 2) end
local text = file:read()

local tokens, err = lexer.lex(lexer.File("test/test.mr", text))
if err then print(tostring(err)) return end
print(table.tostring(tokens))