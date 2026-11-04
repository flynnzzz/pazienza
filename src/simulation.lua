local Logger = require("logger")
local G = require("game")
local Game = G.Game
local Verbosity = G.Verbosity

local Simulation = {
	game = Game,
}

function Simulation:startwith(s_verbosity, g_verbosity)
	local won = false
	local counter = 1
	local winningpiles

	local start = os.clock()
	Logger.log("> starting simulation...\n", (s_verbosity == Verbosity.MEDIUM) or (s_verbosity == Verbosity.HIGH))

	repeat
		Game:playwith(g_verbosity)
		won = Game:won()
		if won then
			winningpiles = Game:tabletostring()
		end
		if s_verbosity == Verbosity.MEDIUM or s_verbosity == Verbosity.HIGH then
			Logger:cache(string.format("%d. %s", counter, Game:tabletostring()))
		elseif s_verbosity == Verbosity.LOW and (counter % 50 == 0) then
			Logger:cache(string.format("%d. %s", counter, Game:tablecompactstr()))
		end

		counter = counter + 1
	until won
	Logger:flush((s_verbosity == Verbosity.MEDIUM) or (s_verbosity == Verbosity.LOW))

	local elapsed = os.clock() - start

	Logger.log(string.format("%d. %s", counter - 1, Game:tablecompactstr()), s_verbosity == Verbosity.LOWEST)
	Logger.log(
		string.format(
			"> achieved victory after %d rounds (%.4f seconds)\n> winning piles: %s",
			counter - 1,
			elapsed,
			winningpiles
		)
	)

	return counter
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
function Simulation:binomial(N, s_verbosity, g_verbosity)
	Logger.log("> running " .. N .. " game loops...")

	local nW = 0
	local start = os.clock()
	if (s_verbosity == Verbosity.HIGH) or (s_verbosity == Verbosity.MEDIUM) or (s_verbosity == Verbosity.LOW) then
		Logger.log("> victories:")
	end
	for i = 1, N do
		Game:playwith(g_verbosity)
		if Game:won() then
			nW = nW + 1
			if (s_verbosity == Verbosity.HIGH) or (s_verbosity == Verbosity.MEDIUM) then
				Logger:cache(string.format("%d: %s", i, Game:tablecompactstr()))
			elseif s_verbosity == Verbosity.LOW then
				Logger:cache(tostring(i))
			end
		end
	end
	local elapsed = os.clock() - start

	Logger:flush(true, ", ")

	if nW == 0 then
		Logger.log("> Not a single win could be achieved")
		return
	end

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
