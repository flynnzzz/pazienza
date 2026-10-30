local SeedType = {}
SeedType.__index = SeedType
SeedType.__pairs = function(self)
	local key
	local value

	return function()
		repeat
			key, value = next(self, key)
		until key == nil or type(value) == "string"

		return key, value
	end
end

function SeedType:is_seed(seed)
	for _, v in pairs(self) do
		if v == seed then
			return true
		end
	end
	return false
end

local ITALIAN = setmetatable({
	DENARE = "Denare",
	COPPE = "Coppe",
	SPADE = "Spade",
	BASTONI = "Bastoni",
	maxvalue = 10,
}, SeedType)

local POKER = setmetatable({
	HEARTS = "Hearts",
	DIAMONDS = "Diamonds",
	CLUBS = "Clubs",
	SPADES = "Spades",
	maxvalue = 13,
}, SeedType)

local MAHJONG = setmetatable({
	DOTS = "Dots",
	BAMBOO = "Bamboo",
	CHARACTERS = "Characters",
	maxvalue = 9,
	multiplicity = 4,
	unnumbered = {
		WINDS = {
			name = "Winds",
			setnames = {
				"North Wind",
				"South Wind",
				"East Wind",
				"West Wind",
			},
		},
		DRAGONS = {
			name = "Dragons",
			setnames = {
				"Red Dragon",
				"Green Dragon",
				"White Dragon",
			},
		},
	},
}, SeedType)

return { ITALIAN = ITALIAN, POKER = POKER, MAHJONG = MAHJONG }
