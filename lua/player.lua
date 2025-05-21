-- player.lua

require "fleet"
local class require("class")

AllPlayers = {}
ActivePlayers = {}
InactivePlayers = {}

Player = Class(nil, "Player")
AIPlayer = Class(Player, "AIPlayer")

function Player:init(race, is_human, name, color, id)
    -- add in game faction id, set faction color to their color
    self.id = id
    self.race = race
    self.is_human = is_human
    self.name = name or "none"
    self.color = color
    self.credits = 0
    self.research_points = 0
    self.command_points = 0
    self.current_research = nil
    self.ships_built = 0
    self.ships_captured = 0
    self.score = 0
    self.score_multiplier = 1
    self.active = true
    self.defeated = false
    self.turn_defeated = 0
    self.highest_research = {
        ["biology"] = {0, 0},
        ["chemistry"] = {0, 0},
        ["construction"] = {0, 0},
        ["computers"] = {0, 0},
        ["physics"] = {0, 0},
        ["power"] = {0, 0},
        ["sociology"] = {0, 0},
        ["force_fields"] = {0, 0},
        ["xenon"] = {0, 0},
    }
    self.technology = {
        research_id = nil,
        unlock_method = nil,
    }
    self.diplomacy = {
        treaties = {},
        relations = {},
        contacts = {},
        last_diplomatic_action = {
            action = nil,
            target = nil,
            turn = nil,
        }
    }
    self.spies = {}
    self.colonies = {}
    self.fleet = {}
    self.systems_charted = {}
    self.systems_visited = {}
    self.systems_discovered = {}
    self.citizens_captured = {}
    self.citizens_killed = {}
    self.ships_defeated = {}
    self.leaders = {}
end

function Player:load_existing(data)
    local player = setmetatable({}, Player)

    player.id = data.id
    player.race = data.race
    player.is_human = data.is_human
    player.name = data.name
    player.color = data.color
    player.credits = data.credits or 0
    player.research_points = data.research_points or 0
    player.command_points = data.command_points or 0
    player.current_research = data.current_research or nil
    player.ships_built = data.ships_built or 0
    player.ships_captured = data.ships_captured or 0
    player.score = data.score or 0
    player.score_multiplier = data.score_multiplier or 1
    player.active = data.active
    player.defeated = data.defeated
    player.turn_defeated = data.turn_defeated
    player.highest_research = data.highest_research or {
        ["biology"] = {0, 0},
        ["chemistry"] = {0, 0},
        ["construction"] = {0, 0},
        ["computers"] = {0, 0},
        ["physics"] = {0, 0},
        ["power"] = {0, 0},
        ["sociology"] = {0, 0},
        ["force_fields"] = {0, 0},
        ["xenon"] = {0, 0},
    }
    player.technology = data.technology or {
        research_id = nil,
        unlock_method = nil,
    }
    player.diplomacy = data.diplomacy or {
        treaties = {},
        relations = {},
        contacts = {},
        last_diplomatic_action = {
            action = nil,
            target = nil,
            turn = nil,
        }
    }
    player.spies = data.spies or {}
    player.colonies = data.colonies or {}
    player.fleet = data.fleet or {}
    player.systems_charted = data.systems_charted or {}
    player.systems_visited = data.systems_visited or {}
    player.systems_discovered = data.systems_discovered or {}
    player.citizens_captured = data.citizens_captured or {}
    player.citizens_killed = data.citizens_killed or {}
    player.ships_defeated = data.ships_defeated or {}
    player.leaders = data.leaders or {}
    
    return player
end

function AIPlayer:init(race, name, color, id)
    self.super.init(self, race, false, name, color, id)
    self.personality = nil
    self.objective = nil
    self.diplomacy = {
        wants_expansion = false,
        aggression = 0,
        aggression_inertia = 0,
    }
end

function AIPlayer:load_existing(data)
    local player = setmetatable({}, AIPlayer)

    player.id = data.id
    player.race = data.race
    player.is_human = data.is_human
    player.name = data.name
    player.color = data.color
    player.credits = data.credits or 0
    player.research_points = data.research_points or 0
    player.command_points = data.command_points or 0
    player.current_research = data.current_research or nil
    player.ships_built = data.ships_built or 0
    player.ships_captured = data.ships_captured or 0
    player.score = data.score or 0
    player.score_multiplier = data.score_multiplier or 1
    player.active = data.active
    player.defeated = data.defeated
    player.turn_defeated = data.turn_defeated
    player.highest_research = data.highest_research or {
        ["biology"] = {0, 0},
        ["chemistry"] = {0, 0},
        ["construction"] = {0, 0},
        ["computers"] = {0, 0},
        ["physics"] = {0, 0},
        ["power"] = {0, 0},
        ["sociology"] = {0, 0},
        ["force_fields"] = {0, 0},
        ["xenon"] = {0, 0},
    }
    player.technology = data.technology or {
        research_id = nil,
        unlock_method = nil,
    }
    player.diplomacy = data.diplomacy or {
        treaties = {},
        relations = {},
        contacts = {},
        last_diplomatic_action = {
            action = nil,
            target = nil,
            turn = nil,
        }
    }
    player.spies = data.spies or {}
    player.colonies = data.colonies or {}
    player.fleet = data.fleet or {}
    player.systems_charted = data.systems_charted or {}
    player.systems_visited = data.systems_visited or {}
    player.systems_discovered = data.systems_discovered or {}
    player.citizens_captured = data.citizens_captured or {}
    player.citizens_killed = data.citizens_killed or {}
    player.ships_defeated = data.ships_defeated or {}
    player.leaders = data.leaders or {}
    player.personality = data.personality or nil
    player.objective = data.objective or nil
    player.diplomacy = data.diplomacy or {
        wants_expansion = false,
        aggression = 0,
        aggression_inertia = 0,
    }

    return player
end

function Player:build_diplomacy_table(other_player)
    -- TODO: Add this incoming player to our table of diplomatic relations
    -- reciprocate by adding ourself to their table (if we aren't already there)
    table.insert(self.diplomacy.contacts, {other_player.id, 0})
    table.insert(other_player.diplomacy.contacts, {self.id, 0})
end

function Player:activate()
    if not self.active then
        self.active = true
        table.insert(ActivePlayers, self)
    end
end

function Player:serialize_data()
    local data = {
        id = self.id;
        race = self.race,
        is_human = self.is_human,
        name = self.name,
        color = self.color,
        personality = self.personality,
        objective = self.objective,
        credits = self.credits,
        research_points = self.research_points,
        command_points = self.command_points,
        current_research = self.current_research,
        ships_built = self.ships_built,
        ships_captured = self.ships_captured,
        score = self.score,
        score_multiplier = self.score_multiplier,
        active = self.active,
        defeated = self.defeated,
        turn_defeated = self.turn_defeated,
        highest_research = self.highest_research,
        technology = {},
        diplomacy = {},
        spies = {},
        colonies = self.colonies,
        fleet = self.fleet:serialize_data(),
        systems_charted = self.systems_charted,
        systems_visited = self.systems_visited,
        systems_discovered = self.systems_discovered,
        citizens_captured = {},
        citizens_killed = {},
        ships_defeated = {},
        leaders = {},
    }

    for technology in pairs(self.technology) do
        table.insert(data.technology, technology)
    end

    for _, spy in pairs(self.spies) do
        table.insert(data.spies, spy:serialize_data())
    end

    for _, colony in pairs(self.colonies) do
        table.insert(data.colonies, colony.party_id)
    end

    -- for _, fleet in pairs(self.fleet) do
    --     table.insert(data.fleet, fleet:serialize_data())
    -- end

    for _, citizen in pairs(self.citizens_captured) do
        table.insert(data.citizens_captured, citizen)
    end

    for _, citizen in pairs(self.citizens_killed) do
        table.insert(data.citizens_killed, citizen)
    end

    for leader in pairs(self.leaders) do
        table.insert(data.leaders, leader.leader_id)
    end
    return data
end

function Player:add_colony(colony)

end

function Player:add_ships(ships, built_or_captured)
    for _, ship in ipairs(ships) do
        ship.fleet:add_ships(ship)

        if built_or_captured == "built" then
            self.ships_built = self.ships_built + 1
        elseif built_or_captured == "captured" then
            self.ships_captured = self.ships_captured + 1
        end
    end
end

function Player:deactivate()
    self.active = false
    for i, player in ipairs(ActivePlayers) do
        if player == self then
            table.remove(ActivePlayers, i)
            break
        end
    end
    table.insert(InactivePlayers, self)
end

function Player:capture_citizen(citizen)
    -- Validate input
    if type(citizen) ~= "table" or not citizen.race or not citizen.population then
        error("Invalid citizen data")
    end
    if type(citizen.population) ~= "number" then
        error("Invalid population value")
    end

    local race = AllRacesByName[citizen.race]
    local population = citizen.population

    -- Check if the race already exists in the captured list
    for _, captured_citizen in ipairs(self.citizens_captured) do
        if captured_citizen.race == citizen.race then
            captured_citizen.population = captured_citizen.population + population
            return
        end
    end

    -- Add a new entry if the race does not exist
    local new_citizen = {race_name = citizen.race, population = population}
    table.insert(self.citizens_captured, new_citizen)
end

function Player:declare_war(target_player)
    -- Check if the target player is valid
    if not target_player or not target_player.is_human then
        print("Invalid target player for war declaration.")
        return false
    end

    -- Check if the player has enough resources to declare war
    if self.credits < 1000 then
        print("Not enough credits to declare war.")
        return false
    end

    -- Deduct the cost of declaring war
    self.credits = self.credits - 1000

    -- Update the last diplomatic action
    self.diplomacy.last_diplomatic_action.action = "declare_war"
    self.diplomacy.last_diplomatic_action.target = target_player
end

function Player:is_defeated()
    -- Check if the player is already defeated
    if self.defeated then
        
        return true
    end
    -- Check if the player has lost all colonies or fleets
    if #self.colonies == 0 and #self.fleets == 0 then
        self.defeated = true
        self:deactivate()
        return true
    end
    return false
end

function Player:can_inhabit_planet(planet)
    local type = planet.type
    local race = self:get_race()
    local tech = self.technology

    if type == "barren" then
        if race:has_trait("SpecialTolerant") then return true end
    elseif type == "radiated" then
        return false
    end
end

function Player:planet_suitability_rating(planet)
    local race = self:get_race()
    local preferred_gravity = race:preferred_gravity()
    local planet_gravity = planet.gravity
    local rating = 0
    -- check if we find the planet to be habitable, of our preferred gravity for our race,
    if self:can_inhabit_planet(planet) then
        rating = rating + 10
    else
        rating = rating - 10
    end

    if preferred_gravity == planet_gravity then
        rating = rating + 5
    else
        rating = rating - 5
    end

    rating = rating + math.ceil(PlanetarySizeDefinitions[planet.size].max_population_1 / 2)
    rating = rating + PlanetaryRichnessDefinitions[planet.richness].production_base

    return rating
end

--- func desc
--- @return table
function Player:get_race()
    local race_name = self.race
    local race = AllRacesByName[race_name]

    if not race then
        error("No such race in list AllRacesByName")
    end

    return race
end

function Player:on_start_turn()
    -- e.g. notify UI, update colony status
end

function Player:take_turn()
    if self.is_human then
        -- open UI
    else
        -- run AI logic
    end
end

function Player:on_end_turn()
    -- finalize production, cleanup, etc.
end


PlayerObjectiveDefinitions = {
	expansionist = {
		name = "Expansionist",
	},
	ecologist = {
		name = "Ecologist",
	},
	diplomat = {
		name = "Diplomat",
	},
	industrialist = {
		name = "Industrialist",
	},
	militarist = {
		name = "Militarist",
	},
	technologist = {
		name = "Technologist",
	},
}

PlayerPersonalityDefinitions = {
	-- Used to determine probablity of friendly actions per turn
	pacifist = {
		name = "Pacifist",
		personality_modifier = 20,
		-- will never use biological weapons
	},
	honorable = {
		name = "Honorable",
		personality_modifier = 10,
		-- dishonorable actions are not possible
		-- will never use biological weapons
		-- double penalty for dishonorable actions against them
	},
	erratic = {
		name = "Erratic",
		personality_modifier = 0,
		-- rolled randomly each turn, can range from -40 to 40
		-- 2% chance to declare war each turn on random target
	},
	aggressive = {
		name = "Aggressive",
		personality_modifier = -10,
		-- will additionally freely use biological weapons
		-- twice as likely to expand into unsettled systems
	},
	ruthless = {
		name = "Ruthless",
		personality_modifier = -30,
		-- will additionally freely use biological weapons
	},
	xenophobic = {
		name = "Xenophobic",
		personality_modifier = -50,
		-- double penalty for diplomatic actions against them
		-- half gain on diplomatic actions towards them
		-- will always take the opprotunity to attack
	},

}

DefaultEmpireColors = {
	{177, 16, 0}, -- Red
	{0, 125, 49}, -- Green
	{44, 15, 186}, -- Blue
	{197, 173, 0}, -- Yellow
	{179, 103, 13}, -- Orange
	{117, 33, 143}, -- Purple
	{142, 88, 59}, -- Brown
	{115, 130, 138}, -- Gray
	{0, 255, 255}, -- Cyan
	{255, 20, 147} -- Deep Pink
}
