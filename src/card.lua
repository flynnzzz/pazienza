local Card = {}
Card.__index = Card

function Card:of(seedname, value, has_unique_name, cardname)
	local card = setmetatable({}, self)

	card.seedname = seedname
	card.value = value
	card.cardname = cardname or tostring(card.value)
	card.has_unique_name = has_unique_name
	return card
end

function Card:__tostring()
	if self.has_unique_name then
		return self.cardname
	else
		return self.cardname .. " of " .. self.seedname
	end
end

function Card:compactstr()
	if self.has_unique_name then
		return self.cardname
	else
		local pref = math.min(3, #self.seedname)
		return self.cardname .. " " .. string.sub(self.seedname, 1, pref)
	end
end

return Card
