local Logger = require("logger")

local Verbosity = {
	LOWEST = "z",
	LOW = "l",
	MEDIUM = "m",
	HIGH = "h",
}

local Game = { deck = nil, table = {} }

function Game:attachdeck(deck)
	self.deck = deck
end

function Game.match(head, tail)
	return head.seedname == tail.seedname or head.value == tail.value
end

function Game:check()
	local t = self.table
	local pivot = math.max(#t, 3)

	while pivot <= #t do
		if self.match(t[pivot], t[pivot - 2]) then
			table.remove(t, pivot - 2)
			pivot = math.max(pivot - 2, 3)
		else
			pivot = pivot + 1
		end
	end
end

function Game:draw()
	if self.deck == nil then
		error("draw: no deck associated with game, call Game:attachdeck( ... ) to attach")
	end
	table.insert(self.table, self.deck:draw())
end

function Game.drawmul(n)
	for _ = 1, n do
		Game:draw()
	end
end

function Game:won()
	return #self.table == 2
end

function Game:tabletostring()
	local values = {}

	for _, value in ipairs(self.table) do
		values[#values + 1] = tostring(value)
	end

	return "{ " .. table.concat(values, ", ") .. " }"
end

function Game:tablecompactstr()
	local values = {}

	for _, value in ipairs(self.table) do
		values[#values + 1] = value:compactstr()
	end

	return "{ " .. table.concat(values, ", ") .. " }"
end

function Game:playwith(verbosity)
	if self.deck == nil then
		error("playwith: no deck associated with game, call Game:attachdeck() to attach")
	end
	if #self.table > 0 then
		self:restart()
	end

	Game.drawmul(2)
	repeat
		Game:draw()

		if verbosity == Verbosity.HIGH then
			Logger:cache(string.format("> drawing: %s\n", self:tablecompactstr()))
		end

		local cardcount = #self.table
		Game:check()

		if verbosity == Verbosity.HIGH then
			if #self.table < cardcount then
				Logger:cache(string.format(" > matching: %s\n", self:tablecompactstr()))
			end
			Logger:cache(string.format("> cards left: %d\n\n", #self.deck.cards))
		end

	until #self.deck.cards == 0
	Logger:flush(verbosity == Verbosity.HIGH)
end

function Game:play()
	self:playwith(Verbosity.HIGH)
end

function Game:restart()
	self.deck:regenerate()
	self.table = {}
end

return { Game = Game, Verbosity = Verbosity }
