local USAGE = [[
Usage:
  lua pazienza.lua <ACTION> <SEEDTYPE> [OPTIONS]

Actions:
  play              Play one game
  simulate          Play games until victory
  average           Simulate repeatedly to get an average winchance
  binomial          Derive info through the binomial distribution

Default decktypes:
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
 Actions `average` and `binomial`s verbosities are capped to MEDIUM, passing '-h' produces the same
 result as '-m'.
]]

local AVERAGE_SIMULATION_ROUNDS = math.floor(2 ^ 12)
local BINOMIAL_SIMULATION_ROUNDS = math.floor(2 ^ 20)

local Deck = require("deck")
local Logger = require("logger")
local G = require("game")
local Game = G.Game
local Verbosity = G.Verbosity
local Simulation = require("simulation")
local decktypes = require("decktypes")

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

	local decktype = string.upper(positionals[2])
	local seed_t = decktypes[decktype]
	if seed_t == nil then
		return nil, "unknown seed type: '" .. positionals[2] .. "'"
	end

	return { action = action, decktype = seed_t, verbosity = verbosity }
end

function Main()
	local opts, err = parseargs(arg)
	if opts == nil then
		print("> " .. err)
		io.write(USAGE)
		return
	end

	Game:attachdeck(Deck:new(opts.decktype))
	opts.action(opts.verbosity)
end

Main()
