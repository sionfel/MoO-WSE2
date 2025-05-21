GameManager = {
    turn = 0,
    on_turn_start = {},
    on_turn_end = {},
}

function GameManager.on_start(callback)
    table.insert(GameManager.on_turn_start, callback)
end

function GameManager.on_end(callback)
    table.insert(GameManager.on_turn_end, callback)
end

function GameManager.next_turn()
    GameManager.turn = GameManager.turn + 1
    print("Turn " .. GameManager.turn .. " begins")

    -- Run start-of-turn listeners
    for _, callback in ipairs(GameManager.on_turn_start) do
        callback()
    end

    -- Possibly let player and AI take actions here...

    -- Run end-of-turn listeners
    for _, callback in ipairs(GameManager.on_turn_end) do
        callback()
    end
end

