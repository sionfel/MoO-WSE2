-- fleet.lua
-- Structure exists on the players, holds controlled ships
require "ships"

Fleet = {}
Fleet.__index = Fleet

-- AllFleets = {}

function Fleet:new(player)
    local fleet = {
        --player = player.id,
        ships = {},
        ship_count = 0,
        total_command_cost = 0,
        total_score = 0,
    }
    setmetatable(fleet, Fleet)

    -- table.insert(AllFleets, fleet) -- Add the fleet to the global list of fleets
    return fleet
end

function Fleet:serialize_data()
    local data = {
        --player = self.player,
        ships = {},
        ship_count = self.ship_count,
        total_command_cost = self.total_command_cost,
        total_score = self.total_score,
    }

    for _, ship in pairs(self.ships) do
        table.insert(data.ships, ship:serialize_data())
    end

    return data
end

function Fleet:count_ships()
    local count = 0
    for _, ship in pairs(self.ships) do
        count = count + 1
    end
    self.ship_count = count
    return count
end

function Fleet:add_ship(ship, skip_score)
    skip_score = skip_score or false
    table.insert(self.ships, ship)
    self.ship_count = self.ship_count + 1
    if not skip_score then
        self:calculate_total_score()
        self:calculate_total_command_cost()
    end
end

function Fleet:add_ships(ships)
    for _, ship in ipairs(ships) do
        self:add_ship(ship)
    end

    self:calculate_total_score()
    self:calculate_total_command_cost()
end

function Fleet:remove_ship(ship, skip_score)
    skip_score = skip_score or false
    
    for i, s in ipairs(self.ships) do
        if s == ship then
            table.remove(self.ships, i)
            self.ship_count = self.ship_count - 1
            break
        end
    end

    if not skip_score then
        self:calculate_total_score()
        self:calculate_total_command_cost()
    end
end

function Fleet:remove_ships(ships)
    for _, ship in ipairs(ships) do
        self:remove_ship(ship, true)
    end

    self:calculate_total_score()
    self:calculate_total_command_cost()
end

function Fleet:clear_ships()
    self.ships = {}
    self.ship_count = 0
end

function Fleet:calculate_total_command_cost()
    local total_cost = 0
    for _, ship in pairs(self.ships) do
        total_cost = total_cost + ship.command_points
    end
    self.total_command_cost = total_cost
    return total_cost
end

function Fleet:calculate_total_score()
    local total_score = 0

    for _, ship in pairs(self.ships) do
        total_score = total_score + ship:get_score()
    end

    self.total_score = total_score
    return total_score
end