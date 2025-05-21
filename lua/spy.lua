-- spy.lua

Spy = {}
Spy.__index = Spy

function Spy:new(name)
    local spy = {
		name = name,
        experience = 0,
        level = 0,
        current_action = {
            type = nil,
            target = nil,
        },
        last_report ={
            turn = 0,
            type = nil,
            target = nil,
            result = nil,
        }
    }
    setmetatable(spy, Spy)
    return spy
end

function Spy:serialize_data()
    local data = {
        name = self.name,
        experience = self.experience,
        level = self.level,
        current_action = self.current_action,
        last_report = self.last_report,
    }
    return data
end

function Spy:increase_experience(amount)
    self.experience = self.experience + amount
    if self.experience >= 20 * self.level then
        self.level = self.level + 1
        self.experience = 0
    end
end

function Spy:succeed_action(action_type, target)
    local action = SpyActionDefinitions[action_type]

    self.last_report.turn = current_turn
    self.last_report.type = action_type
    self.last_report.target = target
    self.last_report.result = "Success"
    self:increase_experience(10 * action.difficulty)  -- Increase experience on success
end

function Spy:fail_action(action_type, target)
    self.last_report.turn = current_turn
    self.last_report.type = action_type
    self.last_report.target = target
    self.last_report.result = "Failure"
    self:increase_experience(-5)  -- Decrease experience on failure
    -- TODO: Add consequences for failure, like being captured or being "eliminated"

end

function Spy:eliminate()
    -- delete spy, remove from all lists
end

function Spy:report()
    if not self.last_report then
        return "No report available."
    end
    return self.last_report
end

function Spy:set_action(type, target)
    self.current_action = type
    self.target = target
end

function Spy:cancel_action()
    self.current_action = nil
    self.target = nil
end

function Spy:check_action()
    if self.current_action and self.target then
        local action = SpyActionDefinitions[self.current_action]
        if action then
            local success_chance = action.success_rate + (self.level * 0.01)  -- Increase success chance with level
            if math.random() < success_chance then
                self:succeed_action(self.current_action, self.target)
            else
                self:fail_action(self.current_action, self.target)
            end
        else
            print("Invalid action type.")
        end
    else
        print("No action set.")
    end
end

SpyActionDefinitions = {
    
    -- Against Players
    gather_intelligence = {
        name = "Gather Intelligence",
        description = "Gather information about the target.",
        success_rate = 0.7,
        failure_rate = 0.3,
        difficulty = 0.2,
    },
    steal_technology = {
        name = "Steal Technology",
        description = "Steal technology from the target.",
        success_rate = 0.6,
        failure_rate = 0.4,
        difficulty = 0.4,
    },
    assassinate = {
        name = "Assassinate",
        description = "Assassinate a target.",
        success_rate = 0.2,
        failure_rate = 0.6,
        difficulty = 0.8,
    },

    -- Against Colonies
    incite_rebellion = {
        name = "Incite Rebellion",
        description = "Incite a rebellion in the target's territory.",
        success_rate = 0.5,
        failure_rate = 0.5,
        difficulty = 0.5,
    },
    sabotage_colony = {
        name = "Sabotage Colony",
        description = "Sabotage a colony.",
        success_rate = 0.4,
        failure_rate = 0.6,
        difficulty = 0.7,
    },

    -- Against Fleets
    sabotage_ship = {
        name = "Sabotage Ship",
        description = "Sabotage a ship.",
        success_rate = 0.5,
        failure_rate = 0.5,
        difficulty = 0.6,
    },

}