local Game = require("game").Game

local start = os.clock()
local Card = require("card")
local test = {
	Card:of("Hea", 11),
	Card:of("Clu", 12),
	Card:of("Spa", 5),
	Card:of("Hea", 6),
	Card:of("Clu", 5),
	Card:of("Hea", 12),
	Card:of("Spa", 6),
	Card:of("Dia", 11),
	Card:of("Hea", 10),
	Card:of("Spa", 1),
	Card:of("Spa", 4),
	Card:of("Clu", 3),
	Card:of("Clu", 6),
	Card:of("Dia", 1),
	Card:of("Hea", 4),
	Card:of("Hea", 7),
	Card:of("Clu", 10),
	Card:of("Hea", 9),
}

Game.table = test

print("before matching: " .. Game:tabletostring())

Game:check()

print("after matching: " .. Game:tabletostring())

local final = os.clock()

print("time elapsed: " .. final - start)
