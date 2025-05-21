require "traits"

Citizens = {}
Citizens.__index = Citizens

function Citizens:new(race, population)
    return setmetatable({
        race = race,
        population = population
    }, Citizens)
end

function Citizens:increase_population(amount)
    self.population = self.population + amount
end

function Citizens:decrease_population(amount)
    self.population = self.population - amount
    if self.population < 0 then
        self.population = 0
    end
end

function Citizens:get_population()
    return self.population
end

function Citizens:get_race()
    local race = AllRacesByName[self.race]

    if not race then
        error("Race not found for citizen: " .. tostring(self.race))
    end

    return race
end

function get_citizen_bonuses(citizen)
    local race = AllRacesByName[citizen.race]
    if not race then
        error("Race not found for citizen: " .. tostring(citizen.race))
    end

    local bonuses = race:get_total_bonuses()
    return bonuses
end