local USAGE = [[
Usage:
  lua pazienza.lua <ACTION> <SEEDTYPE> [OPTIONS]

Actions:
  play              Play one game
  simulate          Play games until victory
  average            Calculate the average win rate

Seedtypes:
  italian           Denare, Coppe, Spade, Bastoni
  poker             Hearts, Diamonds, Clubs, Spades
  mahjong           Dots, Bamboo, Characters, Winds, Dragon

Options:
  -z                Set verbosity to LOWEST
  -l                Set verbosity to LOW
  -m                Set verbosity to MEDIUM
  -h                Set verbosity to HIGH

Default verbosity values:
 - play: HIGH
 - simulate: MEDIUM
 - average: LOWEST
 Action 'average's verbosity is capped to MEDIUM, passing '-h' produces the same
 result as '-m'.
]]

local AVERAGE_SIMULATION_ROUNDS = math.floor(2 ^ 12)
local BINOMIAL_SIMULATION_ROUNDS = math.floor(2 ^ 20)

local Deck = require("deck")
local Logger = require("logger")
local G = require("game")
local Game = G.Game
local Verbosity = G.Verbosity
local SeedType = require("seedtype")

local Simulation = {
	game = Game,
}

function Simulation:startwith(verbosity)
	local won = false
	local counter = 0
	local winningpiles

	local start = os.clock()
	Logger.log("> starting simulation...\n", verbosity == Verbosity.MEDIUM)

	repeat
		Game:playwith(verbosity)
		won = Game:won()
		if won then
			winningpiles = Game:tabletostring()
		end
		if verbosity == Verbosity.MEDIUM then
			Logger:cache(string.format("%d. %s\n", counter + 1, Game:tablecompactstr()))
		end

		counter = counter + 1
	until won
	Logger:flush(verbosity == Verbosity.MEDIUM)

	local elapsed = os.clock() - start

	Logger.log(
		string.format(
			"> achieved victory after %d rounds (%.4f seconds)\n> winning piles: %s",
			counter,
			elapsed,
			winningpiles
		),
		verbosity ~= Verbosity.LOWEST
	)

	return counter
end

function Simulation:start()
	self:startwith(Verbosity.MEDIUM)
end

-- let W = `winning the game`
-- law of large numbers:
--    p(W) ~= nW/N = p (N >> 1)
--
-- let X = `number of wins`
-- then X ~ B(N, p)
-- and p(X = nW) = binom(N, nW)p^nW * (1 - p)^(N - nW),
--     E[X = nW] = p * nW = m
-- that can be approximated to:
--    X ~ Po(m)
--    where p(X = nW) = (m^nW * e^-m) \ m!
--

-- set a target `nW`
function Simulation:average(nW, verbosity)
	Logger.log("> running " .. nW .. " simulation loops...")

	local N = 0
	local start = os.clock()
	for _ = 1, nW do
		local gamesplayed = self:startwith(verbosity)
		N = N + gamesplayed
	end
	local elapsed = os.clock() - start

	local p = nW / N
	local average = N / nW
	Logger.log(string.format(
		[[
 > time elapsed: %.4f s
 > average winchance: %.8f %%
 > average # of games to win: %.1f
 > total # of games played: %d]],
		elapsed,
		p * 100,
		average,
		N
	))
end

-- set a target `N`
function Simulation:binomial(N, verbosity)
	Logger.log("> running " .. N .. " game loops...")

	local nW = 0
	local start = os.clock()
	for _ = 1, N do
		Game:playwith(verbosity)
		if Game:won() then
			nW = nW + 1
		end
	end
	local elapsed = os.clock() - start

	local p = nW / N
	local average = N / nW
	local expected_value = N * p
	local variance = N * p * (1 - p)
	Logger.log(string.format(
		[[
 > time elapsed: %.4f s
 > average winchance: %.8f %%
 > average # of games to win: %.1f
 > total # of games played: %d

    > X ~ B(%d, %.8f)

 > E[X]: %.2f
 > Var(X): %.2f]],
		elapsed,
		p * 100,
		average,
		N,
		N,
		p,
		expected_value,
		variance
	))

	return average
end

local actions = {
	play = function(verbosity)
		if verbosity == nil then
			Game:play()
		else
			Game:playwith(verbosity)
			Logger.log(
				"> final round: " .. Game:tabletostring(),
				verbosity == Verbosity.MEDIUM or verbosity == Verbosity.HIGH
			)
			Logger.log("> " .. Game:tablecompactstr(), verbosity == Verbosity.LOW)
		end
		if Game:won() then
			Logger.log("> You won!")
		else
			Logger.log("> You lost...")
		end
	end,

	simulate = function(verbosity)
		if verbosity == nil then
			Simulation:start()
		else
			local counter = Simulation:startwith(verbosity)
			Logger.log("> victory after: " .. counter .. " rounds\n", verbosity == Verbosity.LOWEST)
		end
	end,

	average = function(verbosity)
		if verbosity == nil then
			Simulation:average(AVERAGE_SIMULATION_ROUNDS, Verbosity.LOWEST)
		else
			if verbosity == Verbosity.HIGH then
				verbosity = Verbosity.MEDIUM
			end
			Simulation:average(AVERAGE_SIMULATION_ROUNDS, verbosity)
		end
	end,

	binomial = function(verbosity)
		if verbosity == nil then
			Simulation:binomial(BINOMIAL_SIMULATION_ROUNDS, Verbosity.LOWEST)
		else
			if verbosity == Verbosity.HIGH then
				verbosity = Verbosity.MEDIUM
			end
			Simulation:binomial(BINOMIAL_SIMULATION_ROUNDS, verbosity)
		end
	end,
}
local VERBOSITY_FLAGS = {
	["-z"] = Verbosity.LOWEST,
	["-l"] = Verbosity.LOW,
	["-m"] = Verbosity.MEDIUM,
	["-h"] = Verbosity.HIGH,
}

local SEEDTYPES = {
	italian = SeedType.Italian,
	poker = SeedType.Poker,
	mahjong = SeedType.Mahjong,
}

local function parseargs(argv)
	local positionals = {}
	local verbosity

	for i = 1, #argv do
		local a = argv[i]
		if a:sub(1, 1) == "-" then
			local v = VERBOSITY_FLAGS[a]
			if v == nil then
				return nil, "unrecognized flag: '" .. a .. "'"
			end
			if verbosity ~= nil then
				return nil, "only one flag allowed"
			end
			verbosity = v
		else
			positionals[#positionals + 1] = a
		end
	end

	if #positionals < 1 then
		return nil, "no action specified"
	end
	if #positionals < 2 then
		return nil, "no seed type specified"
	end
	if #positionals > 2 then
		return nil, "unexpected argument: '" .. positionals[3] .. "'"
	end

	local action = actions[positionals[1]]
	if action == nil then
		return nil, "unknown action: '" .. positionals[1] .. "'"
	end

	local seed_t = SEEDTYPES[positionals[2]]
	if seed_t == nil then
		return nil, "unknown seed type: '" .. positionals[2] .. "'"
	end

	return { action = action, seedtype = seed_t, verbosity = verbosity }
end

function Main()
	local opts, err = parseargs(arg)
	if opts == nil then
		print("> " .. err)
		io.write(USAGE)
		return
	end

	Game:attachdeck(Deck:new(opts.seedtype))
	opts.action(opts.verbosity)
end

Main()
