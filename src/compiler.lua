require "src.global"
local lexer = require("src.lexer")
local parser = require("src.parser")

local file_ = io.open("test/test.mr", "r")
if not file_ then error("file doesn't exist", 2) end
local text = file_:read("*a")
local file = lexer.File("test/test.mr", text)

local tokens, err = lexer.lex(file)
if err then print(tostring(err)) return end
print(table.tostring(tokens))
local node node, err = parser.parse(tokens, file)
if err then print(tostring(err)) return end
print(tostring(node))