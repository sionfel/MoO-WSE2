-- colony.lua
local class = require("class")
local planet = require("planets")

AllColonies = {}
Colony = Class(nil, "Colony")

function Colony:init(parent_system, orbit_id, owner)
    self.id = table_length(AllColonies) + 1
    self.parent_system = parent_system
    self.orbit_id = orbit_id
    self.owner = owner
    self.tax_rate = 0.2 --colonies can be assigned a tax rate that they pay based on production
    self.morale = 0
    self.morale_growth = 0
    self.morale_decay = 0
    self.previous_turn_population = 0
    self.population = 0
    self.growth_rate = 1.0
    self.pollution = 0
    self.max_population_1 = 0   -- base size
    self.max_population_2 = 0	-- soil enrichment adjusted
    self.max_population_3 = 0	-- maximum population
    self.build_queue = {}
    self.structures = {}
    self.citizens = {
        farmer = {},
        laborer = {},
        researcher = {},
        rebel = {},
    }

    self.__transient = {
        owner_obj = true,
    }
    
    local owner_obj = self:get_owner()
    AllColonies[self.id] = self
    table.insert(owner_obj.colonies, self.id)
    self.owner_obj = owner_obj
end

function Colony:load_existing(data)
    local system = setmetatable({}, Colony)

    system.id = data.id
    system.parent_system = data.parent_system
    system.orbit_id = data.orbit_id
    system.owner = data.owner
    system.tax_rate = data.tax_rate
    system.morale = data.morale
    system.morale_growth = data.morale_growth
    system.morale_decay = data.morale_decay
    system.previous_turn_population = data.previous_turn_population
    system.population = data.population
    system.growth_rate = data.growth_rate
    system.pollution = data.pollution
    system.max_population_1 = data.max_population_1
    system.max_population_2 = data.max_population_2
    system.max_population_3 = data.max_population_3
    system.build_queue = data.build_queue or {}
    system.structures = data.structures or {}
    system.citizens = data.citizens or {farmer = {}, laborer = {}, researcher = {}, rebel = {},}

    system.__transient = data.__transient
    
    local owner_obj = system:get_owner()
    AllColonies[system.id] = system
    system.owner_obj = owner_obj

    return system
end

function Colony:update_population()
    local total = 0
    for _, job_list in pairs(self.citizens) do
        for _, citizen in ipairs(job_list) do
            total = total + citizen.population
        end
    end
    self.population = total
    return total
end

function Colony:get_population_by_job(job)
    local total = 0
    local job_list = self.citizens[job] or {}
    for _, citizen in ipairs(job_list) do
        total = total + citizen.population
    end
    return total
end

function Colony:add_citizen(job, race)
    if not self.citizens[job] then
        error("Invalid job: " .. tostring(job))
    end

    -- Check if a citizen of the same race already exists in the job list
    for _, citizen in ipairs(self.citizens[job]) do
        if citizen.race == race then
            -- Add to the existing citizen's population
            citizen.population = citizen.population + 1
            return
        end
    end

    -- If no existing citizen of the same race is found, create a new one
    table.insert(self.citizens[job], Citizens:new(race, 1))
end

function Colony:remove_random_citizen()
    local job_list = {}
    for job, citizens in pairs(self.citizens) do
        for _, citizen in ipairs(citizens) do
            table.insert(job_list, { job = job, citizen = citizen })
        end
    end

    if #job_list == 0 then return end -- No citizens to remove

    local random_index = math.random(#job_list)
    local selected_citizen = job_list[random_index]

    -- Decrease the population of the selected citizen
    selected_citizen.citizen.population = selected_citizen.citizen.population - 1

    -- If the population reaches zero, remove the citizen from the list
    if selected_citizen.citizen.population <= 0 then
        for i, citizen in ipairs(self.citizens[selected_citizen.job]) do
            if citizen == selected_citizen.citizen then
                table.remove(self.citizens[selected_citizen.job], i)
                break
            end
        end
    end
end

function Colony:remove_citizen(job, race)
    if not self.citizens[job] then
        error("Invalid job: " .. tostring(job))
    end

    for i, citizen in ipairs(self.citizens[job]) do
        if citizen.race == race then
            -- Decrease the population of the citizen
            citizen.population = citizen.population - 1

            -- If the population reaches zero, remove the citizen from the list
            if citizen.population <= 0 then
                table.remove(self.citizens[job], i)
            end
            return
        end
    end

    -- If no citizen of the specified race is found, raise an error
    error("No citizen of race " .. tostring(race) .. " found in job " .. tostring(job))
end

function Colony:reassign_citizen(job_from, job_to, race)
    Colony:add_citizen(job_to, race)
    Colony:remove_citizen(job_from, race)
end

function Colony:get_population_by_race(race)
    local total = 0
    for _, job_list in pairs(self.citizens) do
        for _, citizen in ipairs(job_list) do
            if citizen.race == race then
                total = total + citizen.population
            end
        end
    end
    return total
end

function Colony:get_owner()
    local my_owner_id = self.owner
    for _, plyr in pairs(AllPlayers) do
        if plyr.id == my_owner_id then
            return plyr
        end
    end

    error("No such player id:" .. my_owner_id)
    
end

function Colony:get_system()
    local my_sys_id = self.parent_system
    for _, sys in pairs(AllSystems) do
        if sys.party_id == my_sys_id then
            return sys
        end
    end
    return false
end

function Colony:get_planet()
    local system = self:get_system()
    
    if system then
        local planet = system:get_satellite_in_orbit_id(self.orbit_id)
        if planet then
            return planet
        else
            error("Colony's parent planet cannot be found")
        end
    else
        error("Colony's parent system was not found")
    end
end


function Colony:get_pollution_exempt_level()
    local planet = self:get_planet()
    local size_def = PlanetarySizeDefinitions[planet.size] or PlanetarySizeDefinitions["small"]
    return size_def.pollution_exempt_level or 0
end

function Colony:get_food_bonuses()
    local total_multipier = 1.0
    local total_flat = 0
end

function Colony:get_output_summary()
    local output = {
        food = 0,
        production = 0,
        research = 0,
        taxes = 0,
        pollution = 0,
    }

    local planet = self:get_planet()

    local government = self.owner.race:get_government() or "GovernmentDictator"
    local richness = PlanetaryRichnessDefinitions[planet.richness] or PlanetaryRichnessDefinitions["abundant"]
    local gravity = PlanetaryGravityDefinitions[planet.gravity] or PlanetaryGravityDefinitions["normal"]
    local type = PlanetaryTypeDefinitions[planet.type] or PlanetaryTypeDefinitions["terran"]

    local government_modifiers = {
        GovernmentFeudal = { food = 2/3, production = 2/3, research = 0.5 },
        GovernmentConfederation = { food = 2/3, production = 2/3, research = 0.5 },
        GovernmentDictator = { food = 2/3, production = 2/3, research = 0.5 },
        GovernmentImperium = { food = 2/3, production = 2/3, research = 0.5 },
        GovernmentDemocracy = { food = 2/3, production = 2/3, research = 0.5 },
        GovernmentFederation = { food = 2/3, production = 2/3, research = 0.5 },
        GovernmentUnification = { food = 2/3, production = 2/3, research = 0.5 },
        GovernmentGalacticUnification = { food = 2/3, production = 2/3, research = 0.5 },
    }

    if self.structures["base"] then government_modifiers["GovernementDictator"] = { food = 1.0, production = 1.0, research = 1.0 } end

    local government_modifiers = government_modifiers[government] or { food = 1.0, production = 1.0, research = 1.0 }

    for job, job_list in pairs(self.citizens) do
        for _, citizen in ipairs(job_list) do
            
            local bonuses = get_citizen_bonuses(citizen)
            local food_bonus = bonuses.farming_bonus or 0
            local production_bonus = bonuses.production_bonus or 0
            local research_bonus = bonuses.research_bonus or 0
            local gravity_modifier = gravity.modifier or 1.0

            if gravity == "low" and citizen.race:has_trait("SpecialLowGWorld") then
                gravity_modifier = 1.0
            elseif gravity == "high" and citizen.race:has_trait("SpecialHighGWorld") then
                gravity_modifier = 1.0
            elseif citizen.race == "Native" then
                gravity_modifier = 1.0
            end

            

            if job == "farmer" then
                output.food = output.food + citizen.population * food_bonus * type.food_base * government_modifiers.food * gravity_modifier -- or whatever your yield is
            elseif job == "laborer" then
                output.production = output.production + citizen.population * production_bonus * richness.production_base * government_modifiers.production * gravity_modifier
            elseif job == "researcher" then
                output.research = output.research + citizen.population  + citizen.population * research_bonus * government_modifiers.research * gravity_modifier
            end
        end
    end

    return output
end