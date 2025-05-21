-- ships.lua
-- Template for fleets, freighters, and transport vessels in Mount & Blade Warband (Lua)

-- Base Ship Class
Ship = {}
Ship.__index = Ship

AllShips = {}
AllShipDesigns = {}

function Ship:new(name, creator)
    local obj = {
        ship_id = #AllShips + 1,
        party_id = 0,
        creator = creator,
        owner = creator,
        name = name or "Unnamed Ship",
        -- move most to ship designs
        design = 0,
        size = "Medium",
        engine = "Nuclear",
        armor = "Standard",
        fuel_cells = "Standard",
        computer = "Standard",
        shields = "Standard",
        marines = 0,
        stationary = false,
        build_cost = 0,
        maintenance_cost = 0,
        command_points = 0,
        speed = 0,
        combat_speed = 0,
        range = 0,
        crew_level = 0,
        crew_experience = 0,
        Leader = nil,
        weapons = {},
        specials = {},
        stats = {
            enemies_defeated = 0,
            damage_taken = 0,
            damage_dealt = 0,
            planets_bombarded = 0,
            systems_visited = 0,
            systems_charted = 0,
        }
    }
    setmetatable(obj, self)

    table.insert(AllShips, obj) 
    return obj
end

function Ship:initialize()
    -- Racial Bonuses
    if self.creator.race:has_trait("SpecialWarlord") then
        self.crew_level = 1
    end

    self.build_cost = self:determine_cost()
    self.speed = self:determine_speed()
    self.combat_speed = self:combat_speed()
    self.range = self:determine_range()
end

function Ship:determine_cost()
    local cost = 0
    local size = self.size
    local engine = self.engine
    local armor = self.armor
    local fuel_cells = self.fuel_cells
    local computer = self.computer
    local shields = self.shields

    -- Calculate cost based on components and size
    cost = cost + (size * 100) + (engine * 50) + (armor * 30) + (fuel_cells * 20) + (computer * 40) + (shields * 60)

    -- Add cost for each weapon and special
    for _, weapon in ipairs(self.weapons) do
        cost = cost + (weapon.count * 10)
    end

    for _, special in ipairs(self.specials) do
        cost = cost + 20
    end

    return cost
end

function Ship:determine_speed()
    local speed = 0
    local size = self.size
    local engine = self.engine
    local armor = self.armor
    local fuel_cells = self.fuel_cells
    local computer = self.computer
    local shields = self.shields

    -- Calculate speed based on components and size
    speed = speed + (size * 10) + (engine * 5) + (armor * 2) + (fuel_cells * 3) + (computer * 4) + (shields * 6)

    return speed
end

function Ship:determine_combat_speed()
    local combat_speed = 0
    local size = self.size
    local engine = self.engine
    local armor = self.armor
    local fuel_cells = self.fuel_cells
    local computer = self.computer
    local shields = self.shields

    -- Calculate combat speed based on components and size
    combat_speed = combat_speed + (size * 5) + (engine * 3) + (armor * 1) + (fuel_cells * 2) + (computer * 2) + (shields * 4)

    return combat_speed
end

function Ship:determine_range()
    local range = 0
    local engine = self.engine
    local fuel_cells = self.fuel_cells

    for _, special in ipairs(self.specials) do
        -- Check for specials that affect range like additional fuel cells or engines
    end

    -- Calculate range based on components and size
    range = range + (engine * 1) + (fuel_cells * 1)

    return range
end


function Ship:add_weapons(weapon_name, weapon_count, weapon_arc, weapon_mods)
    local weapon = {
        id = #self.weapons + 1,
        name = weapon_name,
        count = weapon_count,
        arc = weapon_arc,
        mods = weapon_mods,
    }
    table.insert(self.weapons, weapon)
end

function Ship:weapon_has_mod(weapon_id, mod_name)
    local weapon = self.weapons[weapon_id]

    if not weapon then
        print("Warning: Invalid weapon ID " .. tostring(weapon_id))
        return false
    end

    for _, mod in ipairs(weapon.mods) do
        if string.lower(mod) == string.lower(mod_name) then
            return true
        end
    end

    return false
end

function Ship:add_special(special_name)
   
    local special = ShipSpecialsDefinitions[special_name]
    if special then
        local normalized_name = string.lower(special_name) -- Normalize the key to lowercase
        if not self.specials[normalized_name] then
            self.specials[normalized_name] = special
        else
            print("Special Module exists: " .. special_name)
        end
    else
        error("Unknown Special Module: " .. tostring(special_name))
    end
end

function Ship:has_special(special_name)
    local normalized_name = string.lower(special_name) -- Normalize the input to lowercase
    return self.specials[normalized_name] ~= nil
end

function Ship:crew_add_experience(amount)
    self.crew_experience = self.crew_experience + amount
    if self.crew_experience >= 20 * self.crew_level and self:crew_can_level() then
        self.crew_level = self.crew_level + 1
        self.crew_experience = 0
    end
end

function Ship:crew_can_level()
    local owner_race = self.creator.race
    local level_cap = 6

    if owner_race:has_trait("SpecialWarlord") then
        level_cap = 7
    end

    if self.crew_level > level_cap then
        return true
    else
        return false
    end
end

function Ship:get_score()
    local score = 0
    score = score + ShipHullDefinitions[self.size].size * 10
    score = score + ShipDriveDefinitions[self.engine].warp_speed * 5
    score = score + self.stats.enemies_defeated * 2
    score = score + self.stats.damage_dealt * 1.5
    score = score + self.stats.planets_bombarded * 3
    score = score + self.stats.systems_charted * 10
    score = score + self.stats.damage_dealt * 0.5
    return score
end

function Ship:destroyed_value()
    -- Calculate the value of the ship based on its components and offensive stats
    local value = 0
    value = value + ShipHullDefinitions[self.size].cost * 0.5
    value = value + ShipDriveDefinitions[self.engine].warp_speed * 10
    return value
end

function Ship:visited_system(system_id)
    self.stats.systems_visited = self.stats.systems_visited + 1

    system_id:visit(self.owner)
end

function Ship:charted_system(system_id)
    self.stats.systems_charted = self.stats.systems_charted + 1

    system_id:chart(self.owner)
end

function Ship:captured(player)
    self.owner.fleet:remove_ship(self)
    self.owner = player
    player.fleet:add_ship(self)
    player.ships_captured = player.ships_captured + 1
end

function Ship:destroy()
    self.owner.fleet:remove_ship(self)
end

function Ship:destroyed_by(player)
    local ship_record = { self.name, self.design, self:destroyed_value() }
    self:destroy()
    table.insert(player.ships_defeated, ship_record)
end

function Ship:serialize_data()
    local data = {
        ship_id = self.ship_id,
        party_id = self.party_id,
        creator = self.creator,
        owner = self.owner,
        name = self.name,
        design = self.design,
        size = self.size,
        engine = self.engine,
        armor = self.armor,
        fuel_cells = self.fuel_cells,
        computer = self.computer,
        shields = self.shields,
        marines = self.marines,
        stationary = self.stationary,
        build_cost = self.build_cost,
        maintenance_cost = self.maintenance_cost,
        command_points = self.command_points,
        speed = self.speed,
        combat_speed = self.combat_speed,
        range = self.range,
        crew_level = self.crew_level,
        crew_experience = self.crew_experience,
    }
    return data
end

ShipSpecialKeys = {
    "stealth",
    "cloaking_device",
    "hull_integrity",
    "engine_efficiency",
}

ShipWeaponTypes = {
    "Laser",
    "Missile",
    "Beam",
    "Torpedo",
    "Fighter",
    "Bomb",
}

ShipWeaponArcs = {
    "Forward",
    "Forward Ext",
    "Backward",
    "Backward Ext",
    "All"
}

ShipArmorTypes = {
    "no_armor",
    "titanium",
    "tritanium",
    "zortrium",
    "neutronium",
    "adamantium",
    "xentronium",
}

ShipShieldTypes = {
    "no_shield",
    "class_1",
    "class_3",
    "class_5",
    "class_7",
    "class_10",
}

ShipDriveTypes = {
    "nuclear",
    "fusion",
    "ion",
    "antimatter",
    "hyper",
    "interphased",
}

ShipHullSizes = {
    "frigate",
    "destroyer",
    "cruiser",
    "battleship",
    "titan",
    "doomstar",
    "star_base",
    "battlestation",
    "star_fortress",
}

ShipComputerTypes = {
    "no_computer",
    "electronic_computer",
    "optronic_computer",
    "positronic_computer",
    "cybertronic_computer",
    "moleculartronic_computer",
}

ArmorTypeDefinitions = {
no_armor = {
    name = "No Armor",
    short_name = "None",
    description = "No Armor.",
    armor_value = 0
},
titanium = {
    name = "No Armor",
    short_name = "None",
    description = "No Armor.",
    armor_value = 0
},
tritanium = {
    name = "No Armor",
    short_name = "None",
    description = "No Armor.",
    armor_value = 0
},
zortrium = {
    name = "No Armor",
    short_name = "None",
    description = "No Armor.",
    armor_value = 0
},
neutronium = {
    name = "No Armor",
    short_name = "None",
    description = "No Armor.",
    armor_value = 0
},
adamantium = {
    name = "No Armor",
    short_name = "None",
    description = "No Armor.",
    armor_value = 0
},
xentronium = {
    name = "No Armor",
    short_name = "None",
    description = "No Armor.",
    armor_value = 0
},
}

ShipShieldDefinitions = {
    no_shield = {
        name = "No Shield",
        short_name = "None",
        description = "No Shield.",
    },

    class_1 = {
        name = "Class I Shield",
        short_name = "I",
        description = "Standard Starship Shield.",
    },

    class_3 = {
        name = "Class III Shield",
        short_name = "III",
        description = "Advanced Starship Shield.",
    },

    class_5 = {
        name = "Class V Shield",
        short_name = "V",
        description = "Advanced Starship Shield.",
    },
    class_7 = {
        name = "Class VII Shield",
        short_name = "VII",
        description = "Advanced Starship Shield.",
    },
    class_10 = {
        name = "Class X Shield",
        short_name = "X",
        description = "Advanced Starship Shield.",
    },
}

ShipDriveDefinitions = {
    nuclear = {
        name = "Nuclear Drive",
        short_name = "N",
        description = "Standard Nuclear Drive.",
        warp_speed = 2,
    },
    fusion = {
        name = "Fusion Drive",
        short_name = "F",
        description = "Advanced Fusion Drive.",
        warp_speed = 3,
    },
    ion = {
        name = "Ion Fission Drive",
        short_name = "I",
        description = "Advanced Ion Drive.",
        warp_speed = 4,
    },
    antimatter = {
        name = "Antimatter Fission Drive",
        short_name = "AM",
        description = "Advanced Antimatter Drive.",
        warp_speed = 5,
    },
    hyper = {
        name = "Hyperdrive",
        short_name = "H",
        description = "Advanced Hyperdrive.",
        warp_speed = 6,
    },
    interphased = {
        name = "Interphased Drive",
        short_name = "IP",
        description = "Advanced Interphased Drive.",
        warp_speed = 7,
    },
}

ShipHullDefinitions = {
    frigate = {
        name = "Frigate",
        short_name = "F",
        description = "Standard Frigate.",
        space = 25,
        cost = 20,
        marines = 5,
        armor_hp = 4,
        structure_hp = 4,
        computer_hp = 1,
        drive_hp = 2,
        shield_hp = 1,
        size = 1,
        command_points = 1,
    },
    destroyer = {
        name = "Destroyer",
        short_name = "D",
        description = "Standard Destroyer.",
        size = 2,
        command_points = 2,
    },
    cruiser = {
        name = "Cruiser",
        short_name = "C",
        description = "Standard Cruiser.",
        size = 3,
        command_points = 3,
    },
    battleship = {
        name = "Battleship",
        short_name = "B",
        description = "Standard Battleship.",
        size = 4,
        command_points = 4,
    },
    titan = {
        name = "Titan",
        short_name = "T",
        description = "Standard Titan.",
        size = 5,
        command_points = 5,
    },
    doomstar = {
        name = "Doomstar",
        short_name = "DS",
        description = "Standard Doomstar.",
        size = 6,
        command_points = 6,
    },
    star_base = {
        name = "Star Base",
        short_name = "SB",
        description = "Standard Star Base.",
        size = 7,
        command_points = -1,
    },
    battlestation = {
        name = "Battlestation",
        short_name = "BS",
        description = "Standard Battlestation.",
        size = 8,
        command_points = -2,
    },
    star_fortress = {
        name = "Star Fortress",
        short_name = "SF",
        description = "Standard Star Fortress.",
        size = 9,
        command_points = -3,
    },
    
}

ShipWeaponDefinitions = {
    no_weapons = {},
    mass_driver = {},
    gauss_cannon = {}, 
    laser_cannon = {},
    particle_beam = {},
    fusion_beam = {},
    ion_pulse_cannon = {},
    graviton_beam = {},
    neutron_blaster = {},
    phasor = {},
    disrupter = {},
    death_ray = {},
    plasma_cannon = {},
    spatial_compressor = {},
    nuclear_missile = {},
    merculite_missile = {},
    pulson_missile = {},
    zeon_missile = {},
    anti_matter_torpedo = {},
    proton_torpedo = {},
    plasma_torpedo = {},
    nuclear_bomb = {},
    fusion_bomb = {},
    anti_matter_bomb = {},
    neutronium_bomb = {},
    death_spore = {},
    bio_terminator = {},
    mauler_device = {},
    assault_shuttle = {},
    heavy_fighter = {},
    bomber = {},
    interceptor = {},
    stasis_field = {},
    anti_missile_rocket = {},
    gyro_destabilizer = {},
    plasma_web = {},
    pulsar = {},
    black_hole_generator = {},
    stellar_converter = {},
    tractor_beam = {},
    dragon_breath = {},
    phasor_eye = {},
    crystal_ray = {},
    plasma_breath = {},
    plasma_flux = {},
    caustic_slime = {},
}

ShipWeaponsMods = {
    auto_fire = {
        name = "Auto-Fire",
        short_name = "AF",
        description = "Weapon fires 3 seperate shots per use.",
        applied_to = {
            "Laser",
            "Beam",
        },
        min_level = 2,
        cost_linear = 50,
        size_linear = 50,
        accuracy_multiplicative = -0.2,
    },
    armor_piercing = {
        name = "Armor Piercing",
        short_name = "AP",
        description = "Weapon ignores armor except Xentronium.",
        min_level = 1,
        applied_to = {
            "Laser",
            "Beam",
        },
        cost_multiplicative = 0.5,
        size_multiplicative = 0.5,
    },
    heavily_armored = {
        name = "Heavily Armored",
        short_name = "HA",
        description = "Weapon is heavily armored, increasing the amount of damage needed to intercept it.",
        min_level = 1,
        applied_to = {
            "Missile",
        },
        size_multiplicative = 0.25,
        cost_multiplicative = 0.25,
    },
    continuous = {
        name = "Continuous",
        short_name = "CO",
        description = "Prevents a beam weapon from overheating as quickly, allowing it to fire over a longer duration",
        min_level = 1,
        applied_to = {
            "Laser",
            "Beam",
        },
        accuracy_linear = 20,
        cost_multiplicative = 0.5,
        size_multiplicative = 0.5,
    },
    eccm = {
        name = "Electronic Counter-Counter-Measures",
        short_name = "ECCM",
        description = "Weapon is equipped with ECCM, allowing it to ignore enemy ECM.",
        min_level = 1,
        applied_to = {
            "Missile",
            "Torpedo",
        },
        cost_multiplicative = 0.25,
        size_multiplicative = 0.25,
    },
    enveloping = {
        name = "Enveloping",
        short_name = "ENV",
        description = "Weapon is designed to envelop the target, damaging all four shield quadrants.",
        min_level = 2,
        applied_to = {
            "Beam",
            "Torpedo",
        },
        cost_multiplicative = 1.0,
        size_multiplicative = 1.0,
    },
    fast = {
        name = "Fast",
        short_name = "FST",
        description = "Weapon is fast, allowing it move an additional 8 tiles more per turn, reaching the target faster.",
        min_level = 1,
        applied_to = {
            "Missile",
            "Torpedo",
        },
        cost_multiplicative = 0.25,
        size_multiplicative = 0.25,
    },
    heavy_mount = {
        name = "Heavy Mount",
        short_name = "HM",
        description = "Weapon is mounted on a heavy mount, allowing it to fire at a greater range.",
        min_level = 0,
        applied_to = {
            "Laser",
            "Beam",
            "Torpedo",
            "Missile",
        },
        damage_multiplicative = 1.5,
        cost_multiplicative = 1.0,
        size_multiplicative = 1.0,
        cannot_be_applied_with = {
            "point_defense",
        },
    },
    mirv = {
        name = "Multiple Independently Targetable Reentry Vehicle",
        short_name = "MIRV",
        description = "Weapon is designed to split into 4 full-strength warheads, allowing it to hit multiple targets.",
        min_level = 2,
        applied_to = {
            "Missile",
        },
        cost_multiplicative = 0.5,
        size_multiplicative = 1.0,
    },
    no_range = {
        name = "No Range Dissipation",
        short_name = "NR",
        description = "Weapon has no range, allowing it to be used in close combat.",
        min_level = 1,
        applied_to = {
            "Laser",
            "Beam",
            "Torpedo",
        },
        cost_multiplicative = 0.25,
        size_multiplicative = 0.25,
    },
    overload = {
        name = "Overloaded",
        short_name = "OVR",
        description = "Torpedoes have payloads that exceed the engineering safety limits of their construction.",
        min_level = 2,
        applied_to = {
            "Torpedo",
        },
        damage_multiplicative = 0.5,
        cost_multiplicative = 0.25,
        size_multiplicative = 0.25,
    },
    point_defense = {
        name = "Point Defense",
        short_name = "PD",
        description = "Weapon is designed to intercept incoming missiles and fighter craft.",
        min_level = 0,
        applied_to = {
            "Laser",
            "Beam",
        },
        damage_multiplicative = -0.5,
        accuracy_multiplicative = 0.25,
        range_penalty = 2.0,
        cost_multiplicative = -0.5,
        size_multiplicative = -0.5,
        cannot_be_applied_with = {
            "heavy_mount",
        },
    },
    shield_piercing = {
        name = "Shield Piercing",
        short_name = "SP",
        description = "Weapon is designed to pierce shields, allowing it to hit the target directly.",
        min_level = 1,
        applied_to = {
            "Laser",
            "Beam",
            "Torpedo",
        },
        cost_multiplicative = 0.5,
        size_multiplicative = 0.5,
    }
}

ShipSpecialsDefinitions = {
    no_special = {
        name = "No Special",
        short_name = "None",
        description = "No special abilities.",
    },
    achilles_targeting_unit = {},
    augmented_engines = {},
    automated_repair_unit = {},
    battle_pods = {},
    battle_scanner = {},
    cloaking_device = {},
    damper_field = {},
    displacement_device = {},
    ecm_jammer = {},
    energy_absorber = {},
    extended_fuel_tanks = {},
    fast_missile_racks = {},
    hard_shields = {},
    heavy_armor = {},
    high_energy_focus = {},
    hyper_x_capacitors = {},
    inertial_nullifier = {},
    inertial_stabilizer = {},
    lightning_field = {},
    multi_phased_shields = {},
    multi_wave_ecm_jammer = {},
    phase_shifter = {},
    phasing_cloak = {},
    quantum_detonator = {},
    rangemaster_unit = {},
    reflection_field = {},
    reinforced_hull = {},
    scout_lab = {},
    security_stations = {},
    shield_capacitor = {},
    stealth_field = {},
    structural_analyzer = {},
    sub_space_teleporter = {},
    time_warp_facilitator = {},
    transporters = {},
    troop_pods = {},
    warp_dissipator = {},
    wide_area_jammer = {},
    regeneration = {},
}

ShipComputerDefinitions = {
    no_computer  = {},
    electronic_computer  = {},
    optronic_computer  = {},
    positronic_computer  = {},
    cybertronic_computer  = {},
    moleculartronic_computer  = {},
}