local from_model = require("seedset").from_model
local seeds = {}

local custom = {
	FIRE = {
		name = "Fire",
		value_start = 1,
		value_end = 4,
		specials = {
			JOLLY = { name = "Jolly", value = 1 },
		},
	},
}
seeds.CUSTOM = custom

return seeds
