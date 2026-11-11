--
-- animation.lua
--
-- Braille spinner loading animation module.
--
-- Circles through 8 frames of the animation.
--

local HIDE_CURSOR = "\x1b[?25l"
local UNHIDE_CURSOR = "\x1b[?25h"
local CLEAR_RIGHT_CURSOR = "\x1b[2K"
local START_SYNC_UPDATE = "\x1b[?2026h"
local END_SYNC_UPDATE = "\x1b[?2026l"
local CARRIAGE_RETURN = "\r"
local DOWN_ONE_LINE = "\x1b[1E"

local Animation = {}
Animation.braille = { "  ⠋", "  ⠙", "  ⠹", "  ⠸", "  ⠼", "  ⠴", "  ⠦", "  ⠧", "  ⠇", "  ⠏" }
Animation.n_frame = 1

function Animation.printframe(frame, condition)
	if not condition then
		return
	end

	local buffer = table.concat({
		START_SYNC_UPDATE,
		HIDE_CURSOR,
		CLEAR_RIGHT_CURSOR,
		frame,
		CARRIAGE_RETURN,
		UNHIDE_CURSOR,
		END_SYNC_UPDATE,
	})

	io.write(DOWN_ONE_LINE)
	io.write(buffer)
	io.flush()
end

function Animation.printnext(condition)
	Animation.printframe(Animation.braille[Animation.n_frame], condition)

	if condition then
		Animation.n_frame = Animation.n_frame + 1
		if Animation.n_frame > #Animation.braille then
			Animation.n_frame = 1
		end
	end
end

function Animation.sleep(seconds)
	local start = os.clock()
	while os.clock() - start < seconds do
	end
end

function Animation.showcase()
	local i = 1
	while i < 100 do
		Animation.printnext(true)
		Animation.sleep(0.1)
		i = i + 1
	end
end

return Animation
