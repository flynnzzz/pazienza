local SeedSet = require("seedset")

local Deck = {}
Deck.__index = Deck

local function generate(deck, times)
	local pile = {}
	local n = times or 1

	if deck.seedtype == nil then
		error("generate: seedtype not set")
	end

	for _ = 1, n do
		for _, s in pairs(deck.seedtype) do
			for _, v in pairs(deck[s].values) do
				table.insert(pile, v)
			end
		end
		for _, entry in pairs(deck.seedtype.unnumbered or {}) do
			for _, v in ipairs(deck[entry.name].values) do
				table.insert(pile, v)
			end
		end
	end

	return pile
end

function Deck:printcards()
	if self.seedtype == nil then
		error("printcards: seedtype not set")
	end
	local seedtype = self.seedtype
	for _ = 1, seedtype.multiplicity or 1 do
		for _, seed in pairs(seedtype) do
			for _, v in pairs(self[seed].values) do
				print(tostring(v))
			end
		end
		for _, entry in pairs(seedtype.unnumbered or {}) do
			for _, v in ipairs(self[entry.name].values) do
				print(tostring(v))
			end
		end
	end
end

function Deck:new(seedtype, times)
	local deck = setmetatable({}, self)
	deck.seedtype = seedtype

	seedtype.multiplicity = seedtype.multiplicity or 1
	times = times or 1
	deck.multiplicity = seedtype.multiplicity * times

	for _, setname in pairs(seedtype) do
		deck[setname] = SeedSet:new(setname, seedtype.maxvalue)
	end

	local unnumbered = seedtype.unnumbered
	if unnumbered ~= nil then
		for _, entry in pairs(unnumbered) do
			local namelist = entry.setnames
			deck[entry.name] = SeedSet:new(entry.name, #namelist, namelist)
		end
	end

	deck.cards = generate(deck, deck.multiplicity)
	deck.template = table.move(deck.cards, 1, #deck.cards, 1, {})

	return deck
end

function Deck:regenerate()
	self.cards = table.move(self.template, 1, #self.template, 1, {})
	return self.cards
end

function Deck:draw()
	local i = math.random(1, #self.cards)
	local drawn = self.cards[i]

	self.cards[i] = self.cards[#self.cards]
	self.cards[#self.cards] = nil

	return drawn
end

function Deck:__tostring()
	if self.seedtype ~= nil then
		error("__tostring: seedtype not set")
	end
	local s = {}
	for i, v in ipairs(self.seedtype) do
		s[i] = tostring(self[v])
	end
	return table.concat(s, "\n")
end

return Deck
