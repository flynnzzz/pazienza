local Card = require("card")

local function from_model(model, name)
	local copy = {}
	for k, _ in pairs(model) do
		copy[k] = model[k]
	end
	copy.name = name
	return copy
end

local function seedcards(seedtype)
	local cards = {}
	local v_start = seedtype.value_start or 1
	local v_end = seedtype.value_end or 0

	local i = 1
	for value = v_start, v_end do
		for _ = 1, seedtype.multiplicity or 1 do
			cards[i] = Card:of(seedtype.name, value, false)
			i = i + 1
		end
	end

	if seedtype.specials ~= nil then
		for _, special in pairs(seedtype.specials) do
			local multiplicity = special.multiplicity or seedtype.multiplicity
			multiplicity = multiplicity or 1
			for _ = 1, multiplicity do
				cards[i] = Card:of(special.seedname or seedtype.name, special.value, special.unique_name, special.name)
				i = i + 1
			end
		end
	end

	return cards
end

local SeedSet = {}
SeedSet.__index = SeedSet

function SeedSet:new(seedtype)
	local newseed = setmetatable({}, self)
	newseed.seedtype = seedtype
	newseed.cards = seedcards(seedtype)
	return newseed
end

function SeedSet:__tostring()
	local cards = {}
	for i, v in ipairs(self.cards) do
		cards[i] = tostring(v)
	end

	return self.seedtype.name .. ":\n " .. table.concat(cards, "\n ")
end

return { SeedSet = SeedSet, from_model = from_model }
