--[[
	turn_manager.lua
]]

local game_manager = require "game_manager"

function NextTurn()
	game.gvar.g_turns_taken = game.gvar.g_turns_taken + 1
	game.gvar.g_random_seed = game.gvar.g_random_seed + 1
	WriteLogLine("New turn " .. game.gvar.g_turns_taken)
end

TurnQueue = {
    empires = {},    -- ordered list of empires
    index = 1,       -- whose turn is it?
    active = false   -- is a round currently running?
}

function TurnQueue.register(empire)
    table.insert(TurnQueue.empires, empire)
end

function TurnQueue.next()
    local empire = TurnQueue.empires[TurnQueue.index]
    
    if empire and empire.on_start_turn then
        empire:on_start_turn()
    end

    if empire.is_human then
        -- Wait for player to finish (they'll call TurnQueue.complete())
        return
    else
        empire:take_turn()
        TurnQueue.complete() -- auto-finish for AI
    end
end

function TurnQueue.complete()
    local empire = TurnQueue.empires[TurnQueue.index]

    if empire and empire.on_end_turn then
        empire:on_end_turn()
    end

    TurnQueue.index = TurnQueue.index + 1

    if TurnQueue.index > #TurnQueue.empires then
        -- End of round: all empires acted
        TurnQueue.end_round()
    else
        -- Start next empire's turn
        TurnQueue.next()
    end
end

function TurnQueue.end_round()
    TurnQueue.index = 1
    GameManager.next_turn() -- advances turn, fires global hooks

    TurnQueue.next() -- begin next round
end

function TurnQueue:remove(empire)
	for pos, player in pairs(TurnQueue.empires) do
		if player == empire then
			table.remove(TurnQueue.empires, pos)
		end
	end
end

function TurnQueue:insert(empire)
	table.insert(TurnQueue.empires, empire)
end

function TurnQueue:get_active()
	local empires = {}
	for key, player in pairs(TurnQueue.empires) do
		empires[key] = player
	end
	return empires
end