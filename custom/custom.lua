local from_model = require("seedset").from_model
local seeds = {}

local custom = {
	FIRE = {
		name = "Fire",
		value_start = 1,
		value_end = 4,
		specials = {
			JOLLY = { name = "Fire Jolly", value = 1, unique_name = true },
		},
	},
	ICE = {
		name = "Ice",
		value_start = 1,
		value_end = 4,
		specials = {
			JOLLY = { name = "Ice Jolly", value = 1, unique_name = true },
		},
	},
}
seeds.CUSTOM = custom

local UNO_MODEL = {
	name = "Uno Model",
	value_start = 1,
	value_end = 9,
	multiplicity = 2,
	specials = {
		ZERO = { name = "0", value = 0, multiplicity = 1 },
		BLOCK = { name = "Block", value = 10 },
		INVERT = { name = "Invert", value = 10 },
		PLUSTWO = { name = "+2", value = 11 },
	},
}

local uno = {
	RED = from_model(UNO_MODEL, "Red"),
	GREEN = from_model(UNO_MODEL, "Green"),
	BLUE = from_model(UNO_MODEL, "Blue"),
	YELLOW = from_model(UNO_MODEL, "Yellow"),
	JOLLYSET = {
		name = "Jolly Set",
		specials = {
			PLUSFOUR = { name = "+4", value = 11, unique_name = true },
			COLORCHANGE = { name = "Color Change ", value = 11, unique_name = true },
		},
		multiplicity = 4,
	},
}
seeds.UNO = uno

return seeds
