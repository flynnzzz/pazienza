package.path = package.path .. ";../src/?.lua;./src/?.lua;../src/deprecated/?.lua;./src/deprecated/?.lua"
local Deck = require("deck")
local decktypes = require("decktypes")

local d = Deck:new(decktypes.ITALIAN)
d:printcards()
