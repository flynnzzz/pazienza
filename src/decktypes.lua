local from_model = require("seedset").from_model

local DeckType = {}
DeckType.__index = DeckType

function DeckType:is_seed(seed)
	for _, v in pairs(self) do
		if v == seed then
			return true
		end
	end
	return false
end

local IT_MODEL = {
	name = "Italian Model",
	value_start = 1,
	value_end = 7,
	specials = {
		FANTE = { name = "Fante", value = 8 },
		CAVALLO = { name = "Cavallo", value = 9 },
		RE = { name = "Re", value = 10 },
	},
}

local italian = setmetatable({
	DENARE = from_model(IT_MODEL, "Denare"),
	COPPE = from_model(IT_MODEL, "Coppe"),
	SPADE = from_model(IT_MODEL, "Spade"),
	BASTONI = from_model(IT_MODEL, "Bastoni"),
}, DeckType)

local POKER_MODEL = {
	name = "Poker Model",
	value_start = 1,
	value_end = 10,
	specials = {
		JACK = { name = "Jack", value = 11 },
		QUEEN = { name = "Queen", value = 12 },
		KING = { name = "King", value = 13 },
	},
}

local poker = setmetatable({
	HEARTS = from_model(POKER_MODEL, "Hearts"),
	DIAMONDS = from_model(POKER_MODEL, "Diamonds"),
	CLUBS = from_model(POKER_MODEL, "Clubs"),
	SPADES = from_model(POKER_MODEL, "Spades"),
}, DeckType)

local MAHJONG_MODEL = {
	name = "Mahjong Model",
	value_start = 1,
	value_end = 9,
	multiplicity = 4,
}

local mahjong = setmetatable({
	DOTS = from_model(MAHJONG_MODEL, "Dots"),
	BAMBOO = from_model(MAHJONG_MODEL, "Bamboo"),
	CHARACTERS = from_model(MAHJONG_MODEL, "Characters"),
	WINDS = {
		name = "Winds",
		specials = {
			NORTH_WIND = { name = "North", value = 100 },
			SOUTH_WIND = { name = "South", value = 101 },
			EAST_WIND = { name = "East", value = 102 },
			WEST_WIND = { name = "West", value = 103 },
		},
	},
	DRAGONS = {
		name = "Dragons",
		specials = {
			RED_DRAGON = { name = "Red", value = 200 },
			GREEN_DRAGON = { name = "Green", value = 201 },
			WHITE_DRAGON = { name = "White", value = 202 },
		},
	},
}, DeckType)

local return_table = { ITALIAN = italian, POKER = poker, MAHJONG = mahjong }

local filefound, custom_seeds = pcall(dofile, "../custom/custom.lua")
if not filefound then
	filefound, custom_seeds = pcall(dofile, "./custom/custom.lua")
end
if not filefound then
	error("decktypes: custom module `custom.lua` could not be loaded")
end

-- TODO: parser error handler
for key, value in pairs(custom_seeds) do
	local custom = setmetatable(value, DeckType)
	return_table[key] = custom
end

return return_table
