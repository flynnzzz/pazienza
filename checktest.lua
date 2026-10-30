local Game = require("game").Game
local Card = require("card")

local test = {
	Card:of("A", 11),
	Card:of("B", 12),
	Card:of("C", 5),
	Card:of("C", 6),
	Card:of("B", 5),
	Card:of("A", 12),
	Card:of("C", 6),
	Card:of("D", 11),
	Card:of("A", 10),
	Card:of("C", 1),
	Card:of("C", 4),
	Card:of("B", 3),
	Card:of("B", 6),
	Card:of("D", 1),
	Card:of("A", 4),
	Card:of("A", 7),
	Card:of("B", 10),
	Card:of("A", 9),
}
Game.table = test

print("before matching: " .. Game:tablecompactstr())
Game:check()
print("after matching: " .. Game:tablecompactstr())

local correct_values = { 11, 12, 5, 6, 5, 12, 6, 11, 10, 4, 1, 10, 9 }
local correct_seeds = { "A", "B", "C", "C", "B", "A", "C", "D", "A", "C", "D", "B", "A" }

local function checklenght(t, correct_len)
	assert(#t == correct_len, "table lenght incorrect: " .. tostring(#t) .. " instead of " .. tostring(correct_len))
end

local function checknil(t)
	for i, entry in pairs(t) do
		assert(entry.value ~= nil, "nil value: at index " .. tostring(i))
	end
end

local function checkvalues(t, correct)
	for i, entry in pairs(t) do
		assert(
			entry.value == correct[i],
			"incorrect value: "
				.. tostring(entry.value)
				.. " instead of "
				.. tostring(correct[i])
				.. " at index "
				.. tostring(i)
		)
	end
end

local function checkseeds(t, correct)
	for i, entry in pairs(t) do
		assert(
			entry.seed == correct[i],
			"incorrect value: "
				.. tostring(entry.seed)
				.. " instead of "
				.. tostring(correct[i])
				.. " at index "
				.. tostring(i)
		)
	end
end

local t = Game.table
checklenght(t, #correct_seeds)
checknil(t)
checkvalues(t, correct_values)
checkseeds(t, correct_seeds)
print("All checks passed: 4 / 4")
