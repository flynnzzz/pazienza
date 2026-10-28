local Card = {}
Card.__index = Card

function Card:of(seed, value, name)
	local card = setmetatable({}, self)

	if value <= 0 then
		error("card value not allowed: " .. tostring(value))
	end

	card.seed = seed
	if name ~= nil then
		card.name = name
	end
	card.value = value
	return card
end

function Card:__tostring()
	if self.name ~= nil then
		return self.name
	else
		return self.value .. " of " .. self.seed
	end
end

function Card:compactstr()
	if self.name ~= nil then
		return self.name
	else
		local pref = math.min(3, #self.seed)
		return self.value .. " " .. string.sub(self.seed, 1, pref)
	end
end

return Card
