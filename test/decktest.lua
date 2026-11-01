package.path = package.path .. ";../src/?.lua;./src/?.lua;../src/deprecated/?.lua;./src/deprecated/?.lua"
local Deck = require("deck")
local decktypes = require("decktypes")

local a = Deck:new(decktypes.ITALIAN)
local b = Deck:new(decktypes.UNO)
a:printcards()
print()
b:printcards()
