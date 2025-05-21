--[[
    research.lua
]]

Research = Class(nil, "Research")

function Research:init(name, category)
    self.category = category
    self.name = name
    self.tier = 0
    self.cost = 0
end

StartingFields = {
    prewarp = {},
    average = {},
    postwarp = {},
    advanced = {}
}

ResearchTierCost = {
    50, 80, 150, 250, 400, 650, 900, 1150, 1500, 2000, 2750, 3500, 4500,
    6000, 7500, 10000, 15000
}

function calculate_research_cost(research)
    local tier = research.tier
    local cost = 0
    if tier > #ResearchTierCost then
        cost = tier - #ResearchTierCost * 10000
        tier = #ResearchTierCost
    end
    cost = cost + ResearchTierCost[tier]
end

function get_next_tier(field)
    local tier
    local field_object
    local field_string
    local cost

    if type(field) == "string" then
        for k, v in pairs(ResearchCategories) do
            if v == field then
                field_object = ResearchFieldKeys[k]
                field_string = field
                break
            end
        end
    elseif type(field) == "number" then
        if field <= #ResearchFieldKeys and field >= 1 then
            field_object = ResearchFieldKeys[field]
            field_string = ResearchCategories[field]
        else
            error("No field has id" .. field)
        end
    end

    if field_object then
        
    else
        error("No field found for" .. field)
    end

    if tier then
        return tier, cost
    else
        
    end
end

ResearchCategories = {
    "biology",
    "chemistry",
    "construction",
    "computers",
    "physics",
    "power",
    "sociology",
    "force_fields",
    "xenon",
}

ResearchFieldKeys = {
    "BiologyFields",
    "ChemistryFields",
    "ConstructionFields",
    "ComputerFields",
    "PhysicsFields",
    "PowerFields",
    "SociologyFields",
    "ForceFieldFields",
    "XenonFields"
}

ApplicationTypes = {
    "achivement",
    "satellite",
    "building",
    "android",
    "equipment",
    "ship",
    "system",
    "hyper_advanced"
}

BiologyFields = {
    [1] = {skip = true},
    [2] = {
        name = "Astro Biology",
        technologies = {"hydroponic_farm", "biospheres"},
    },
    [3] = {skip = true},
    [4] = {skip = true},
    [5] = {
        name = "Advanced Biology",
        technologies = {"cloning_center", "soil_enrichment", "death_spores"},
    },
    [6] = {skip = true},
    [7] = {
        name = "Genetic Engineering",
        technologies = {"telepathic_training", "microbiotics"},
    },
    [8] = {
        name = "Genetic Mutation",
        technologies = {"terraforming"},
    },
    [9] = {
        name = "Macro Genetics",
        technologies = {"subterranean_farms", "weather_control_system"},
    },
    [10] = {skip = true},
    [11] = {
        name = "Evolutionary Genetics",
        technologies = {"psionics", "heightened_intelligence"},
    },
    [12] = {skip = true},
    [13] = {
        name = "Artificial Life",
        technologies = {"bio_terminator", "universal_antidote"},
    },
    [14] = {skip = true},
    [15] = {
        name = "Trans Genetics",
        technologies = {"biomorphic_fungi", "gaia_transformation", "evolutionary_mutation"},
    },
    [16] = {skip = true},
    [17] = {skip = true},
    [18] = {
        name = "Hyper-Advanced Biology",
        technologies = {"adv_biology"},
        repeating = true,
    },

}
ChemistryFields = {
    [1] = {
        name = "Chemistry",
        technologies = {"nuclear_missile", "standard_fuel_cells", "extended_fuel_tanks", "titanium_armor"},
        unlocks_all = true,
    },
    [2] = {skip = true},
    [3] = {skip = true},
    [4] = {
        name = "Advanced Metallurgy",
        technologies = {"deuterium_fuel_cells", "tritanium_armor"},
    },
    [5] = {skip = true},
    [6] = {
        name = "Advanced Chemistry",
        technologies = {"merculite_missile", "pollution_processor"},
    },
    [7] = {skip = true},
    [8] = {
        name = "Molecular Compression",
        technologies = {"pulson_missile", "atmospheric_renewer", "iridium_fuel_cells"},
    },
    [9] = {skip = true},
    [10] = {
        name = "Nano Technology",
        technologies = {"nano_disassemblers", "microlite_construction", "zortrium_armor"},
    },
    [11] = {skip = true},
    [12] = {skip = true},
    [13] = {
        name = "Molecular Manipulation",
        technologies = {"zeon_missile", "neutronium_armor", "uridium_fuel_cells"},
    },
    [14] = {skip = true},
    [15] = {skip = true},
    [16] = {
        name = "Molecular Control",
        technologies = {"thorium_fuel_cells", "adamantium_armor"},
    },
    [17] = {skip = true},
    [18] = {
        name = "Hyper-Advanced Chemistry",
        technologies = {"adv_chemistry"},
        repeating = true,
    },
}
ConstructionFields = {
    [1] = {
        name = "Engineering",
        technologies = {"colony_base", "star_base", "marine_barracks"},
        unlocks_all = true,
    },
    [2] = {
        name = "Advanced Engineering",
        technologies = {"anti_missile_rocket", "fighter_bays", "reinforced_hull"},
    },
    [3] = {
        name = "Advanced Construction",
        technologies = {"automated_factories", "planetary_missile_base", "heavy_armor"},
    },
    [4] = {
        name = "Capsule Construction",
        technologies = {"battle_pods", "troop_pods", "survival_pods"},
    },
    [5] = {
        name = "Astro Engineering",
        technologies = {"spaceport", "armor_barracks", "fighter_garrison"},
    },
    [6] = {
        name = "Robotics",
        technologies = {"robo_miners", "battlestation", "powered_armor"},
    },
    [7] = {
        name = "Servo Manufacturing",
        technologies = {"fast_missile_racks", "advanced_damage_control", "assault_shuttles"},
    },
    [8] = {
        name = "Astro Construction",
        technologies = {"titan_construction", "ground_batteries", "battleoids"},
    },
    [9] = {
        name = "Advanced Manufacturing",
        technologies = {"recyclotron", "automated_repair_unit", "artificial_planet"},
    },
    [10] = {
        name = "Advanced Robotics",
        technologies = {"robotic_factory", "bomber_bays"},
    },
    [11] = {skip = true},
    [12] = {
        name = "Tectonic Engineering",
        technologies = {"deep_core_mining", "core_waste_dumps"},
    },
    [13] = {skip = true},
    [14] = {
        name = "Superscalar Construction",
        technologies = {"star_fortress", "advanced_city_planning", "heavy_fighter_bays"},
    },
    [15] = {
        name = "Planetoid Construction",
        technologies = {"doom_star_construction", "artemis_system_net"},
    },
    [16] = {skip = true},
    [17] = {skip = true},
    [18] = {
        name = "Hyper-Advanced Engineering",
        technologies = "adv_construction",
        repeating = true,
    },

}
ComputerFields = {
    [1] = {
        name = "Electronics",
        technologies = {"electronic_computer"},
    },
    [2] = {skip = true},
    [3] = {
        name = "Optronics",
        technologies = {"research_laboratory", "optronic_computer", "dauntless_guidance_system"},
    },
    [4] = {skip = true},
    [5] = {
        name = "Artifical Intelligence",
        technologies = {"neural_scanner", "scout_lab", "security_stations"},
    },
    [6] = {skip = true},
    [7] = {
        name = "Positronics",
        technologies = {"positronic_computer", "planetary_supercomputer", "holo_simulator"},
    },
    [8] = {skip = true},
    [9] = {
        name = "Artificial Conciousness",
        technologies = {"emissions_guidance_system", "rangemaster_unit", "cyber_security_link"},
    },
    [10] = {skip = true},
    [11] = {
        name = "Cybertronics",
        technologies = {"cybertronic_computer", "autolab", "structural_analyzer"},
    },
    [12] = {
        name = "Cybertechnics",
        technologies = {"android_farmers", "android_workers", "android_scientists"},
    },
    [13] = {
        name = "Galactic Networking",
        technologies = {"virtual_reality_network", "galactic_cybernet"},
    },
    [14] = {
        name = "Moleculartronics",
        technologies = {"pleasure_dome", "moleculartronic_computer", "achilles_targeting_unit"},
    },
    [15] = {skip = true},
    [16] = {skip = true},
    [17] = {skip = true},
    [18] = {
        name = "Hyper-Advanced Computers",
        technologies = {"adv_computers"},
        repeating = true,
    },

}
PhysicsFields = {
    [1] = {
        name = "Physics",
        technologies = {"laser_cannon", "laser_rifle", "space_scanner"},
        unlocks_all = true,
    },
    [2] = {skip = true},
    [3] = {
        name = "Fusion Physics",
        technologies = {"fusion_beam", "fusion_rifle"},
    },
    [4] = {
        name = "Tachyon Physics",
        technologies = {"tachyon_communications", "tachyon_scanner", "battle_scanner"},
    },
    [5] = {skip = true},
    [6] = {skip = true},
    [7] = {
        name = "Neutrino Physics",
        technologies = {"neutron_blaster", "neutron_scanner"},
    },
    [8] = {
        name = "Artificial Gravity",
        technologies = {"tractor_beam", "graviton_beam", "planetary_gravity_generator"},
    },
    [9] = {
        name = "Sub-space Physics",
        technologies = {"sub_space_communications", "jump_gate"},
    },
    [10] = {
        name = "Multi-phased Physics",
        technologies = {"phasor", "phasor_rifle", "multi_phased_shields"},
    },
    [11] = {skip = true},
    [12] = {
        name = "Plasma Physics",
        technologies = {"plasma_cannon", "plasma_rifle", "plasma_web"},
    },
    [13] = {
        name = "Multidimensional Physics",
        technologies = {"disrupter_cannon", "dimensional_portal"},
    },
    [14] = {
        name = "Hyperdimensional Physics",
        technologies = {"hyperspace_communications", "sensors", "mauler_device"},
    },
    [15] = {skip = true},
    [16] = {skip = true},
    [17] = {
        name = "Temporal Physics",
        technologies = {"time_warp_facilitator", "stellar_converter", "star_gate"},
    },
    [18] = {
        name = "Hyper-Advanced Physics",
        technologies = {"adv_physics"},
        repeating = true
    },

}
PowerFields = {
    [1] = {
        name = "Nuclear Fission",
        technologies = {"nuclear_drive", "nuclear_bomb"},
        unlocks_all = true,
    },
    [2] = {
        name = "Nuclear Fission",
        technologies = {"colony_ship", "freighters", "outpost_ship", "transport"},
        unlocks_all = true,
    },
    [3] = {skip = true},
    [4] = {
        name = "Advanced Fusion",
        technologies = {"fusion_drive", "fusion_bomb", "augmented_engines"},
    },
    [5] = {skip = true},
    [6] = {skip = true},
    [7] = {
        name = "Ion Fission",
        technologies = {"ion_drive", "ion_pulse_cannon", "shield_capacitors"},
    },
    [8] = {skip = true},
    [9] = {skip = true},
    [10] = {
        name = "Anti-Matter Fission",
        technologies = {"anti_matter_drive", "anti_matter_torpedo", "anti_matter_bomb"},
    },
    [11] = {
        name = "Matter-Energy Conversion",
        technologies = {"transporters", "food_replicators"},
    },
    [12] = {
        name = "High Energy Distribution",
        technologies = {"high_energy_focus", "energy_absorber"},
    },
    [13] = {
        name = "Hyper-Dimensional Fission",
        technologies = {"proton_torpedo", "hyper_drive", "hyper_x_capacitors"},
    },
    [14] = {skip = true},
    [15] = {skip = true},
    [16] = {
        name = "Interphased Fission",
        technologies = {"interphased_drive", "plasma_torpedo", "neutronium_bomb"},
    },
    [17] = {skip = true},
    [18] = {
        name = "Hyper-Advanced Power",
        technologies = {},
        repeating = true,
    },

}
SociologyFields = {
    [1] = {skip = true},
    [2] = {skip = true},
    [3] = {
        name = "Military Tactics",
        technologies = {"space_academy"}
    },
    [4] = {skip = true},
    [5] = {skip = true},
    [6] = {
        name = "Xeno Relations",
        technologies = {"xeno_psychology", "alien_management_center"}
    },
    [7] = {skip = true},
    [8] = {
        name = "Macro Economics",
        technologies = {"planetary_stock_exchange"}
    },
    [9] = {skip = true},
    [10] = {
        name = "Teaching Methods",
        technologies = "astro_university"
    },
    [11] = {skip = true},
    [12] = {skip = true},
    [13] = {
        name = "Advanced Government",
        technologies = {"confederation", "imperium", "federation", "galactic_unification"}
    },
    [14] = {
        name = "Galactic Economics",
        technologies = {"galactic_currency_exchange"}
    },
    [15] = {skip = true},
    [16] = {skip = true},
    [17] = {skip = true},
    [18] = {
        name = "Hyper-Advanced Sociology",
        technologies = "adv_sociology",
        repeating = true
    },

}
ForceFieldFields = {
    [1] = { skip = true},
    [2] = {skip = true},
    [3] = {skip = true},
    [4] = {
        name = "",
        technologies = {},
    },
    [5] = {skip = true},
    [6] = {
        name = "",
        technologies = {},
    },
    [7] = {
        name = "",
        technologies = {},
    },
    [8] = {skip = true},
    [9] = {
        name = "",
        technologies = {},
    },
    [10] = {
        name = "",
        technologies = {},
    },
    [11] = {
        name = "",
        technologies = {},
    },
    [12] = {
        name = "",
        technologies = {},
    },
    [13] = {
        name = "",
        technologies = {},
    },
    [14] = {skip = true},
    [15] = {
        name = "",
        technologies = {},
    },
    [16] = {skip = true},
    [17] = {
        name = "",
        technologies = {},
        
    },
    [18] = {
        name = "",
        technologies = {},
        repeating = true
    },

}
XenonFields = {
    [1] = {skip = true},
    [2] = {skip = true},
    [3] = {skip = true},
    [4] = {skip = true},
    [5] = {skip = true},
    [6] = {skip = true},
    [7] = {skip = true},
    [8] = {skip = true},
    [9] = {skip = true},
    [10] = {skip = true},
    [11] = {skip = true},
    [12] = {skip = true},
    [13] = {skip = true},
    [14] = {skip = true},
    [15] = {skip = true},
    [16] = {skip = true},
    [17] = {
        name = "Xenon Technology",
        technologies = {"death_ray", "particle_beam", "black_hole_generator", "spatial_compressor", "damper_field", "xentronium_armor", "quantum_detonator", "reflection_field"}
    },
    [18] = {},

}

Technologies = {
    ["achilles_targeting_unit"] = {},
    ["adamantium_armor"] = {},
    ["advanced_city_planning"] = {},
    ["advanced_damage_control"] = {},
    ["alien_management_center"] = {},
    ["android_farmers"] = {},
    ["android_scientists"] = {},
    ["android_workers"] = {},
    ["anti_grav_harness"] = {},
    ["anti_matter_bomb"] = {},
    ["anti_matter_drive"] = {},
    ["anti_matter_torpedo"] = {},
    ["anti_missile_rocket"] = {},
    ["armor_barracks"] = {},
    ["artemis_system_net"] = {},
    ["planet_construction"] = {},
    ["assault_shuttles"] = {},
    ["astro_university"] = {},
    ["atmospheric_renewer"] = {},
    ["augmented_engines"] = {},
    ["autolab"] = {},
    ["automated_factories"] = {},
    ["automated_repair_unit"] = {},
    ["battleoids"] = {},
    ["battle_pods"] = {},
    ["battle_scanner"] = {},
    ["battlestation"] = {},
    ["bio_terminator"] = {},
    ["biomorphic_fungi"] = {},
    ["black_hole_generator"] = {},
    ["bomber_bays"] = {},
    ["capitol"] = {},
    ["class_i_shield"] = {},
    ["class_iii_shield"] = {},
    ["class_v_shield"] = {},
    ["class_vii_shield"] = {},
    ["class_x_shield"] = {},
    ["cloaking_device"] = {},
    ["cloning_center"] = {},
    ["colony_base"] = {},
    ["colony_ship"] = {},
    ["confederation"] = {},
    ["cyber_security_link"] = {},
    ["cybertronic_computer"] = {},
    ["damper_field"] = {},
    ["dauntless_guidance_system"] = {},
    ["death_ray"] = {},
    ["death_spores"] = {},
    ["deep_core_mining"] = {},
    ["core_waste_dumps"] = {},
    ["deuterium_fuel_cells"] = {},
    ["dimensional_portal"] = {},
    ["displacement_device"] = {},
    ["disrupter_cannon"] = {},
    ["doom_star_construction"] = {},
    ["reinforced_hull"] = {},
    ["ecm_jammer"] = {},
    ["electronic_computer"] = {},
    ["emissions_guidance_system"] = {},
    ["energy_absorber"] = {},
    ["biospheres"] = {},
    ["evolutionary_mutation"] = {},
    ["extended_fuel_tanks"] = {},
    ["fast_missile_racks"] = {},
    ["federation"] = {},
    ["fighter_bays"] = {},
    ["fighter_garrison"] = {},
    ["food_replicators"] = {},
    ["freighters"] = {},
    ["fusion_beam"] = {},
    ["fusion_bomb"] = {},
    ["fusion_drive"] = {},
    ["fusion_rifle"] = {},
    ["gaia_transformation"] = {},
    ["galactic_currency_exchange"] = {},
    ["galactic_cybernet"] = {},
    ["galactic_unification"] = {},
    ["gauss_cannon"] = {},
    ["graviton_beam"] = {},
    ["gyro_destabilizer"] = {},
    ["hard_shields"] = {},
    ["heavy_armor"] = {},
    ["heavy_fighter_bays"] = {},
    ["heightened_intelligence"] = {},
    ["high_energy_focus"] = {},
    ["holo_simulator"] = {},
    ["hydroponic_farm"] = {},
    ["hyper_drive"] = {},
    ["megafluxers"] = {},
    ["hyper_x_capacitors"] = {},
    ["hyperspace_communications"] = {},
    ["imperium"] = {},
    ["inertial_nullifier"] = {},
    ["inertial_stabilizer"] = {},
    ["interphased_drive"] = {},
    ["ion_drive"] = {},
    ["ion_pulse_cannon"] = {},
    ["iridium_fuel_cells"] = {},
    ["jump_gate"] = {},
    ["laser_cannon"] = {},
    ["laser_rifle"] = {},
    ["lightning_field"] = {},
    ["marine_barracks"] = {},
    ["mass_driver"] = {},
    ["mauler_device"] = {},
    ["merculite_missile"] = {},
    ["microbiotics"] = {},
    ["microlite_construction"] = {},
    ["outpost_ship"] = {},
    ["moleculartronic_computer"] = {},
    ["multi_wave_ecm_jammer"] = {},
    ["multi_phased_shields"] = {},
    ["nano_disassemblers"] = {},
    ["neural_scanner"] = {},
    ["neutron_blaster"] = {},
    ["neutron_scanner"] = {},
    ["neutronium_armor"] = {},
    ["neutronium_bomb"] = {},
    ["nuclear_bomb"] = {},
    ["nuclear_drive"] = {},
    ["nuclear_missile"] = {},
    ["optronic_computer"] = {},
    ["particle_beam"] = {},
    ["personal_shield"] = {},
    ["phase_shifter"] = {},
    ["phasing_cloak"] = {},
    ["phasor"] = {},
    ["phasor_rifle"] = {},
    ["planetary_barrier_shield"] = {},
    ["planetary_flux_shield"] = {},
    ["planetary_gravity_generator"] = {},
    ["planetary_missile_base"] = {},
    ["ground_batteries"] = {},
    ["lanetary_radiation_shield"] = {},
    ["planetary_stock_exchange"] = {},
    ["planetary_supercomputer"] = {},
    ["plasma_cannon"] = {},
    ["plasma_rifle"] = {},
    ["plasma_torpedo"] = {},
    ["plasma_web"] = {},
    ["pleasure_dome"] = {},
    ["pollution_processor"] = {},
    ["positronic_computer"] = {},
    ["powered_armor"] = {},
    ["pulse_rifle"] = {},
    ["proton_torpedo"] = {},
    ["psionics"] = {},
    ["pulsar"] = {},
    ["pulson_missile"] = {},
    ["quantum_detonator"] = {},
    ["rangemaster_unit"] = {},
    ["recyclotron"] = {},
    ["reflection_field"] = {},
    ["robotic_factory"] = {},
    ["research_laboratory"] = {},
    ["robo_miners"] = {},
    ["space_scanner"] = {},
    ["scout_lab"] = {},
    ["security_stations"] = {},
    ["sensors"] = {},
    ["shield_capacitors"] = {},
    ["soil_enrichment"] = {},
    ["space_academy"] = {},
    ["spaceport"] = {},
    ["spatial_compressor"] = {},
    ["spy_network"] = {},
    ["standard_fuel_cells"] = {},
    ["star_base"] = {},
    ["star_fortress"] = {},
    ["star_gate"] = {},
    ["stasis_field"] = {},
    ["stealth_field"] = {},
    ["stealth_suit"] = {},
    ["stellar_converter"] = {},
    ["structural_analyzer"] = {},
    ["sub_space_communications"] = {},
    ["sub_space_teleporter"] = {},
    ["subterranean_farms"] = {},
    ["survival_pods"] = {},
    ["tachyon_communications"] = {},
    ["tachyon_scanner"] = {},
    ["telepathic_training"] = {},
    ["terraforming"] = {},
    ["thorium_fuel_cells"] = {},
    ["time_warp_facilitator"] = {},
    ["titan_construction"] = {},
    ["titanium_armor"] = {},
    ["tractor_beam"] = {},
    ["transport"] = {},
    ["transporters"] = {},
    ["tritanium_armor"] = {},
    ["troop_pods"] = {},
    ["universal_antidote"] = {},
    ["uridium_fuel_cells"] = {},
    ["virtual_reality_network"] = {},
    ["warp_dissipator"] = {},
    ["warp_interdictor"] = {},
    ["weather_control_system"] = {},
    ["wide_area_jammer"] = {},
    ["xeno_psychology"] = {},
    ["xentronium_armor"] = {},
    ["zeon_missile"] = {},
    ["zortrium_armor"] = {},
    ["adv_biology"] = {},
    ["adv_power"] = {},
    ["adv_physics"] = {},
    ["adv_construction"] = {},
    ["adv_fields"] = {},
    ["adv_chemistry"] = {},
    ["adv_computers"] = {},
    ["adv_sociology"] = {},
}