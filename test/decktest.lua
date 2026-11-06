package.path = package.path .. ";../src/?.lua;./src/?.lua;../src/deprecated/?.lua;./src/deprecated/?.lua"
local Deck = require("deck")
local decktypes = require("decktypes")

local function check_deck(decktype, cardcount)
	local d = Deck:new(decktype)
	local deckcardcount = #d.cards
	assert(deckcardcount == cardcount, "wrong card count:" .. deckcardcount .. " instead of " .. cardcount)
end

check_deck(decktypes.ITALIAN, 4 * 10)
check_deck(decktypes.POKER, 4 * 13)
check_deck(decktypes.MAHJONG, 4 * ((3 * 9) + 3 + 4))

print("All checks passed: 3 / 3")
