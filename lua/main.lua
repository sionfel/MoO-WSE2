require "save_data"
require "turn_manager"
require "moo_log"
require "generators"
require "moo_strings"
local helpers require "helpers"
local planets require "planets"

InitialLog()


local function write_table(file, tbl, prefix)
    for key, value in pairs(tbl) do
        local full_key = prefix .. "." .. tostring(key)
        if type(value) == "function" then
            file:write(string.format("function %s(...) end\n", full_key))
        elseif type(value) == "string" then
            file:write(string.format("%s = %q\n", full_key, value))
        elseif type(value) == "number" then
            file:write(string.format("%s = %s\n", full_key, tostring(value)))
        elseif type(value) == "boolean" then
            file:write(string.format("%s = %s\n", full_key, tostring(value)))
        elseif type(value) == "table" then
            file:write(string.format("%s = {}\n", full_key))
            write_table(file, value, full_key) -- Recursively handle nested tables
        else
            file:write(string.format("-- %s is of unsupported type '%s'\n", full_key, type(value)))
        end
    end
end


if not file_exists("fake_game.lua") then
    local file = io.open("fake_game.lua", "w+")
    assert(file, "Could not open file for saving.")

    file:write("-- Auto-generated Lua file to clear warnings for the 'game' table\n\n")
    file:write("game = game or {}\n\n")

    write_table(file, game, "game")

    file:close()
end


function ConsoleCommand(cmd)
	print("Console command: " .. cmd)
	if cmd == "reload" then
		WriteLogLine("Reloading main.lua")
		dofile("main.lua")
	elseif cmd == "save" then
		WriteLogLine("Saving game")
		savegame()
	elseif cmd == "load" then
		WriteLogLine("Loading game")
		loadgame()
	elseif cmd == "print" then
		WriteLogLine("Printing message")
		printMessage("Hello from the console!")
	else
		WriteLogLine("Unknown command: " .. cmd)
	end
end

function printMessage(str)
	print("Printed via LUA: " .. str)
end

function Reload()
	dofile("main.lua")
	WriteLogLine("Reloaded main.lua")
end

function BigReload()
	local files = list_files_in_directory("")
    for _, file in ipairs(files) do
		if file ~= "fake_game.lua" then
			if file:match("%.lua$") then
				dofile(file)
				WriteLogLine("Reloaded " .. file)
			end
		end
    end
end

-- local was_true = true

function PressO()
	local key_pressed = game.key_clicked(0x18)
	local map_free = game.map_free()
	
	if key_pressed then
		BigReload()
	end	
end

function PressP()
	local key_pressed = game.key_clicked(game.const.triggers.key_middle_mouse_button)

	if key_pressed then
		print_table_recursive(AllPlanets, 1)

		-- print("P")
		-- inspect_all_planets()
	end
end

function game.OnWorldTrigger(date)
	PressO()
	PressP()
end

function game.OnGameLoad() -- Fires when starting a game either new or via load. Maybe use this to initialize game?
	local curTime = os.date("%A %B %d")
	print(curTime)
end

function game.OnSave()
	savegame()
	WriteLogLine("Saved Game")
end

function game.OnLoadSave()
	loadgame()
	WriteLogLine("Loaded Game")
end

function randomFloat(lower, greater)
    return lower + math.random()  * (greater - lower);
end