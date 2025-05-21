require "traits"

Race = {}
Race.__index = Race

function Race:new(name)
    local race = {
        name = name,
		leader = "none",
        traits = {},
        is_custom = false,
        is_playable = false,
    }
    setmetatable(race, Race)
    return race
end

function Race:new_with_traits(name, traits)
    local race = self:new(name)
    race:add_traits(traits)
    return race
end

function Race:new_custom(name, traits, visuals)
    local race = self:new_with_traits(name, traits)
    race.is_custom = true
    race.base_race = visuals
    return race
end

function Race:set_playable(is_playable)
    self.is_playable = is_playable
end

function Race:copy_traits_to_from(race_to, race_from)
   race_to:add_traits(race_from.traits)
end

function Race:add_trait(trait_id)
	local trait = RacialTraitDefinitions[trait_id]
	if trait then
	
		if trait.type ~= "special" then
			for existing_id, existing_trait in pairs(self.traits) do
				if existing_trait.type == trait.type then
					-- print("Replacing existing " .. existing_trait.type .. " trait: " .. existing_id .. " with " .. trait_id)
					self.traits[existing_id] = nil
					break
				end
			end
		end
	
		if not self.traits[trait_id] then
            self.traits[trait_id] = trait
            -- table.insert(self.traits, trait)
        else
            print("Trait already exists: " .. trait_id)
        end
	else
		error("Unknown trait: " .. tostring(trait_id))
	end
end

function Race:add_traits(trait_ids)
    for _, trait_id in ipairs(trait_ids) do
        self:add_trait(trait_id)  -- Reuse the existing add_trait function
    end
end

function Race:total_trait_cost()
    local total = 0
    for _, trait in pairs(self.traits) do
        if trait.cost then
            total = total + trait.cost
        end
    end
    return total
end

function Race:get_total_bonuses()
    if self._cached_bonuses then return self._cached_bonuses end
    local totals = {}

    for _, trait in pairs(self.traits) do
        for _, bonus_key in ipairs(RacialBonusKeys) do
            if trait[bonus_key] then
                totals[bonus_key] = (totals[bonus_key] or 0) + trait[bonus_key]
            end
        end
    end

    if self._cached_bonuses then return self._cached_bonuses end
    return totals
end

function Race:has_trait(trait_id)
    local trait = RacialTraitDefinitions[trait_id]
   
    if not trait then
        error("Unknown trait: " .. tostring(trait_id))
    end

    return self.traits[trait_id] ~= nil
end

function Race:preferred_gravity()
    local preferred_gravity = "normal"

    if self:has_trait("SpecialLowGWorld") then preferred_gravity = "low" end
    if self:has_trait("SpecialHighGWorld") then preferred_gravity = "high" end

    return preferred_gravity
end

function race_diff(current, base)
    local diff = {}

    if current.leader ~= base.leader then
        diff.leader = current.leader
    end

    local trait_diff = {}
    for id, _ in pairs(current.traits) do
        if not base.traits[id] then
            table.insert(trait_diff, id)
        end
    end
    if #trait_diff > 0 then
        diff.traits = trait_diff
    end

    return next(diff) and diff or nil
end

function apply_race_diff(base, diff)
    if diff.leader then
        base.leader = diff.leader
    end

    if diff.traits then
        for _, trait_id in ipairs(diff.traits) do
            base:add_trait(trait_id)
        end
    end

    return base
end

function Race:get_government()
    for trait_id, trait in pairs(self.traits) do
        if trait.type == "government" then
            return trait_id
        end
    end
end

playable_race_trait_lists = {
	{"GovernmentDictator", "ShipDefenseGreat", "SpecialArtifactsWorld", }, -- alkari
	{"GovernmentDictator", "ShipAttackGood", "GroundCombatGood", "SpecialHighGWorld"}, -- Bulrathi
	{"GovernmentDictator", "SpecialStealthyShips", "SpyingGreat" }, -- Darlock
	{"GovernmentDemocracy", "SpecialCharismatic"}, -- Human
	{"GovernmentUnification", "SpecialUncreative", "SpecialLargeHomeWorld", "FarmingGood"}, -- Klackon
	{"GovernmentDictator", "IndustryGreat", "SpecialCybernetic"}, -- Meklar
	{"GovernmentDictator", "ShipAttackGreat", "SpecialRichHomeWorld", "SpecialWarlord"}, -- Mrrshan
	{"GovernmentDictator", "ResearchGreat", "SpecialCreative", "SpecialLargeHomeWorld", "SpecialLowGWorld"}, -- Psilon
	{"GovernmentFeudal", "PopulationGrowthGreat", "FarmingGood", "SpecialLargeHomeWorld", "SpecialSubterranean", "SpyingBad"}, -- Sakkra
	{"GovernmentDictator", "PopulationGrowthBad", "SpecialRepulsive", "SpecialTolerant", "SpecialLithovore"}, -- Silicoid
	{"GovernmentFeudal", "ShipDefenseGood", "ShipAttackGood", "SpecialOmniscient", "SpecialTelepathic"}, -- Elerian
	{"GovernmentDictator", "EconomicGreat", "SpecialLowGWorld", "SpecialTraders", "SpecialLucky"}, -- Gnolam
	{"GovernmentDictator", "SpecialAquatic", "SpecialTransDimensional"}, -- Trilarian
	{"GovernmentDictator", "SpecialCharismatic", "ShipAttackGood", "GroundCombatGood", "SpecialPoorHomeWorld", "SpecialWarlord"}, -- Terran
}