package.path = package.path .. ";./src/?.lua;./custom/?.lua;../custom/?.lua"
local USAGE = [[
Usage:
    lua pazienza.lua <action> <deck-type> [options]

Actions:
    play       Play games [-n N] times.
    simulate   Play games until victory.
    binomial   Run 2^20 trials (equivalent to `play -n 1048576`).

Valid deck types:
    italian   Denare, Coppe, Spade, Bastoni
    poker     Hearts, Diamonds, Clubs, Spades
    mahjong   Dots, Bamboo, Characters, Winds, Dragon

Options:
    -h        Verbose output (HIGH)
    -m        Medium verbosity
    -l        Low verbosity
    -z        Minimal verbosity
    -n N      Number of games to play (applies only to 'play')

Notes:
    • Default verbosity for 'play' is HIGH.
    • Default verbosity for 'simulate' is MEDIUM.
    • The 'binomial' action caps at MEDIUM verbosity;
      using the '-h' flag with this action has no effect.
]]

local BINOMIAL_SIMULATION_ROUNDS = math.floor(2 ^ 20)

local Deck = require("deck")
local Logger = require("logger")
local G = require("game")
local Game = G.Game
local Verbosity = G.Verbosity
local Simulation = require("simulation")
local decktypes = require("decktypes")

local actions = {
	play = function(verbosity, times)
		if times == nil then
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
			local result
			if Game:won() then
				result = "> You won!"
			else
				result = "> You lost..."
			end
			Logger.log(result)
		else
			if verbosity == nil then
				Simulation:binomial(times, Verbosity.HIGH)
				return
			end
			Simulation:binomial(times, verbosity)
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

	simulate = function(verbosity)
		if verbosity == nil then
			Simulation:start()
		else
			local counter = Simulation:startwith(verbosity)
			Logger.log("> victory after: " .. counter .. " rounds\n", verbosity == Verbosity.LOWEST)
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
	local n

	for i = 1, #argv do
		local a = argv[i]
		if a == nil then
			goto continue
		end

		if a == "-n" then
			n = tonumber(argv[i + 1])
			table.remove(argv, i + 1)
		elseif a:sub(1, 1) == "-" then
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
		::continue::
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
		return nil, "unknown deck type: '" .. positionals[2] .. "'"
	end

	return { action = action, decktype = seed_t, verbosity = verbosity, times = n }
end

function Main()
	local opts, err = parseargs(arg)
	if opts == nil then
		print("> " .. err)
		io.write(USAGE)
		return
	end

	Game:attachdeck(Deck:new(opts.decktype))
	opts.action(opts.verbosity, opts.times)
end

Main()
