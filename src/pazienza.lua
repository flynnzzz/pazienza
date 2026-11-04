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
local G = require("game")
local Game = G.Game
local Verbosity = G.Verbosity
local Simulation = require("simulation")
local decktypes = require("decktypes")

local actions = {
	play = function(s_verbosity, _, times)
		if times == nil then
			Game:playwith(s_verbosity or Verbosity.HIGH)
		else
			Simulation:binomial(times, s_verbosity or Verbosity.HIGH, Verbosity.ZERO)
		end
	end,

	binomial = function(s_verbosity, g_verbosity)
		if s_verbosity == Verbosity.HIGH then
			s_verbosity = Verbosity.MEDIUM
		end
		Simulation:binomial(BINOMIAL_SIMULATION_ROUNDS, s_verbosity or Verbosity.LOWEST, g_verbosity)
	end,

	simulate = function(s_verbosity, g_verbosity)
		Simulation:startwith(s_verbosity or Verbosity.MEDIUM, g_verbosity)
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

	-- `game verbosity`
	local g_verbosity
	if opts.verbosity ~= Verbosity.HIGH then
		g_verbosity = Verbosity.ZERO
	else
		g_verbosity = Verbosity.HIGH
	end
	opts.action(opts.verbosity, g_verbosity, opts.times)
end

Main()
