local traits require "traits"
local class require "class"


StarSystem = Class(nil, "StarSystem")

local star_colors = {
    "red", "green", "yellow", "blue", "white", "neutron"
}

function StarSystem:init(name)
	-- Spawn their in-game party representation
	game.spawn_around_party(0, game.const.pt_system)
	local party = game.reg[0] -- get their in-game id

	self.party_id = party
	self.name = name
	self.star_color = nil
	self.visited_by = {}
	self.charted_by = {}
	self.discovered = false -- discovered in this case means first visit
	self.traits = {}
	self.structures = {}
	self.satellites_id = {}
	self.nearest_neighbors = {}

	-- self.satellites_obj = {}
	
	game.party_set_name(party, name)	-- sets the name of the party in game
	game.party_set_flags(party, game.const.pf_is_static, 1) -- sets the party to static, so it doesn't move
	game.party_set_flags(party, game.const.pf_hide_defenders, 1) -- hides the defenders in the system, so it doesn't show up in the game
	--game.party_set_flags(party, game.const.pf_no_label, 1)		-- hides the label until it is charted
	game.party_set_flags(party, game.const.pf_always_visible, 1)	-- makes the system always visible in the game
	self:determine_star_color()
end

function StarSystem:load_existing(data)
    local system = setmetatable({}, StarSystem)

    -- Restore known fields
    system.party_id = data.party_id   -- already created in-game
    system.name = data.name
    system.star_color = data.star_color
    system.visited_by = data.visited_by or {}
    system.charted_by = data.charted_by or {}
    system.discovered = data.discovered or false
    system.traits = data.traits or {}
    system.structures = data.structures or {}
    system.satellites_id = data.satellites_id or {}
    system.nearest_neighbors = data.nearest_neighbors or {}

    -- Restore transient field manually after linking
    system.satellites_obj = {}
	set_transient(StarSystem, "satellites_obj")

    return system
end

StarSystem.__transient = {
	
}

function StarSystem:set_name(new_name)
	self.name = new_name
	game.party_set_name(self.party_id, new_name)
end

-- Add a trait
function StarSystem:add_trait(trait_id)
	local trait = SystemTraitsDefinitions[trait_id]
	if trait then 
		self.traits[trait_id] = trait
	else
		error("Unknown trait: " .. tostring(trait_id))
	end
end

-- Remove a trait
function StarSystem:remove_trait(trait)
    self.traits[trait] = nil
end

-- Check for a trait
function StarSystem:has_trait(trait)
    return self.traits[trait] == true
end

function StarSystem:determine_star_color()
	if not self.star_color then
	
		local roll = math.random()
		local icon = math.random(0, 3)
		
		-- "red", "green", "yellow", "blue", "white", "neutron"
		local red_chance = 0.3
		local green_chance = 0.25
		local yellow_chance = 0.15
		local blue_chance = 0.15
		local white_chance = 0.10
		-- local neutron_chance = 0.05
		
		--[[
			if galaxy_age == young then
				red_chance = 0.3
			    green_chance = 0.25
			    yellow_chance = 0.15
			    blue_chance = 0.15
			    white_chance = 0.10
		]]
		
		if roll < 0.3 then
			self.star_color = star_colors[1]
			
			game.party_set_slot(self.party_id, game.const.slot_system_star_color, game.const.st_red_star)
			icon = icon + game.const.icon_star_red_01
			game.party_set_icon(self.party_id, icon)
		elseif roll < 0.55 then
			self.star_color = star_colors[2]
			
			game.party_set_slot(self.party_id, game.const.slot_system_star_color, game.const.st_green_star)
			icon = icon + game.const.icon_star_green_01
			game.party_set_icon(self.party_id, icon)
		elseif roll < 0.7 then
			self.star_color = star_colors[3]
			
			game.party_set_slot(self.party_id, game.const.slot_system_star_color, game.const.st_yellow_star)
			icon = icon + game.const.icon_star_yellow_01
			game.party_set_icon(self.party_id, icon)
		elseif roll < 0.85 then
			self.star_color = star_colors[4]
			
			game.party_set_slot(self.party_id, game.const.slot_system_star_color, game.const.st_blue_star)
			icon = icon + game.const.icon_star_blue_01
			game.party_set_icon(self.party_id, icon)
		elseif roll < 0.95 then
			self.star_color = star_colors[5]
			
			game.party_set_slot(self.party_id, game.const.slot_system_star_color, game.const.st_white_star)
			icon = icon + game.const.icon_star_white_01
			game.party_set_icon(self.party_id, icon)
		else
			self.star_color = star_colors[6]
			
			game.party_set_slot(self.party_id, game.const.slot_system_star_color, game.const.st_neutron_star)
			icon = icon + game.const.icon_star_neutron_01
			game.party_set_icon(self.party_id, icon)
		end
		
		-- WriteLogLine("System " .. self.name .. "is " .. tostring(self.star_color))
	else
		error("This star already has a color", 0)
	end
end

function count_star_colors(systems)
    local counts = {}
	
	if not systems then
        WriteLogLine("count_star_colors called with nil systems")
        return counts
    end
	
    for _, system in ipairs(systems) do
        local color = system.star_color
        counts[color] = (counts[color] or 0) + 1
    end

    return counts
end

function StarSystem:get_bonus(field)
    local total = 0
    for _, trait in pairs(self.traits) do
        if trait[field] then
            total = total + trait[field]
        end
    end
    return total
end

function StarSystem:get_satellite_in_orbit_id(orbit)
    if type(self.satellites) ~= "table" then
        error("Satellites data is not properly initialized.")
    end

    for _, sat in pairs(self.satellites) do
        if sat.orbit == orbit then
            return sat
        end
    end

    return false -- No satellite found in the specified orbit
end

function StarSystem:has_habitable_planets(player)
	for _, planet in pairs(self.satellites) do
		for _, trait in pairs(planet.traits) do
			
		end
	end
end

function StarSystem:visit(player)
    -- Mark the system as discovered and add to the player's discovered list
    if not self.discovered then
        self.discovered = true
        table.insert(player.systems_discovered, self.name)
    end

    -- Add the player's ID to the system's visited_by list (as a dictionary)
    if not self.visited_by[player.id] then
        self.visited_by[player.id] = true -- Mark as visited by this player
        table.insert(player.systems_visited, self.name) -- Add system name to player's visited list
    end

	if not self.charted_by[player.id] then
		self:chart(player)	-- Automatically chart visited systems, just in case
	end
end

function StarSystem:chart(player)
    -- Add the player's ID to the system's visited_by list (as a dictionary)
    if not self.charted_by[player.id] then
        self.charted_by[player.id] = true -- Mark as visited by this player
        table.insert(player.systems_charted, self.name) -- Add system name to player's visited list
		game.party_set_flags(self.party_id, game.const.pf_no_label, 0) -- gives the system a label in game
    end
end

function send_star_orbits(party_id)
	for key, sys in pairs(AllSystems) do
		if sys.party_id == party_id then
			for i = 1, 5 do
				local sat_id = sys.satellites_id[i]
				local type
				local sat = AllPlanets[sat_id]
				
				if sat then
					type = tostring(sat.type)
				else
					type = "empty orbit"
				end

				game.sreg[i] = type
			end
			print(sys.name .. ": 1, " .. game.sreg[1] .. " 2, " .. game.sreg[2] .. " 3, " .. game.sreg[3] .. " 4, " .. game.sreg[4] .. " 5, " .. game.sreg[5])
		end
	end
end