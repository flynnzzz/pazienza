local Logger = require("logger")
local G = require("game")
local Game = G.Game
local Verbosity = G.Verbosity

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

--
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

> binomial:

    X ~ B(%d, %.8f)

 > E[X]: %.2f
 > Var(X): %.2f]],
		elapsed,
		p * 100,
		average,
		N,
		p,
		expected_value,
		variance
	))

	return average
end

return Simulation
