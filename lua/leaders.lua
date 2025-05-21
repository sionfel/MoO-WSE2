--leaders.lua

require "traits"

Leader = {}
Leader.__index = Leader

function Leader:new(name)
    local leader = {
		name = name,
        experience = 0,
        level = 0,
        type = nil,
        alive = true,
        employed_by = nil,
        in_pool = false,
        visiting_empire = nil, -- tracks which player the they are currently presented to
        visit_duration = 0, -- how long they are presented to the player
        assignment = nil, -- where they are assigned
        traits = {},
    }
    setmetatable(leader, Leader)
    return leader
end

LeaderPool = {}

function Leader:add_to_pool()
    self.in_pool = true
    table.insert(LeaderPool, self)
end

function Leader:remove_from_pool()
    for i, leader in ipairs(LeaderPool) do
        if leader == self then
            table.remove(LeaderPool, i)
            break
        end
    end
    self.in_pool = false
end

function Leader:visit(empire, duration)
    if self.visiting_empire then
        error("Leader " .. self.name .. " is already visiting " .. tostring(self.visiting_empire))
    end

    self.visiting_empire = empire
    self.visit_duration = duration
end

function Leader:leave_visit()
    if not self.visiting_empire then
        error("Leader " .. self.name .. " is not visiting any empire")
    end

    self.visiting_empire = nil
    self.visit_duration = 0
end

function Leader:visit_tick()
    if self.visit_duration > 0 then
        self.visit_duration = self.visit_duration - 1
    end

    if self.visit_duration <= 0 then
        self:leave_visit()
    end
end

function Leader:hire(employer)
    if self.employed_by then
        error("Leader " .. self.name .. " is already employed by " .. tostring(self.employed_by))
    end

    self.employed_by = employer
    self:remove_from_pool()

    employer.leaders = employer.leaders or {}  -- Ensure leaders table exists
    employer.leaders[self.name] = self  -- Add to employer's list of leaders
end

function Leader:fire()
    if not self.employed_by then
        error("Leader " .. self.name .. " is not employed")
    end

    local leaders = self.employed_by.leaders

    if leaders[self.name] then
        leaders[self.name] = nil  -- Remove leader by name
    else
        error("Leader " .. self.name .. " is not found in employer's list")
    end

    self.employed_by = nil
    self:add_to_pool()
end

function Leader:add_experience(amount)
    self.experience = self.experience + amount
    if self.experience >= self:experience_to_next_level() then
        self:level_up()
    end
end

function Leader:experience_to_next_level()
    return (self.level + 1) * 100  -- Example formula for leveling up
end

function Leader:level_up()
    self.level = self.level + 1
    self.experience = 0
    print(self.name .. " has leveled up to level " .. self.level .. "!")
end

function Leader:assign(task)
    if not self.alive then
        error("Cannot assign a dead leader")
    end

    self.assignment = task
    print(self.name .. " has been assigned to " .. task)
end

function Leader:unassign()
    self.assignment = nil
    print(self.name .. " has been unassigned")
end

function Leader:die()
    if self.employed_by then
        self:fire()
    end
    self.alive = false
    print(self.name .. " has died.")
end

LeaderTypeDefinitions = {
    ship = {
        name = "Ship Leader",
        description = "A leader specialized in commanding ships.",
    },
    colony = {
        name = "Colony Leader",
        description = "A leader specialized in managing colonies.",
    },
}
