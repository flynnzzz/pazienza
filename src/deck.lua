local SeedSet = require("seedset").SeedSet

local Deck = {}
Deck.__index = Deck

local function addfrom(seedset, pile)
	for _, card in pairs(seedset.cards or {}) do
		for _ = 1, seedset.multiplicity or 1 do
			table.insert(pile, card)
		end
	end
end

local function genfrom_all(seedsets, times)
	local pile = {}

	times = times or 1
	for _ = 1, times do
		for _, seedset in pairs(seedsets or {}) do
			addfrom(seedset, pile)
		end
	end

	return pile
end

function Deck:printcards()
	for _, card in pairs(self.cards) do
		print(tostring(card))
	end
end

function Deck:new(decktype, times)
	local deck = setmetatable({}, self)
	deck.decktype = decktype
	deck.seedsets = {}

	for key, seedtype in pairs(decktype) do
		deck.seedsets[key] = SeedSet:new(seedtype)
	end

	deck.cards = genfrom_all(deck.seedsets, times)
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
	local s = {}
	local i = 1
	for _, seedset in pairs(self.seedsets) do
		s[i] = tostring(seedset)
		i = i + 1
	end
	return table.concat(s, "\n")
end

return Deck
