local json = require("dkjson")
local serializer = require("serializer")
local helpers require "helpers"
require "moo"

local current_main_save_version = 01
local current_races_save_version = 01

-- Saves
function savegame()
	local main_save_file = "additional_savedata/save_" .. game.gvar.g_save_id .. ".json"
    local backup_file = main_save_file .. ".bak"
    
    if file_exists(main_save_file) then
        os.rename(main_save_file, backup_file)
    end
	
	-- save_races_in_list(races) -- These are stored in small modular files for sharing


    game.str_store_troop_name(1, 0)

    local save_data = {
        systems = encode_galaxy(AllSystems),
        players = encode_players(AllPlayers),
        satellites = encode_planets(AllPlanets),
        -- ships = encode_ships(AllShips),
        -- ship_designs = encode_ship_designs(AllShipDesigns),
        race_diffs = encode_race_diffs(),
        colonies = encode_colonies(AllColonies)
    }

    save_data = json.encode(save_data, { indent = true })
    -- print(save_data)

    local file = io.open(main_save_file, "w")
    assert(file, "Could not open file for saving.")
    
    file:write("-- Started at " .. os.date("%Y.%m.%d, %X") .. "\n")
    file:write("-- Save File Version: " .. current_main_save_version .. "\n")
    file:write("-- Name: " .. game.sreg[1] .. "\n\n\n")
    
    file:write(save_data)
    file:close()
end


function loadgame()
    -- sleep(0.5)
	local main_save_file = "additional_savedata/save_" .. game.gvar.g_save_id .. ".json"
	local races_save_dir = "races/"
    -- local next = next
	
    -- Rebuild the races and related global tables
    AllRaces = load_all_races(races_save_dir)

    AllRacesByName = {}

    for _, race in ipairs(AllRaces) do
        AllRacesByName[race.name] = race
    end
    
    local file = io.open(main_save_file, "r")
    assert(file, "Could not open file: " .. main_save_file)

    local json_lines = {}
    for line in file:lines() do
        if line and not line:match("^%s*%-%-") and line:match("%S") then
            table.insert(json_lines, line)
        end
    end
    file:close()

    local content = table.concat(json_lines, "\n")

    local data, pos, err = json.decode(content)
    assert(data, "JSON decode error in " .. main_save_file .. ": " .. tostring(err))
    -- Decode each section
    AllSystems = {}
    AllPlayers = {}
    AllColonies = {}
    AllPlanets = {}

    AllSystems = decode_galaxy(data.systems)
    AllPlanets = decode_planets(data.satellites)
    AllPlayers = decode_players(data.players)
    decode_colonies(data.colonies)
    decode_race_diffs(data.race_diffs)

end

function encode_race_diffs()
    -- load all the races inside the races directory
    -- compare them to the current races existing inside the player's game
    -- and return a json object of the differences

    local races_save_dir = "races/"
    local data = {}

    local base_races = load_all_races(races_save_dir)

	for _, race in ipairs(AllRaces) do
		for _, b_race in ipairs(base_races) do
            if race.name == b_race.name then
                local diff = race_diff(race, b_race)
                if diff then
                    data[race.name] = diff
                end
            end
        end
	end

    return data
end

function decode_race_diffs(race_diffs)

	for _, race in ipairs(race_diffs) do
		for _, b_race in ipairs(AllRaces) do
            if race.name == b_race.name then
                apply_race_diff(b_race, race)
            end
        end
	end
end

function encode_players(players)
    local data = {}

    for _, player in pairs(players) do
        if type(player) == "table" then
            data[_] = Serializer.save(player)
        end
    end

    return data
end

function encode_galaxy(systems)
    local data = {}

    for _, system in pairs(systems) do
        if type(system) == "table" then
            data[_] = Serializer.save(system)
        end
    end

    return data
end

function encode_planets(planets)
    local data = {}

    for _, planet in pairs(planets) do
        if type(planet) == "table" then
            data[_] = Serializer.save(planet)
            data[_].id = _
            local class_name = planet:get_class_name()
            data[_].class = class_name
        end
    end

    return data
end

function encode_colonies(colonies)
    local data = {}

    for key, colony in pairs(colonies) do
        if type(colony) == "table" then
            data[key] = Serializer.save(colony)
        end
    end

    return data
end

function decode_players(players)
    local data = {}
    
    for _, player in pairs(players) do
        if type(player) == "table" then
            if player.is_human then
                data[_] = Player:load_existing(player)
            else
                data[_] = AIPlayer:load_existing(player)
            end
        end
    end

    return data
end

--- func desc
---@param data table
---@return table
function decode_galaxy(systems)
    local data = {}

    for _, system in pairs(systems) do
        if type(system) == "table" then
            data[_] = StarSystem:load_existing(system)
        end
    end

    return data
end

function decode_planets(planets)
    local data = {}
   
    for _, planet in pairs(planets) do
        if type(planet) == "table" then
            if planet.class == "Planet" then
                -- Serializer.load(data, planet)

                data[planet.id] = Planet:new(planet.parent_system, planet.orbit, planet.type)

                data[planet.id].size = planet.size
                data[planet.id].owner = planet.owner or nil
                data[planet.id].atmosphere = planet.atmosphere or true
                data[planet.id].gravity = planet.gravity or "normal"
                data[planet.id].richness = planet.richness or "abundant"
                data[planet.id].type = planet.type or "barren"
                data[planet.id].traits = planet.traits or {}
            else
                data[planet.id] = Satellite:new(planet.parent_system, planet.orbit, planet.type)
            end
        end
    end

    return data
end

function decode_colonies(colonies)
    local data = {}

    for _, colony in pairs(colonies) do
        if type(colony) == "table" then
            data[colony.id] = Colony:load_existing(colony)
        end
    end

    return data
end

function save_races_in_list(list, force)
    -- Ensure the list is valid
    if type(list) ~= "table" then
        error("Invalid input: 'list' must be a table.")
    end

    -- Default the force parameter to false if not provided
    force = force or false

    for _, race in ipairs(list) do
        if type(race) == "table" and race.name then
            save_race(race, force)
        else
            print("Warning: Invalid race object encountered. Skipping...")
        end
    end
end


function save_race(race, force)
    local race_save_file = "races/" .. race.name .. ".json"
    
    if race.is_custom then
        race_save_file = "races/custom" .. race.name .. ".json"
    end

    local force = force or false
	
    if not file_exists(race_save_file) or force then
        if force then WriteLogLine("This race, " .. race.name .. " already exists! Forcing a new version!") end
        
        local trait_ids = {}
        
        for trait_id, _ in pairs(race.traits) do
            table.insert(trait_ids, trait_id)
        end
        
        local data = {
            _version = current_races_save_version,
            name = race.name,
            leader = race.leader,
            traits = trait_ids,
            is_playable = race.is_playable,
            is_custom = race.is_custom,
        }

        if data.is_custom then
            data.base_race = race.base_race
        end
        
        local encoded = json.encode(data, { indent = true }) -- pretty print

        local file = io.open(race_save_file, "w")
        assert(file, "Could not open file for saving.")
        
        file:write("-- Race Name: " .. race.name .. "\n")
        file:write("-- Description: " .. (race.description or "No description") .. "\n\n")
        if race.is_custom then file:write("-- Custom Race by: " .. "\n\n") end
        
        file:write(encoded)
        file:close()
    end
end

function load_all_races(directory)
    local files = list_files_in_directory(directory)
    local loaded_races = {}
    for _, file in ipairs(files) do
        if file:match("%.json$") then
            local race = load_single_race(directory .. file)
            table.insert(loaded_races, race)
        end
    end
    return loaded_races
end

function load_single_race(filename)
    local file = io.open(filename, "r")
    assert(file, "Could not open file: " .. filename)

    local json_lines = {}
    for line in file:lines() do
        if not line:match("^%s*%-%-") then
            table.insert(json_lines, line)
        end
    end
    file:close()

    local content = table.concat(json_lines, "\n")
    local data, pos, err = json.decode(content)
    assert(data, "JSON decode error in " .. filename .. ": " .. tostring(err))

    local race = Race:new(data.name)
    race.leader = data.leader or "none"
    race.is_custom = data.is_custom or false
    if race.is_custom then
        race.base_race = data.base_race
    end
    race.is_playable = data.is_playable or false
    race.traits = {}
    for _, trait_id in ipairs(data.traits or {}) do
        race.traits[trait_id] = RacialTraitDefinitions[trait_id]
    end

    WriteLogLine("Successful loading of " .. race.name .. " from " .. filename)
    return race
end

function file_exists(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    end
    return false
end
