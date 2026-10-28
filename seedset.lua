local Card = require("card")

local function cardset(seed, maxvalue, names)
	local values = {}
	for i = 1, maxvalue do
		if names ~= nil then
			values[i] = Card:of(seed, i, names[i])
		else
			values[i] = Card:of(seed, i)
		end
	end
	return values
end

local SeedSet = {}
SeedSet.__index = SeedSet

function SeedSet:new(seed, maxvalue, names)
	local newseed = setmetatable({}, self)
	newseed.seed = seed
	newseed.maxvalue = maxvalue
	newseed.values = cardset(seed, maxvalue, names)
	return newseed
end

function SeedSet:__tostring()
	local ivalues = {}
	for i, _ in ipairs(self.values) do
		ivalues[i] = i
	end

	return self.seed .. "\n values: " .. table.concat(ivalues, " - ")
end

return SeedSet
