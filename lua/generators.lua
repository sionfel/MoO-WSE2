--[[
	generators.lua
]]

require "traits"
require "systems"
require "planets"
require "races"
require "nebulas"
require "moo_strings"
require "moo_log"
require "moo"
require "player"
require "colony"
require "moo"
local helpers require "helpers"
local class require "class"

local universe_size_keys = {
		"small",
		"medium",
		"large",
		"cluster",
		"huge"
}

local universe_sizes =
	{
		small = 24,
		medium = 48,
		large = 70,
		cluster = 70,
		huge = 108
}

function UniverseGeneration()
	math.randomseed(game.gvar.g_save_id)
	game.str_store_troop_name(1, 0)
	local size_key_index = game.gvar.g_galaxy_size + 1
	local civ_count = game.gvar.g_player_count + 1
	local playername = game.sreg[1]
	local playerrace = "Human"

	local max_neighbors = 3 + game.gvar.g_galaxy_size
	
	if size_key_index < 1 or size_key_index > #universe_size_keys then
		error("Invalid galaxy size index: " .. tostring(game.gvar.g_galaxy_size))
	end
	local size = universe_size_keys[size_key_index]
	AllSystems = {}
	
	local player_ini_list = {}
	table.insert(player_ini_list, {playerrace, true, playername, {0, 0, 0}})

	local available_race = deepcopy(playable_race_names)

	for i,v in pairs(available_race) do
        if v == playerrace then
            table.remove(available_race,i)
            break
        end
    end

	for i = 1, civ_count do
		local race
		local rand = math.random(1, #available_race)
		race = available_race[rand]
		print(race)

		for i,v in pairs(available_race) do
			if v == race then
				table.remove(available_race, i)
				break
			end
		end

		table.insert(player_ini_list, {race, false})
	end

	parsec_scale = 10 -- 1 parsec = 3 units in game
	galaxy_width = 1.25 *  calculate_min_galaxy_width(universe_sizes[size], parsec_scale)
	
	-- Take size, run the rest
	NebulaGeneration(size)
	StarGeneration(size)
	-- StarLocationCheck()
	StarNeighborGraph(max_neighbors)
	-- PullStarsCloser(3)
	SatelliteGeneration()
	RaceGeneration()
	AddPlayers(player_ini_list, #player_ini_list)
	HomeWorldGeneration()
	-- Now that we have our home worlds, check that they have another medium habitable planet within 2 parsecs
	-- and that they gave the human players some breathing room
	for _, player in pairs(AllPlayers) do
		TurnQueue.register(player)
	end
end

function NebulaGeneration(size)
	local nebula_min = 0
	local nebula_max = 1
	
	if size == "medium" then
		nebula_min = 1
		nebula_max = 2
	elseif size == "large" then
		nebula_min = 2
		nebula_max = 3
	elseif size == "huge" or size == "cluster" then
		nebula_min = 2
		nebula_max = 4
	end

	local width = 1.25 * calculate_min_galaxy_width(universe_sizes[size], parsec_scale)
	
	local nebula_count = math.random(nebula_min, nebula_max)
	
	for i = 1, nebula_count do
		-- Nebula Generation Code Here
		WriteLogLine("Nebula " .. i .. " generated")
	end
end

function StarGeneration(size)

	local star_count = universe_sizes[size]
	local minimum_distance = parsec_scale
	
	local stars = {}
	if size == "cluster" then
		stars = place_stars_clustered(star_count, minimum_distance, 4)
	else
		stars = place_stars_random(star_count, minimum_distance)
	end

	-- TODO: Write a more complex special system that weighs the value of each special
	-- as well as how many of each have already been given
	-- i.e. if there have been 4 caches but zero high values, lower the weight of cache
	-- while raising the weight of 
	local total_special_planets = 0
	for _, star in ipairs(stars) do
		local rand = math.random()
		
		if rand > 0.64 then
			-- give system a trait
			total_special_planets = total_special_planets + 1
			local random_trait = math.random(1, #SystemTraitsKey)
			star:add_trait(SystemTraitsKey[random_trait])
			WriteLogLine("System: " .. star.name .. "got a special trait of " .. SystemTraitsKey[random_trait])
			if SystemTraitsDefinitions[SystemTraitsKey[random_trait]].high_value then
				rand = math.random()
				if rand > 0.70 then
					star:add_trait("monster")
					WriteLogLine("Also a monster!")
				end
			end
		end

		-- table.insert(AllSystems, star)
		AllSystems[star.party_id] = star
	end

	local system_count = table_length(AllSystems)
	WriteLogLine("A total of " .. system_count .. " systems were generated")
	WriteLogLine(total_special_planets .. " are special: " .. string.format("%.2f", total_special_planets / system_count * 100).. "%!")
	local color_counts = count_star_colors(AllSystems)
	
	for color, count in pairs(color_counts) do
		WriteLogLine(string.format("Color: %-10s Count: %d", color, count))
	end
	
end

function StarLocationCheck()
    for _, system in pairs(AllSystems) do 
        local my_position = get_party_position(system.party_id)
        local min_dist = math.huge
        local nearest_id = nil
        
        for _, comp_system in pairs(AllSystems) do 
            if system ~= comp_system then
                local comp_position = get_party_position(comp_system.party_id)
                local dist = distance(comp_position.o.x, comp_position.o.y, my_position.o.x, my_position.o.y)
                
                if dist < min_dist then
                    min_dist = dist
                    nearest_id = comp_system.party_id
                end
            end
        end

        system.nearest_neighbor = nearest_id
        
        if nearest_id then
            local neighbor = AllSystems[nearest_id]
            WriteLogLine(system.name .. " nearest neighbor is " .. neighbor.name .. " at a distance of: " .. math.floor(min_dist) .. " km or " .. math.floor(min_dist / parsec_scale) .. " parsecs!")
        else
            WriteLogLine(system.name .. " has no valid neighbors!")
        end
    end
end

function StarNeighborGraph(max_neighbors)
    max_neighbors = max_neighbors or 3  -- Default 3 nearest if not specified

    for _, system in pairs(AllSystems) do
        local my_position = get_party_position(system.party_id)
        local distances = {}

        -- Build list of (comp_system, distance)
        for _, comp_system in pairs(AllSystems) do
            if system ~= comp_system then
                local comp_position = get_party_position(comp_system.party_id)
                local dist = distance(comp_position.o.x, comp_position.o.y, my_position.o.x, my_position.o.y)
                table.insert(distances, {comp_system.party_id, dist})
            end
        end

        -- Sort by distance
        table.sort(distances, function(a, b) return a[2] < b[2] end)

        -- Pick the closest N
        system.nearest_neighbors = {}
        for i = 1, math.min(max_neighbors, #distances) do
            table.insert(system.nearest_neighbors, distances[i][1]) -- store party_id
        end

        -- Optionally, log it
        for _, neighbor_id in ipairs(system.nearest_neighbors) do
            local neighbor = AllSystems[neighbor_id]
            WriteLogLine(system.name .. " close neighbor: " .. neighbor.name)
        end
    end
end

function PullStarsCloser(min_parsecs)
    local min_distance = min_parsecs * parsec_scale

    for _, system in pairs(AllSystems) do
        local my_position = get_party_position(system.party_id)

		local nearest_neighbor_dist = math.huge
		local nearest_neighbor = nil
		for _, neighbor_id in ipairs(system.nearest_neighbors or {}) do
			local neighbor = AllSystems[neighbor_id]
            local neighbor_position = get_party_position(neighbor.party_id)
            local dist = distance(my_position.o.x, my_position.o.y, neighbor_position.o.x, neighbor_position.o.y)
			nearest_neighbor_dist = math.min(nearest_neighbor_dist, dist)
			nearest_neighbor = neighbor
		end

		if nearest_neighbor_dist > 5 * parsec_scale then
			-- scootch my nearest neighbot within 3m of me then, jerks
			
		end
        for _, neighbor_id in ipairs(system.nearest_neighbors or {}) do
            local neighbor = AllSystems[neighbor_id]
            local neighbor_position = get_party_position(neighbor.party_id)
            local dist = distance(my_position.o.x, my_position.o.y, neighbor_position.o.x, neighbor_position.o.y)

            if dist > min_distance then
                -- Calculate a vector between the two systems
                local dx = neighbor_position.o.x - my_position.o.x
                local dy = neighbor_position.o.y - my_position.o.y

                -- Normalize vector
                local length = math.sqrt(dx*dx + dy*dy)
                if length > 0 then
                    dx = dx / length
                    dy = dy / length

                    -- Move each system halfway toward each other
                    local move_amount = (dist - min_distance) / 2

                    my_position.o.x = my_position.o.x + dx * move_amount
                    my_position.o.y = my_position.o.y + dy * move_amount
                    neighbor_position.o.x = neighbor_position.o.x - dx * move_amount
                    neighbor_position.o.y = neighbor_position.o.y - dy * move_amount

                    -- Update their in-game positions
                    game.party_set_position(system.party_id, my_position)
                    game.party_set_position(neighbor.party_id, neighbor_position)
                end
            end
        end
    end
end

function PullStarsCloserToSpecificSystem(system_id, min_parsecs)
	local min_distance = min_parsecs * parsec_scale
	local system = AllSystems[system_id]
	local my_position = get_party_position(system_id)

	for _, neighbor_id in ipairs(system.nearest_neighbors or {}) do
		local neighbor = AllSystems[neighbor_id]
		local neighbor_position = get_party_position(neighbor.party_id)
		local dist = distance(my_position.o.x, my_position.o.y, neighbor_position.o.x, neighbor_position.o.y)

		if dist > min_distance then
			-- Calculate a vector between the two systems
			local dx = neighbor_position.o.x - my_position.o.x
			local dy = neighbor_position.o.y - my_position.o.y

			-- Normalize vector
			local length = math.sqrt(dx*dx + dy*dy)
			if length > 0 then
				dx = dx / length
				dy = dy / length

				-- Move each system halfway toward each other
				local move_amount = (dist - min_distance) / 2

				my_position.o.x = my_position.o.x + dx * move_amount
				my_position.o.y = my_position.o.y + dy * move_amount
				neighbor_position.o.x = neighbor_position.o.x - dx * move_amount
				neighbor_position.o.y = neighbor_position.o.y - dy * move_amount

				-- Update their in-game positions
				game.party_set_position(system.party_id, my_position)
				game.party_set_position(neighbor.party_id, neighbor_position)
			end
		end
	end
end


function SatelliteGeneration()
	AllPlanets = {}
	local max_id = 1
	for _, system in pairs(AllSystems) do
		local sys = system
		local star_color = sys.star_color
		local galaxy_age = game.gvar.g_galaxy_age
		local organic_rich = 1
		local mineral_rich = 2
		local rand = math.random()

		local satellite_count_list = {}
		local richness_table = {}

		if star_color == "red" then
			add_to_weighted_list(satellite_count_list, 0, 1)
			add_to_weighted_list(satellite_count_list, 1, 3)
			add_to_weighted_list(satellite_count_list, 2, 3)
			add_to_weighted_list(satellite_count_list, 3, 2)
			add_to_weighted_list(satellite_count_list, 4, 1)

			add_to_weighted_list(richness_table, 1, 2)
			add_to_weighted_list(richness_table, 2, 4)
			add_to_weighted_list(richness_table, 3, 4)
		elseif star_color == "green" then
			add_to_weighted_list(satellite_count_list, 2, 3)
			add_to_weighted_list(satellite_count_list, 3, 2)
			add_to_weighted_list(satellite_count_list, 4, 2)
			add_to_weighted_list(satellite_count_list, 5, 3)

			add_to_weighted_list(richness_table, 1, 1)
			add_to_weighted_list(richness_table, 2, 4)
			add_to_weighted_list(richness_table, 3, 4)
			add_to_weighted_list(richness_table, 4, 1)
		elseif star_color == "yellow" then
			add_to_weighted_list(satellite_count_list, 1, 1)
			add_to_weighted_list(satellite_count_list, 2, 3)
			add_to_weighted_list(satellite_count_list, 3, 2)
			add_to_weighted_list(satellite_count_list, 4, 2)
			add_to_weighted_list(satellite_count_list, 5, 2)

			-- add_to_weighted_list(richness_table, 1, 1)
			add_to_weighted_list(richness_table, 2, 3)
			add_to_weighted_list(richness_table, 3, 5)
			add_to_weighted_list(richness_table, 4, 3)
			add_to_weighted_list(richness_table, 5, 1)
		elseif star_color == "blue" then
			add_to_weighted_list(satellite_count_list, 0, 1)
			add_to_weighted_list(satellite_count_list, 1, 2)
			add_to_weighted_list(satellite_count_list, 2, 1)
			add_to_weighted_list(satellite_count_list, 3, 2)
			add_to_weighted_list(satellite_count_list, 4, 2)
			add_to_weighted_list(satellite_count_list, 5, 2)

			-- add_to_weighted_list(richness_table, 1, 1)
			-- add_to_weighted_list(richness_table, 2, 3)
			add_to_weighted_list(richness_table, 3, 4)
			add_to_weighted_list(richness_table, 4, 4)
			add_to_weighted_list(richness_table, 5, 2)
		elseif star_color == "white" then
			add_to_weighted_list(satellite_count_list, 0, 1)
			add_to_weighted_list(satellite_count_list, 1, 3)
			add_to_weighted_list(satellite_count_list, 2, 2)
			add_to_weighted_list(satellite_count_list, 3, 2)
			add_to_weighted_list(satellite_count_list, 4, 2)

			-- add_to_weighted_list(richness_table, 1, 1)
			add_to_weighted_list(richness_table, 2, 2)
			add_to_weighted_list(richness_table, 3, 4)
			add_to_weighted_list(richness_table, 4, 3)
			add_to_weighted_list(richness_table, 5, 1)
		elseif star_color == "neutron" then
			add_to_weighted_list(satellite_count_list, 0, 7)
			add_to_weighted_list(satellite_count_list, 1, 3)

			--add_to_weighted_list(richness_table, 1, 1)
			add_to_weighted_list(richness_table, 2, 1)
			add_to_weighted_list(richness_table, 3, 5)
			add_to_weighted_list(richness_table, 4, 3)
			add_to_weighted_list(richness_table, 5, 1)
		end

		local total_satellites = weighted_random(satellite_count_list)
		-- Now that we know the total satellites, we're going to
		-- see which orbit each one is in

		local orbit_chance = {}

		if galaxy_age == organic_rich then
			add_to_weighted_list(orbit_chance, 1, 25)
			add_to_weighted_list(orbit_chance, 2, 18)
			add_to_weighted_list(orbit_chance, 3, 17)
			add_to_weighted_list(orbit_chance, 4, 15)
			add_to_weighted_list(orbit_chance, 5, 25)
		elseif galaxy_age == mineral_rich then
			add_to_weighted_list(orbit_chance, 1, 10)
			add_to_weighted_list(orbit_chance, 2, 22)
			add_to_weighted_list(orbit_chance, 3, 30)
			add_to_weighted_list(orbit_chance, 4, 33)
			add_to_weighted_list(orbit_chance, 5, 5)
		else
			add_to_weighted_list(orbit_chance, 1, 1)
			add_to_weighted_list(orbit_chance, 2, 1)
			add_to_weighted_list(orbit_chance, 3, 1)
			add_to_weighted_list(orbit_chance, 4, 1)
			add_to_weighted_list(orbit_chance, 5, 1)
		end

		local satellite_type_chance = {
			[1] = {},
			[2] = {},
			[3] = {},
			[4] = {},
			[5] = {},
		}

		local satellite_type_keys = {"asteroid", "gas_giant", "planet", "companion_star"}

		add_to_weighted_list(satellite_type_chance[1], 1, 1)
		add_to_weighted_list(satellite_type_chance[1], 4, 1)
		add_to_weighted_list(satellite_type_chance[1], 3, 8)

		add_to_weighted_list(satellite_type_chance[2], 1, 2)
		add_to_weighted_list(satellite_type_chance[2], 2, 1)
		add_to_weighted_list(satellite_type_chance[2], 3, 7)

		add_to_weighted_list(satellite_type_chance[3], 1, 3)
		add_to_weighted_list(satellite_type_chance[3], 2, 2)
		add_to_weighted_list(satellite_type_chance[3], 3, 5)

		add_to_weighted_list(satellite_type_chance[4], 1, 2)
		add_to_weighted_list(satellite_type_chance[4], 2, 3)
		add_to_weighted_list(satellite_type_chance[4], 3, 5)

		add_to_weighted_list(satellite_type_chance[5], 1, 1)
		add_to_weighted_list(satellite_type_chance[5], 2, 5)
		add_to_weighted_list(satellite_type_chance[5], 3, 4)
		
		
		local used_orbits = { [1] = false, [2] = false, [3] = false, [4] = false, [5] = false}
		
		for i = 1, total_satellites do
			local orbit = i
			local type

			if total_satellites ~= 5 then
				-- Find an empty orbit
				repeat
					orbit = weighted_random(orbit_chance)
				until not used_orbits[orbit]
			
				-- Mark the orbit as used and update the weighted list
				-- add_to_weighted_list(orbit_chance, orbit, -10000) -- Effectively removes the orbit from the list
				used_orbits[orbit] = true
			end

			type = weighted_random(satellite_type_chance[orbit])
			local planet
			if satellite_type_keys[type] ~= "planet" then
				planet = Satellite:new(sys.party_id, orbit, satellite_type_keys[type])
			else
				planet = Planet:new(sys.party_id, orbit)

				local climate_groups = {}
				local climate_chance = {
					[0] = {},
					[1] = {},
					[2] = {},
					[3] = {},
				}

				if galaxy_age == organic_rich then
					add_to_weighted_list(climate_chance[0], "toxic", 15)
					add_to_weighted_list(climate_chance[0], "radiated", 40)
					add_to_weighted_list(climate_chance[0], "barren", 20)
					add_to_weighted_list(climate_chance[0], "desert", 25)

					add_to_weighted_list(climate_chance[1], "toxic", 5)
					add_to_weighted_list(climate_chance[1], "radiated", 30)
					add_to_weighted_list(climate_chance[1], "barren", 20)
					add_to_weighted_list(climate_chance[1], "desert", 25)
					add_to_weighted_list(climate_chance[1], "tundra", 20)

					add_to_weighted_list(climate_chance[2], "toxic", 5)
					add_to_weighted_list(climate_chance[2], "radiated", 8)
					add_to_weighted_list(climate_chance[2], "barren", 8)
					add_to_weighted_list(climate_chance[2], "desert", 13)
					add_to_weighted_list(climate_chance[2], "tundra", 13)
					add_to_weighted_list(climate_chance[2], "ocean", 13)
					add_to_weighted_list(climate_chance[2], "swamp", 13)
					add_to_weighted_list(climate_chance[2], "arid", 13)
					add_to_weighted_list(climate_chance[2], "terran", 10)
					add_to_weighted_list(climate_chance[2], "gaia", 4)

					add_to_weighted_list(climate_chance[3], "toxic", 20)
					add_to_weighted_list(climate_chance[3], "barren", 50)
					add_to_weighted_list(climate_chance[3], "tundra", 30)

				else
					add_to_weighted_list(climate_chance[0], "toxic", 15)
					add_to_weighted_list(climate_chance[0], "radiated", 55)
					add_to_weighted_list(climate_chance[0], "barren", 25)
					add_to_weighted_list(climate_chance[0], "desert", 5)

					add_to_weighted_list(climate_chance[1], "toxic", 15)
					add_to_weighted_list(climate_chance[1], "radiated", 50)
					add_to_weighted_list(climate_chance[1], "barren", 25)
					add_to_weighted_list(climate_chance[1], "desert", 10)
					add_to_weighted_list(climate_chance[1], "tundra", 5)

					add_to_weighted_list(climate_chance[2], "toxic", 10)
					add_to_weighted_list(climate_chance[2], "radiated", 15)
					add_to_weighted_list(climate_chance[2], "barren", 10)
					add_to_weighted_list(climate_chance[2], "desert", 10)
					add_to_weighted_list(climate_chance[2], "tundra", 10)
					add_to_weighted_list(climate_chance[2], "ocean", 10)
					add_to_weighted_list(climate_chance[2], "swamp", 11)
					add_to_weighted_list(climate_chance[2], "arid", 11)
					add_to_weighted_list(climate_chance[2], "terran", 11)
					add_to_weighted_list(climate_chance[2], "gaia", 2)

					add_to_weighted_list(climate_chance[3], "toxic", 20)
					add_to_weighted_list(climate_chance[3], "barren", 70)
					add_to_weighted_list(climate_chance[3], "tundra", 8)
					add_to_weighted_list(climate_chance[3], "ocean", 2)
				end

				if star_color == "red" then
					climate_groups = {1, 2, 3, 3, 3}
				elseif star_color == "green" then
					climate_groups = {1, 2, 2, 2, 3}
				elseif star_color == "yellow" then
					climate_groups = {0, 1, 2, 2, 3}
				elseif star_color == "blue" then
					climate_groups = {0, 0, 0, 0, 1}
				elseif star_color == "white" then
					climate_groups = {0, 0, 1, 2, 3}
				elseif star_color == "neutron" then
					climate_groups = {0, 0, 1, 2, 3}
				end

				local climate_group = climate_groups[orbit]
				local climate = weighted_random(climate_chance[climate_group])

				local rand = math.random()

				if rand < 0.1 then
					planet:set_size(PlanetarySizeKeys[1])
				elseif rand < 0.3 then
					planet:set_size(PlanetarySizeKeys[2])
				elseif rand < 0.7 then
					planet:set_size(PlanetarySizeKeys[3])
				elseif rand < 0.9 then
					planet:set_size(PlanetarySizeKeys[4])
				else
					planet:set_size(PlanetarySizeKeys[5])
				end

				local richness = PlanetaryRichnessKeys[weighted_random(richness_table)]
				planet:set_richness(richness)
				planet:set_type(climate)
				planet:determine_gravity()
			end
			-- AllPlanets = AllPlanets or {}

			planet.id = max_id
			
			AllPlanets[max_id] = planet

			sys.satellites_id =  sys.satellites_id or {}
			sys.satellites_id[orbit] = max_id

			sys.satellites_obj = sys.satellites_obj or {}
			sys.satellites_obj[orbit] = planet

			set_transient(StarSystem, "satellites_obj")
			max_id = max_id + 1
		end

	end
	local count = table_length(AllPlanets)
	WriteLogLine("A total of " .. count .. " planets were generated")
	local climate_counts = count_planets_by_climate(AllPlanets)
	
	for climate, count in pairs(climate_counts) do
		WriteLogLine(string.format("Climate: %-10s Count: %d", climate, count))
	end
end

function HomeWorldGeneration()
	local home_world_positions = {}
	local player_count = table_length(AllPlayers)

	WriteLogLine("Seeking homes for " .. player_count .. " Empires!")

	for _, player in pairs(AllPlayers) do
		local dist_from_others = galaxy_width / player_count

		if player.is_human then
			dist_from_others = dist_from_others * 1.5 -- little extra wiggle room please
		end

		local potential_homeworlds = {}
		local race = player:get_race()
		local race_name = race.name

		if race.is_custom then
			race_name = race.base_race
		end

		local race_id = playable_race_id(race_name)

		local preferred_gravity = "normal"
		local preferred_climate = "terran"
		local richness = "abundant"
		local size = "medium"

		local gravity_scoring_table = {
			["low"] = -1,
			["normal"] = 2,
			["high"] = -2
		}

		local climate_scoring_table = {
			["toxic"] = -5,
			["radiated"]= -5, 
			["barren"] = -5, 
			["desert"] = 5,
			["tundra"] = 5,
			["ocean"] = 5,
			["swamp"] = 5,
			["arid"] = 5,
			["terran"] = -5,
			["gaia"] = -100, -- don't take the cool planets, jerks
		}

		if race:has_trait("SpecialHighGWorld") then
			preferred_gravity = "high"
			gravity_scoring_table ={
				["low"] = -2,
				["normal"] = -1,
				["high"] = 2,
			}
		elseif race:has_trait("SpecialLowGWorld") then
			preferred_gravity = "low"
			gravity_scoring_table ={
				["low"] = 2,
				["normal"] = -1,
				["high"] = -3
			}
		end

		if race:has_trait("SpecialAquatic") then
			preferred_climate = "ocean"
			climate_scoring_table["ocean"] = 20
			climate_scoring_table["swamp"] = 15
		end

		if race:has_trait("SpecialRichHomeWorld") then
			richness = "rich"
		elseif race:has_trait("SpecialPoorHomeWorld") then
			richness = "poor"
		end

		if race:has_trait("SpecialLargeHomeWorld") then
			size = "large"
		end

		for _, planet in pairs(AllPlanets) do
			if planet:is_a(Planet) then
				local mom = planet:get_parent_system()
				WriteLogLine("Valid planet in :" .. mom.name)
				local planet_score = climate_scoring_table[planet.type] + gravity_scoring_table[planet.gravity]
				table.insert(potential_homeworlds, {planet, planet_score})
			end
		end

		if #potential_homeworlds == 0 then
			error("No potential homeworlds found!")
		end
		
		local function compare(a,b)
			return a[2] > b[2]
		end

		table.sort(potential_homeworlds, compare)

		local home_system
		local home_planet

		local max_attempts = 10
		local attempts = 0
		repeat
			for _, entry in ipairs(potential_homeworlds) do
				local planet = entry[1]
				local system = planet:get_parent_system()
				if planet.owner == nil then
					local position = game.pos.new()
					game.party_get_position(1, system.party_id)
					position = game.preg[1]
					if not is_too_close(position, home_world_positions, dist_from_others) then
						table.insert(home_world_positions, position)
						home_system = system
						home_planet = planet
						break
					end
				end
			end

			if not (home_planet and home_system) then
				dist_from_others = dist_from_others * 0.75 -- still shrink
				attempts = attempts + 1
				if attempts >= max_attempts then
					-- error("Failed to find a valid homeworld after " .. attempts .. " attempts!")
					break
				end
			end
		until home_planet and home_system

		if attempts >= max_attempts then
			print("Warning: Couldn't fully respect homeworld spacing, picking best available.")
			-- force pick the best scoring unowned planet

			for _, entry in ipairs(potential_homeworlds) do
				local planet = entry[1]
				if planet.owner == nil then
					home_planet = planet
					home_system = planet:get_parent_system()
					table.insert(home_world_positions, get_party_position(home_system.party_id))
					break
				end
			end
			break -- important to exit the repeat
		end

		home_system:set_name(default_homeworld_names[race_id])

		-- Cheat a little for the hometeam
		if player.is_human then
			PullStarsCloserToSpecificSystem(home_system.party_id, 3)
		end

		home_planet:set_type(preferred_climate)
		home_planet:set_gravity(preferred_gravity)
		home_planet:set_richness(richness)
		home_planet:set_size(size)
		home_planet.owner = player.id
		local colony = Colony:new(home_system.party_id, home_planet.orbit, player.id)

		--[[
		if race:has_trait("SpecialArtifactsWorld") then
			home_planet:add_trait("artifacts")
		end
		]]--
	end
end

function RaceGeneration(force)
	AllRaces = {}

	for race = 1, NUM_PLAYABLE_RACES do
	
		local race_name = playable_race_names[race]
		local race_file = "race/" .. race_name .. ".json"
		
		local new_race 
		
		if not force and file_exists(race_file) then
			new_race = load_single_race(race_file)
		else
			-- prevents users from deleting the hardcoded races
			new_race = Race:new(race_name)
			new_race:add_traits(playable_race_trait_lists[race])
			save_race(new_race, force)
		end

		new_race:set_playable(true)
		
		table.insert(AllRaces, new_race)
		-- WriteLogLine("Race: " .. new_race.name .. " Generated!")
		-- WriteLogLine("Total trait cost: " .. new_race:total_trait_cost())
	end
	
	local native_traits = { "FarmingGreat" }
	local natives = Race:new_with_traits("Natives", native_traits)
	table.insert(AllRaces, natives)
	save_race(natives)
	
	AllRacesByName = {}

	for _, race in ipairs(AllRaces) do
		AllRacesByName[race.name] = race
	end

	--WriteLogLine("We generated " .. #races .. " total races!")
end

function AddPlayers(player_ini_list, total_players)
	-- This function will take a list of players and add them to the game
	local players = {}

	for i = 1, total_players do
		local player_race = player_ini_list[i][1]
		local player_is_human = player_ini_list[i][2]
		local player_name = player_ini_list[i][3] or get_random_emperor_name(player_race)
		local player_color = player_ini_list[i][4] or DefaultEmpireColors[i]


		-- Create all players
		-- Starting with the human players
		-- Then AI
		-- There will be a table set up that we can read from
		-- that lists if each player is human or ai, and what
		-- their individual races are
		local player

		if player_is_human then
			player = Player:new(player_race, player_is_human, player_name, player_color, i)
		else
			player = AIPlayer:new(player_race, player_name, player_color, i)
		end

		table.insert(AllPlayers, player)  -- Add the player to the global list of players
    
		if player.active then
			table.insert(ActivePlayers, player)  -- Add the player to the active players list
		else
			table.insert(InactivePlayers, player)  -- Add the player to the inactive players list
		end
	end

	return players
end

function get_random_emperor_name(race_name)
    local name_list = RaceNameLists[race_name]
    
	if not name_list then
        error("No name list found for race: " .. tostring(race_name))
    end

    -- Get a random name from the list
    local random_index = math.random(1, #name_list)
    return name_list[random_index]
end

function calculate_min_galaxy_width(num_stars, min_distance)
    local stars_per_row = math.ceil(math.sqrt(num_stars))
    local width = stars_per_row * min_distance * 3
    return width
end

function place_stars_random(num_stars, min_distance)
	local stars = {}
	local placed_positions = {}
	local _system_names = deepcopy(system_names)
	_system_names = shuffle(system_names)
	
	local most_stars = math.ceil(num_stars * 0.75)

	for i = 1, num_stars do
		local s_name = _system_names[i]		
		local system = StarSystem:new(s_name)
		
		local position = game.pos.new()
		
		local _iteration = 0

		if i < most_stars then
			repeat
				_iteration = _iteration + 1
				local theta = math.random() * 2 * math.pi
				local radius = galaxy_width / 2 * math.sqrt(math.random())
				position.o.x = radius * math.cos(theta)
				position.o.y = radius * math.sin(theta)
			until not is_too_close(position, placed_positions, min_distance) or _iteration > 50
		else
			repeat
				_iteration = _iteration + 1
				position.o.x = randomFloat(-galaxy_width / 2, galaxy_width / 2)
				position.o.y = randomFloat(-galaxy_width / 2, galaxy_width / 2)
			until not is_too_close(position, placed_positions, min_distance) or _iteration > 50
		end

		if _iteration > 50 then
			print("Finding a good position failed for" .. system.name)
		end
		
		game.party_set_position(system.party_id, position)
		table.insert(placed_positions, position)
		table.insert(stars, system)
	end

    return stars
end

function place_stars_clustered(num_stars, min_distance, num_clusters)
    local stars = {}
	local placed_positions = {}
	local cluster_positions = {}
	local _system_names = deepcopy(system_names)
	_system_names = shuffle(_system_names)

	local galaxy_radius = calculate_min_galaxy_width(num_stars, min_distance)
    local stars_per_cluster = math.ceil(num_stars / num_clusters)
	local cluster_radius =  calculate_min_galaxy_width(stars_per_cluster, min_distance)

	galaxy_radius = galaxy_radius - cluster_radius

    for c = 1, num_clusters do
        -- Create cluster center
		local _iteration = 0
		local cluster_position = game.pos.new()

		repeat
			_iteration = _iteration + 1
			cluster_position.o.x = randomFloat(-galaxy_radius, galaxy_radius)
			cluster_position.o.y = randomFloat(-galaxy_radius, galaxy_radius)
		until not is_too_close(cluster_position, cluster_positions, cluster_radius) or _iteration > 50
		table.insert(cluster_positions, cluster_position)

		local cx = cluster_position.o.x
        local cy = cluster_position.o.y

		
        for s = 1, stars_per_cluster do
            if #stars >= num_stars then break end

			local s_name = _system_names[#stars + 1]
			local system = StarSystem:new(s_name)
			
			local position = game.pos.new()
			
			_iteration = 0

			repeat
				_iteration = _iteration + 1
				local theta = math.random() * 2 * math.pi
				local radius = randomFloat(-cluster_radius / 2, cluster_radius / 2)
				position.o.x = cx + radius * math.cos(theta)
				position.o.y = cy + radius * math.sin(theta)
			until not is_too_close(position, placed_positions, min_distance) or _iteration > 50
			
			game.party_set_position(system.party_id, position)
			table.insert(placed_positions, position)
			table.insert(stars, system)
        end
    end

    return stars
end