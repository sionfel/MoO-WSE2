-- ship_combat.lua

function roll_damage(ship, weapon_id, target)
    local weapon_count =ship.weapons[weapon_id].weapon_count or 1
    local weapon = ShipWeaponDefinitions[ship.weapons[weapon_id].name]

    local crit_chance = weapon.crit_chance or 0
    local crit_multiplier = weapon.crit_multiplier or 1.5
    local weapon_accuracy = weapon.accuracy or 1.0
    local weapon_range_penalty = weapon.range_penalty or 1.0
    local damage = 0

    for i = 1, weapon_count do
        damage = math.random(weapon.min_damage, weapon.max_damage)
            -- Roll for critical hit
        if math.random() < crit_chance then
            damage = damage * crit_multiplier
            print("Critical hit! Damage: " .. damage)
        else
            print("Normal hit. Damage: " .. damage)
        end

        -- Roll for accuracy
        local accuracy = weapon.accuracy or 1.0
        if math.random() > accuracy then
            print("Missed!")
            return 0, target.shields, target.armor
        end

        -- Apply damage to target's shields and armor
        if target.shields > 0 then
            target.shields = target.shields - damage
            if target.shields < 0 then
                target.shields = 0
            end
        else
            target.armor = target.armor - damage
            if target.armor < 0 then
                target.armor = 0
            end
        end
    end
    
    return damage, target.shields, target.armor
end

function apply_weapon_modifiers(weapon)
    local modifiers = {
        damage_additive = 0,
        damage_multiplier = 0,
        range_penalty = 1.0,
        crit_chance = 1.0,
        crit_multiplier = 1.0,
        accuracy = 1.0,
    }

    for _ in #weapon.modifiers do
        if weapon.modifiers[_] then
            local modifier = weapon.modifiers[_]
            if modifier.damage_additive then
                modifiers.damage_additive = modifiers.damage_additive + modifier.damage_additive
            end
            if modifier.damage_multiplier then
                modifiers.damage_multiplier = modifiers.damage_multiplier + modifier.damage_multiplier
            end
            if modifier.range_penalty then
                modifiers.range_penalty = modifiers.range_penalty + modifier.range_penalty
            end
            if modifier.crit_chance then
                modifiers.crit_chance = modifiers.crit_chance + modifier.crit_chance
            end
            if modifier.crit_multiplier then
                modifiers.crit_multiplier = modifiers.crit_multiplier + modifier.crit_multiplier
            end
            if modifier.accuracy then
                modifiers.accuracy = modifiers.accuracy + modifier.accuracy
            end
        end
    end

    return modifiers
end

ShipCombatActionDefinitions = {
    scan = {},
    board = {},
    selfdestruct = {},
    
}