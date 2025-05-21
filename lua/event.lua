--event.lua
AllEvents = {}

RandomEvent = {}
RandomEvent.__index = RandomEvent

function RandomEvent:new(name, victim)
    local this_event = EventDefinitions[name]
    if this_event then
        local event = {
            name = this_event.name,
            description = this_event.description,
            victim = victim,
            countdown = this_event.countdown or 0,
            action = this_event.action or function() end,
            removal = this_event.on_removal or function() end,
            resolution = this_event.on_resolution or function() end,
            tick = this_event.on_tick or function() end,
        }
        setmetatable(event, RandomEvent)
        
        if (event.countdown or 0) == 0 then
            print("Executing event action: " .. event.name)
            event.action(victim)
        else
            print("Storing event: " .. event.name .. " with countdown " .. event.countdown)
            table.insert(AllEvents, event)
        end

        return event
    else
        print("Warning: Undefined event '" .. tostring(name) .. "' was attempted to be created.")
    end 
end

function RandomEvent:rebuild(id, victim, countdown)
    local this_event = EventDefinitions[id]
    if this_event then
        local event = {
            name = this_event.name,
            description = this_event.description,
            victim = victim,
            countdown = countdown,
            action = this_event.action or function() end,
            removal = this_event.on_removal or function() end,
            resolution = this_event.on_resolution or function() end,
            tick = this_event.on_tick or function() end,
        }
        setmetatable(event, RandomEvent)
        
        if (event.countdown or 0) == 0 then
            print("Executing event action: " .. event.name)
            event.action(victim)
        else
            print("Storing event: " .. event.name .. " with countdown " .. event.countdown)
            table.insert(AllEvents, event)
        end

        return event
    else
        print("Warning: Undefined event of id: '" .. id .. "' was attempted to be created.")
    end 
end

function RandomEvent:serialize_data()
    local event_key

    for key, data in EventDefinitions do
        if data.name == self.name then
            event_key = key
        end
    end

    local event = {
        name = event_key,
        victim = self.victim and self.victim:serialize_data() or nil,
        countdown = self.countdown
    }
    return event
end

function RandomEvent:countdown_tick()
    self.tick(self.victim)

    if self.countdown > 0 then
        self.countdown = self.countdown - 1
    end

    if self.countdown == 0 then
        for i, event in ipairs(AllEvents) do
            if event == self then
                self.on_removal(self.victim)
                table.remove(AllEvents, i)
                break
            end
        end
    end
end

function RandomEvent:resolved()
    for i, event in ipairs(AllEvents) do
        if event == self then
            self.resolved(self.victim)
            table.remove(AllEvents, i)
            break
        end
    end
end


EventTypeKeys = {
    "colony",
    "system",
    "ship",
    "empire",
    "universal"
}

EventDefinitions = {
    -- Event Definitions
    -- Each event has a name, a description, and a function that determines if it can be triggered
    -- The function takes the current game state as an argument and returns true or false
    -- The function is called when the event is triggered
    { 
        name = "Plague",
        type = "colony",
        description = "A deadly plague has broken out on a colony. It will kill off millions of people if not contained",
        countdown = math.random(5, 15),
        action = function(victim)
            -- Action to take when the event is triggered
            victim.growth_rate = victim.growth_rate - 0.5
            print("The plague has spread! Your citizens are dying!")
        end,
        on_removal = function(victim)
            -- Action to take when the event is removed
            victim.growth_rate = victim.growth_rate + 0.5
            print("The plague has been contained!")
        end,
        on_tick = function(victim)
            -- Action to take when the event is removed
            if victim.population > 1 then
                victim:remove_random_citizen()
            end
        end,
        on_resolution = function(victim)
            -- Action to take when the event is removed
            victim.growth_rate = victim.growth_rate + 0.5
            print("Your scientists have successfully contained the plague!")
        end,
    },
    { 
        name = "Natural Disaster",
        type = "colony",
        description = "A natural disaster has struck a planet.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A natural disaster has occurred!")
        end,
    },
    {
        name = "Supernova",
        type = "system",
        description = "A supernova will occur in a nearby star system if empire scientists cannot find a solution!",
        countdown = 15,
        action = function(victim)
            -- Action to take when the event is triggered
            print("A supernova is imminent!")
        end,
        on_removal = function(victim)
            -- Action to take when the event is removed
            print("The supernova collapsed this star and destoyed all colonies within it!")
        end,
        on_resolution = function(victim)
            -- Action to take when the event is removed
            print("The supernova has been averted!")
        end,
    },
    {
        name = "Population Boom",
        type = "colony",
        description = "A population boom has occurred on a colony.",
        countdown = 5,
        action = function(victim)
            -- Action to take when the event is triggered
            victim.growth_rate = victim.growth_rate + 1.0
            print("A population boom has occurred!")
        end,
        on_removal = function(victim)
            -- Action to take when the event is removed
            victim.growth_rate = victim.growth_rate - 1.0
            print("The population boom has stabilized!")
        end,
    },
    {
        name = "Resource Discovery",
        type = "colony",
        description = "A new resource has been discovered on a planet.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A new resource has been discovered!")
        end,
    },
    {
        name = "Trade Route Disruption",
        type = "colony",
        description = "A trade route has been disrupted by pirates.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A trade route has been disrupted!")
        end,
    },
    {
        name = "Diplomatic Crisis",
        type = "empire",
        description = "A diplomatic crisis has arisen between two factions.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A diplomatic crisis has occurred!")
        end,
    },
    {
        name = "Technological Breakthrough",
        type = "empire",
        description = "A technological breakthrough has occurred.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A technological breakthrough has occurred!")
        end,
    },
    {
        name = "Space Anomaly",
        type = "universal",
        description = "A space anomaly has been discovered.",
        action = function(victim)
            -- Action to take when the event is triggered
            -- Spawn a new system?
            print("A space anomaly has been discovered!")
        end,
    },
    {
        name = "Galactic Council Meeting",
        type = "universal",
        description = "A galactic council meeting is being held.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A galactic council meeting is being held!")
        end,
    },
    {
        name = "Pirate Raid",
        type = "colony",
        description = "A pirate raid has occurred on a colony.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A pirate raid has occurred!")
        end,
    },
    {
        name = "Civil Unrest",
        type = "colony",
        description = "Civil unrest has broken out on a colony.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("Civil unrest has occurred!")
        end,
    },
    {
        name = "Comet Sighted",
        type = "colony",
        description = "A comet has been sighted in the system, it appears to be heading towards a colony.",
        countdown = 10,
        action = function(victim)
            -- Action to take when the event is triggered
            -- spawn a "fleet" that is just a comet flying towards the colony
            print("A comet has been sighted! We must send our fleet to eliminate it!")
        end,
    },
    {
        name = "Black Hole Discovery",
        type = "system",
        description = "A black hole has been discovered in the system.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A black hole has been discovered!")
        end,
    },
    {
        name = "Ancient Ruins",
        type = "system",
        description = "Ancient ruins have been discovered on a planet.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("Ancient ruins have been discovered!")
        end,
    },
    {
        name = "Space Weather Event",
        type = "universal",
        description = "A space weather event is occurring.",
        countdown = 10,
        action = function(victim)
            -- Action to take when the event is triggered
            -- create an area that slows travel through it
            print("A space weather event is occurring!")
        end,
    },
    {
        name = "Galactic Trade Fair",
        type = "universal",
        description = "A galactic trade fair is being held.",
        countdown = 3,
        action = function(victim)
            -- Action to take when the event is triggered
            print("A galactic trade fair is being held!")
        end,
    },
    {
        name = "Resource Scarcity",
        type = "colony",
        description = "A resource scarcity has occurred.",
        countdown = 5,
        action = function(victim)
            -- Action to take when the event is triggered
            print("A resource scarcity has occurred!")
        end,
    },
    {
        name = "Political Scandal",
        type = "empire",
        description = "A political scandal has erupted.",
        countdown = 5,
        action = function(victim)
            -- Action to take when the event is triggered
            print("A political scandal has erupted!")
        end,
        on_removal = function(victim)
            -- Action to take when the event is removed
            print("The political scandal has been resolved!")
        end,
    },
    {
        name = "Cultural Exchange",
        type = "empire",
        description = "A cultural exchange program is being held.",
        countdown = 5,
        action = function(victim)
            -- Action to take when the event is triggered
            print("A cultural exchange program is being held!")
        end,
        on_removal = function(victim)
            -- Action to take when the event is removed
            print("The cultural exchange program has ended!")
        end,
    },
    {
        name = "Military Parade",
        type = "colony",
        description = "A military parade is being held.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A military parade is being held!")
        end,
    },
    {
        name = "Antarans Invasion",
        type = "system",
        description = "The Antarans have invaded the system!",
        action = function(victim)
            -- Action to take when the event is triggered
            print("The Antarans have invaded the system!")
        end,
    },
    {
        name = "Artifact Theft",
        type = "empire",
        description = "An ancient artifact has been stolen.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("An ancient artifact has been stolen!")
        end,
    },
    {
        name = "Artifact Discovery",
        type = "empire",
        description = "An ancient artifact has been discovered.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("An ancient artifact has been discovered!")
        end,
    },
    {
        name = "Spy Network Revealed",
        type = "empire",
        description = "A spy network has been revealed on a colony.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A spy network has been revealed!")
        end,
    },
    {
        name = "Industrial Accident",
        type = "colony",
        description = "An industrial accident has occurred on a colony.",
        cooldown = 5,
        action = function(victim)
            -- Action to take when the event is triggered
            print("An industrial accident has occurred!")
        end,
        on_removal = function(victim)
            -- Action to take when the event is removed
            print("The industrial accident has been resolved!")
        end,
    },
    {
        name = "Wealthy Donor",
        type = "empire",
        description = "A wealthy donor has given a large sum to your cause.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A wealthy donor has offered to fund a project!")
        end,
    },
    {
        name = "Computer Virus",
        type = "empire",
        description = "A malicious bit of code has disrupted your empire's research database",
        action = function(victim)
            local random = math.random(0, 50)
            random = random + 50
            -- subtract this from the empire's current research
        end
    },
    {
        name = "Mysterious Alien Aboard",
        type = "ship",
        description = "A mysterious alien has boarded a ship.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A mysterious alien has boarded a ship!")
        end,
    },
    {
        name = "Ship Malfunction",
        type = "ship",
        description = "A ship has experienced a malfunction.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A ship has experienced a malfunction!")
        end,
    },
    {
        name = "Ship Discovery",
        type = "ship",
        description = "A ship has been discovered in the system.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A ship has been discovered!")
        end,
    },
    {
        name = "Ship Rescue",
        type = "ship",
        description = "A ship has been rescued.",
        action = function(victim)
            -- Action to take when the event is triggered
            print("A ship has been rescued!")
        end,
    },

}