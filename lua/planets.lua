require "traits"
require "population"
local class = require "class"

Satellite = Class(nil, "Satellite")

-- Satellite is used for non-habitable bodies around stars

function Satellite:init(parent_system, orbit, type)
    self.parent_system = parent_system
    self.orbit = orbit
    self.type = type
end

Planet = Class(Satellite, "Planet")

-- Planet is explicitly a livable, or can be made livable, satellite

function Planet:init(parent_system, orbit)
    self.super.init(self, parent_system, orbit, "planet")
    self.size = "small"
    self.owner = nil
    self.atmosphere = true
    self.gravity = "normal"
    self.richness = "abundant"
    self.type = "barren"
    self.traits = {}
end



function Planet:set_type(type_id)
    local my_type
    local type_id = type_id

    if type(type_id) == "string" then
        type_id = type_id:lower()
        my_type = PlanetaryTypeDefinitions[type_id]
    elseif type(type_id) == "number" then
        type_id = PlanetaryTypeKeys[math.tointeger(type_id)]
        my_type = PlanetaryTypeDefinitions[type_id]
    else
        error("set_type only accepts strings or numbers friend-o, not: " .. type(type_id))
    end

    if not my_type then
        WriteLogLine("Incorrect type: " .. tostring(type_id) .. " defaulting to: " .. PlanetaryTypeKeys[3])
        type_id = PlanetaryTypeKeys[3]
    end

    self.type = type_id
end

function Planet:get_type_definition()
    local type_id = self.type
    local type = PlanetaryTypeDefinitions[type_id]

    if not type then
        error("Type is undefined in PlanetaryTypeDefinitions")
    end

    return type
end

function Planet:set_size(size_id)
    local size_id = size_id
    local size

    if type(size_id) == "string" then
        size_id = size_id:lower()
        size = PlanetarySizeDefinitions[size_id]
    elseif type(size_id) == "number" then
        size_id = PlanetarySizeKeys[math.tointeger(size_id)]
        size = PlanetarySizeDefinitions[size_id]
    else
        error("set_size only accepts strings or numbers friend-o, not: " .. type(size_id))
    end

    if not size then
        WriteLogLine("Incorrect size: " .. tostring(size_id) .. " defaulting to: " .. PlanetarySizeKeys[3])
        size_id = PlanetarySizeKeys[3]
    end

    self.size = size_id
end

function Planet:get_size_definition()
    local size_id = self.size
    local size = PlanetarySizeDefinitions[size_id]

    if not size then
        error("Size is undefined in PlanetarySizeDefinitions")
    else
        return size
    end
end

function Planet:set_richness(richness_id)
    local richness_id = richness_id
    local richness
    if type(richness_id) == "string" then
        richness_id = richness_id:lower()
        richness = PlanetaryRichnessDefinitions[richness_id]
    elseif type(richness_id) == "number" then
        richness_id = PlanetaryRichnessKeys[math.tointeger(richness_id)]
        richness = PlanetaryRichnessDefinitions[richness_id]
    else
        error("set_richness only accepts strings or numbers friend-o, not: " .. type(richness_id))
    end

    if not richness then
        WriteLogLine("Incorrect richness: " .. tostring(richness_id) .. " defaulting to: " .. PlanetaryRichnessKeys[3])
        richness_id = PlanetaryRichnessKeys[3]
    end

    self.richness = richness_id
end

function Planet:get_richness_definition()
    local richness_id = self.richness
    local richness = PlanetaryRichnessDefinitions[richness_id]

    if not richness then
        error("Richness is undefined in PlanetaryRichnessDefinitions")
    else
        return richness
    end
end

function Planet:set_gravity(gravity_id)
    local gravity_id = gravity_id
    local gravity
    if type(gravity_id) == "string" then
        gravity_id = gravity_id:lower()
        gravity = PlanetaryGravityDefinitions[gravity_id]
    elseif type(gravity_id) == "number" then
        gravity_id = PlanetaryGravityKeys[math.tointeger(gravity_id)]
        gravity = PlanetaryGravityDefinitions[gravity_id]
    else
        error("set_gravity only accepts strings or numbers friend-o, not: " .. type(gravity_id))
    end

    if not gravity then
        WriteLogLine("Incorrect gravity: " .. tostring(gravity_id) .. " defaulting to: " .. PlanetaryGravityKeys[2])
        gravity = PlanetaryGravityDefinitions[PlanetaryGravityKeys[3]]
    end

    self.gravity = gravity_id
end

function Planet:determine_gravity()
    local richness = self.richness
    local size = self.size
    local gravity

    for i = 1, #PlanetaryRichnessKeys do
        if richness == PlanetaryRichnessKeys[i] then
            richness = i
            break
        end
    end

    if size == PlanetarySizeKeys[1] then
        if richness > 4 then
            gravity = PlanetaryGravityKeys[1]
        else
            gravity = PlanetaryGravityKeys[2]
        end
    elseif size == PlanetarySizeKeys[2] then
        if richness > 3 then
            gravity = PlanetaryGravityKeys[1]
        else
            gravity = PlanetaryGravityKeys[2]
        end
    elseif size == PlanetarySizeKeys[3] then
        if richness == 1 then
            gravity = PlanetaryGravityKeys[1]
        elseif richness > 5 then
            gravity = PlanetaryGravityKeys[2]
        else
            gravity = PlanetaryGravityKeys[3]
        end
    elseif size == PlanetarySizeKeys[4] then
        if richness > 4 then
            gravity = PlanetaryGravityKeys[2]
        else
            gravity = PlanetaryGravityKeys[3]
        end
    else
        if richness > 3 then
            gravity = PlanetaryGravityKeys[2]
        else
            gravity = PlanetaryGravityKeys[3]
        end
    end

    self:set_gravity(gravity)
end

function Planet:get_gravity_definition()
    local gravity_id = self.gravity
    local gravity = PlanetaryGravityDefinitions[gravity_id]

    if not gravity then
        error("Gravity is undefined in PlanetaryGravityDefinitions")
    else
        return gravity
    end
end

function Planet:add_trait(trait_id)
	-- Validate the trait_id
    if not PlanetTraitsDefinitions[trait_id] then
        error("Unknown trait: " .. tostring(trait_id))
    end

    if self.has_trait(trait_id) then
        error("Trait already exists: " .. trait_id)
	else
        table.insert(self.traits, trait_id)
	end
end

function Planet:has_trait(trait_id)
    -- Validate the trait_id
    if not PlanetTraitsDefinitions[trait_id] then
        error("Unknown trait: " .. tostring(trait_id))
    end

    -- Check if the trait exists in self.traits
    for _, existing_trait in ipairs(self.traits) do
        if existing_trait == trait_id then
            return true
        end
    end

    return false
end

function Planet:get_total_bonuses()
    if self._cached_bonuses then return self._cached_bonuses end
    local totals = {}

    for _, trait in pairs(self.traits) do
        for _, bonus_key in ipairs(PlanetaryBonusKeys) do
            if trait[bonus_key] then
                totals[bonus_key] = (totals[bonus_key] or 0) + trait[bonus_key]
            end
        end
    end

    self._cached_bonuses = totals
    return totals
end

function Planet:get_parent_system()
    local system_id = self.parent_system
    for _, system in pairs(AllSystems) do
        if system.party_id == system_id then
            return system
        end
    end
    return false
end

--- Checks if planet entry hosts a colony, else it returns false
--- @return table|boolean colony If the colony exists returns the colony object, else it returns false
function Planet:get_colony()
    local orbit = self.orbit
    local system = self.parent_system
    for _, colony in AllColonies do
        if colony.parent_system == system and colony.orbit == orbit then
            return colony
        end
    end
    return false
end

-- Not a useful function, just wanted to get some use out of it, lol
function Planet:get_parent_star_color()
    local parent_system = self:get_parent_system()
    if parent_system then
        return parent_system.star_color
    else
        error("Planet's parent star cannot be found? Am Orphan!?")
    end
end

function count_planets_by_climate(planets)
    local counts = {}
	
	if not planets then
        WriteLogLine("count_planets_by_climate called with nil planets")
        return counts
    end
	
    for _, system in ipairs(planets) do
        local type = system.type
        counts[type] = (counts[type] or 0) + 1
    end

    return counts
end


PlanetaryBaseKeys = {
    "food_base",
    "production_base",
    "research_base",
}

PlanetaryTypeKeys = {
    "toxic",
    "radiated",
    "barren",
    "desert",
    "tundra",
    "ocean",
    "swamp",
    "arid",
    "terran",
    "gaia",
    "asteroid",
    "gas_giant",
    "companion_star"
}


PlanetaryTypeDefinitions = {
    toxic = {
        name = "Toxic",
        description = "A planet with a toxic atmosphere, inhospitable to most life forms.",
        food_base = 0,
    },
    radiated = {
        name = "Radiated",
        description = "A planet with high radiation levels, making it dangerous for life.",
        size = 2,
        food_base = 0,
    },
    barren = {
        name = "Barren",
        description = "A dry, lifeless planet with little to no atmosphere.",
        food_base = 0,
    },
    desert = {
        name = "Desert",
        description = "A hot, arid planet with little water and vegetation.",
        food_base = 2,
    },
    tundra = {
        name = "Tundra",
        description = "A cold, icy planet with a thin atmosphere.",
        food_base = 2,
    },
    ocean = {
        name = "Ocean",
        description = "A planet covered mostly by water, with some landmasses.",
        food_base = 4,
    },
    swamp = {
        name = "Swamp",
        description = "A wet, marshy planet with a rich ecosystem.",
        food_base = 4,
    },
    arid = {
        name = "Arid",
        description = "A dry planet with a thin atmosphere, but some potential for life.",
        food_base = 2,
    },
    terran = {
        name = "Terran",
        description = "A planet with conditions similar to Earth, capable of supporting life.",
        food_base = 4,
    },
    gaia = {
        name = "Gaia",
        description = "A lush, vibrant planet with a rich ecosystem and abundant resources.",
        food_base = 6,
    },
    asteroid = {
        name = "Asteroid",
        description = "A small rocky body in space, typically lacking atmosphere and life.",
    },
    gas_giant = {
        name = "Gas Giant",
        description = "A large planet composed mostly of gases, with no solid surface.",
    },
    companion_star = {
        name = "Companion Star",
        description = "A small, low-mass star orbiting the main star of the system",
    },
}

PlanetaryRichnessKeys = {
    "ultrapoor",
    "poor",
    "abundant",
    "rich",
    "ultrarich",
}

PlanetaryRichnessDefinitions = {
    ultrapoor = {
        name = "Ultra Poor",
        description = "Very low resource availability.",
        production_base = 1,
    },
    poor = {
        name = "Poor",
        description = "Low resource availability.",
        production_base = 2,
    },
    abundant = {
        name = "Abundant",
        description = "Moderate resource availability.",
        production_base = 3,
    },
    rich = {
        name = "Rich",
        description = "High resource availability.",
        production_base = 5,
    },
    ultrarich = {
        name = "Ultra Rich",
        description = "Very high resource availability.",
        production_base = 8,
    },
}

PlanetarySizeKeys = {
    "tiny",
    "small",
    "medium",
    "large",
    "huge",
}

PlanetarySizeDefinitions = {
    tiny = {
        name = "Tiny",
        description = "Very small planet, limited capacity for life.",
        max_population_1 = 1,
        max_population_2 = 2,
        max_population_3 = 3,
        pollution_exempt_level = 2, -- production past this point adds pollution, half of exceeding production goes to cleaning pollution, nano disassemblers double this value
    },
    small = {
        name = "Small",
        description = "Small planet, limited capacity for life.",
        max_population_1 = 2,
        max_population_2 = 4,
        max_population_3 = 6,
        pollution_exempt_level = 4,
    },
    medium = {
        name = "Medium",
        description = "Average-sized planet, capable of supporting life.",
        max_population_1 = 4,
        max_population_2 = 6,
        max_population_3 = 8,
        pollution_exempt_level = 6,
    },
    large = {
        name = "Large",
        description = "Large planet, capable of supporting a significant amount of life.",
        max_population_1 = 6,
        max_population_2 = 8,
        max_population_3 = 10,
        pollution_exempt_level = 8,
    },
    huge = {
        name = "Huge",
        description = "Very large planet, capable of supporting a vast amount of life.",
        max_population_1 = 8,
        max_population_2 = 10,
        max_population_3 = 12,
        pollution_exempt_level = 10,
    },
}

PlanetaryGravityKeys = {
    "low",
    "normal",
    "high"
}

PlanetaryGravityDefinitions = {
    low = {
        name = "Low Gravity",
        description = "Lower than normal gravity, making it slightly awkward to perform daily tasks.",
        modifier = 0.75,
    },
    normal = {
        name = "Normal Gravity",
        description = "Normal gravity, suitable for most life forms.",
        modifier = 1.0,
    },
    high = {
        name = "High Gravity",
        description = "Higher than normal gravity, making it harder for life to thrive.",
        modifier = 0.5,
    },
}

-- helpers

function inspect_all_planets()
    WriteLogLine("Inspecting AllPlanets...", true)

    if not AllPlanets then
        WriteLogLine("AllPlanets is nil!", true)
        return
    end

    local count = 0

    for id, planet in pairs(AllPlanets) do
        count = count + 1
        local system_id = planet.parent_system or "?"
        local orbit = planet.orbit or "?"
        local climate = planet.type or "unknown"
        WriteLogLine(string.format("Planet ID: %s | System: %s | Orbit: %s | Type: %s", tostring(id), tostring(system_id), tostring(orbit), climate), true)

        -- Optional checks:
        if not planet.is_a or not planet:is_a(Planet) then
            WriteLogLine("Not a valid Planet object: " .. id, true)
        end
        if type(planet.parent_system) ~= "number" then
            WriteLogLine("Missing or invalid parent_system on planet ID:" .. id, true)
        end
    end

    WriteLogLine("Total planets in AllPlanets: " .. count)
end
