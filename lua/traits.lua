RacialTraitDefinitions = {
	PopulationGrowthBad = {
		name = "-50% Growth",
		description = "Increased production output",
		type = "population",
		population_growth_bonus = -0.5,
		cost = -4
    },
	
	PopulationGrowthGood = {
		name = "+50% Growth",
		description = "Increased production output",
		type = "population",
		population_growth_bonus = 0.5,
		cost = 3
    },
	
	PopulationGrowthGreat = {
		name = "+100% Growth",
		description = "Increased production output",
		type = "population",
		population_growth_bonus = 1.0,
		cost = 6
    },
	
	FarmingBad = {
		name = "-1/2 Food",
		description = "Each farmer will produce half a unit less of food",
		type = "farming",
		farming_bonus = -0.5,
		cost = -3
    },
	
	FarmingGood = {
		name = "+1 Food",
		description = "Each farmer will produce an additional unit of food",
		type = "farming",
		farming_bonus = 1,
		cost = 4
    },
	
	FarmingGreat = {
		name = "+2 Food",
		description = "Each farmer will produce an additional 2 units of food",
		type = "farming",
		farming_bonus = 2,
		cost = 7
    },

	IndustryBad = {
		name = "-1 Production",
		description = "Each laborer will produce a unit less of production",
		type = "production",
		production_bonus = -1,
		cost = -3
    },
	
	IndustryGood = {
		name = "+1 Production",
		description = "Each laborer will produce an additional unit of production",
		type = "production",
		production_bonus = 1,
		cost = 9
    },
	
	IndustryGreat = {
		name = "+2 Production",
		description = "Each laborer will produce an additional 2 units of production",
		type = "production",
		production_bonus = 2,
		cost = 6
    },
	
	ResearchBad = {
		name = "-1 Research",
		description = "Each scientist will produce one RP unit fewer",
		type = "research",
		research_bonus = -1,
		cost = -3
    },
	
	ResearchGood = {
		name = "+1 Research",
		description = "Each scientist will produce an additional RP unit",
		type = "research",
		research_bonus = 1,
		cost = 3
    },
	
	ResearchGreat = {
		name = "+2 Research",
		description = "Each scientist will produce an additional 2 RP units",
		type = "research",
		research_bonus = 2,
		cost = 6
    },
	
	EconomicBad = {
		name = "-0.5 BC",
		description = "Each unit of population will produce 0.5 BC fewer in taxes",
		type = "monetary",
		economic_bonus = -0.5,
		cost = -4
    },
	
	EconomicGood = {
		name = "+0.5 BC",
		description = "Each unit of population will produce an additional 0.5 BC in taxes",
		type = "monetary",
		economic_bonus = 0.5,
		cost = 5
    },
	
	EconomicGreat = {
		name = "+1 BC",
		description = "Each unit of population will produce an additional +1 BC in taxes",
		type = "monetary",
		economic_bonus = 1,
		cost = 8
    },
	
	ShipDefenseBad = {
		name = "-20",
		description = "Ship Defense decrease by 20, increasing the chance of being hit in ship to ship combat",
		type = "ship_defense",
		ship_defense_bonus = -20,
		cost = -2
    },
	
	ShipDefenseGood = {
		name = "+25",
		description = "Ship Defense increases by 25, decreasing the chance of being hit in ship to ship combat",
		type = "ship_defense",
		ship_defense_bonus = 25,
		cost = 3
    },
	
	ShipDefenseGreat = {
		name = "+50",
		description = "Ship Defense increases by 50, decreasing the chance of being hit in ship to ship combat",
		type = "ship_defense",
		ship_defense_bonus = 50,
		cost = 7
    },
	
	ShipAttackBad = {
		name = "-20",
		description = "Ship Attack decrease by 20, decreasing the chance of scoring a hit in ship to ship combat",
		type = "ship_attack",
		ship_attack_bonus = -20,
		cost = -2
    },
	
	ShipAttackGood = {
		name = "+20",
		description = "Ship Attack increases by 20, increasing the chance of scoring a hit in ship to ship combat",
		type = "ship_attack",
		ship_attack_bonus = 20,
		cost = 2
    },
	
	ShipAttackGreat = {
		name = "+50",
		description = "Ship Attack increases by 50, increasing the chance of scoring a hit in ship to ship combat",
		type = "ship_attack",
		ship_attack_bonus = 50,
		cost = 4
    },
	
	GroundCombatBad = {
		name = "-10",
		description = "Your ground forces score is lessened by 10, affecting their effectiveness in planetary combat and ship boarding actions",
		type = "ground_combat",
		ground_combat_bonus = -10,
		cost = -2
    },
	
	GroundCombatGood = {
		name = "+10",
		description = "Your ground forces score is increased by 10, affecting their effectiveness in planetary combat and ship boarding actions",
		type = "ground_combat",
		ground_combat_bonus = 10,
		cost = 2
    },
	
	GroundCombatGreat = {
		name = "+20",
		description = "Your ground forces score is increased by 20, affecting their effectiveness in planetary combat and ship boarding actions",
		type = "ground_combat",
		ground_combat_bonus = 20,
		cost = 4
    },
	
	SpyingBad = {
		name = "-10",
		description = "Your espionage and sabotage skills are diminished by 10. Offensive spying actions receive the full bonus/penalty, while defensive spies only receive one-half the amount",
		type = "spying",
		spying_bonus = -10,
		cost = -3
    },
	
	SpyingGood = {
		name = "+10",
		description = "Your espionage and sabotage skills are boosted by 10. Offensive spying actions receive the full bonus/penalty, while defensive spies only receive one-half the amount",
		type = "spying",
		spying_bonus = 10,
		cost = 3
    },
	
	SpyingGreat = {
		name = "+20",
		description = "Your espionage and sabotage skills are boosted by 20. Offensive spying actions receive the full bonus/penalty, while defensive spies only receive one-half the amount",
		type = "spying",
		spying_bonus = 20,
		cost = 6
    },
	
	GovernmentFeudal = {
		name = "Feudal",
		description = "Feudal",
		type = "government",
		cost = -4,
		ship_cost_reduction = 1/3,
		research_bonus = -10,
    },
	
	GovernmentDictator = {
		name = "Dictatorship",
		description = "Dictatorship",
		type = "government",
		cost = 0,
    },

	GovernmentDemocracy = {
		name = "Democracy",
		description = "Democracy",
		type = "government",
		cost = 7,
		research_bonus = 10,
		economic_bonus = 10,
    },
	
	GovernmentUnification = {
		name = "Unification",
		description = "Unification",
		type = "government",
		cost = 6,
		farming_bonus = 10,
		production_bonus = 10,
    },

	GovernmentConfederation = {
		name = "Confederation",
		description = "Feudal",
		type = "government_advance",
		cost = -4,
		ship_cost_reduction = 2/3,
		research_bonus = -5,
    },
	
	GovernmentImperium = {
		name = "Imperium",
		description = "Dictatorship",
		type = "government_advance",
		cost = 0
    },

	GovernmentFederation = {
		name = "Federation",
		description = "Democracy",
		type = "government_advance",
		cost = 7,
		research_bonus = 15,
		economic_bonus = 15,
    },
	
	GovernmentGalacticUnification = {
		name = "Galactic Unification",
		description = "Unification",
		type = "government_advance",
		cost = 6,
		farming_bonus = 20,
		production_bonus = 20,
    },
	
	SpecialLowGWorld = {
		name = "Low-G World",
		description = "",
		type = "special",
		ground_combat_bonus = -10,
		cost = -5
    },
	
	SpecialHighGWorld = {
		name = "High-G World",
		description = "",
		type = "special",
		cost = 6
    },
	
	SpecialAquatic = {
		name = "Aquatic",
		description = "",
		type = "special",
		cost = 5
    },
	
	SpecialSubterranean = {
		name = "Subterranean",
		description = "",
		type = "special",
		cost = 6
    },
	
	SpecialLargeHomeWorld = {
		name = "Large Home World",
		description = "",
		type = "special",
		cost = 1
    },
	
	SpecialRichHomeWorld = {
		name = "Rich Home World",
		description = "",
		type = "special",
		cost = 2
    },
	
	SpecialPoorHomeWorld = {
		name = "Poor Home World",
		description = "",
		type = "special",
		cost = -1
    },
	
	SpecialArtifactsWorld = {
		name = "Artifacts World",
		description = "",
		type = "special",
		cost = 3
    },
	
	SpecialCybernetic = {
		name = "Cybernetic",
		description = "",
		type = "special",
		cost = 4
    },
	
	SpecialLithovore = {
		name = "Lithovore",
		description = "",
		type = "special",
		cost = 10
    },
	
	SpecialRepulsive = {
		name = "Repulsive",
		description = "",
		type = "special",
		cost = -6
    },
	
	SpecialCharismatic = {
		name = "Charismatic",
		description = "",
		type = "special",
		cost = 3
    },
	
	SpecialUncreative = {
		name = "Uncreative",
		description = "",
		type = "special",
		cost = -4
    },
	
	SpecialCreative = {
		name = "Creative",
		description = "",
		type = "special",
		cost = 8
    },
	
	SpecialTolerant = {
		name = "Tolerant",
		description = "",
		type = "special",
		cost = 10
    },
	
	SpecialTraders = {
		name = "Fantastic Traders",
		description = "",
		type = "special",
		cost = 4
    },
	
	SpecialTelepathic = {
		name = "Telepathic",
		description = "",
		type = "special",
		cost = 6
    },
	
	SpecialLucky = {
		name = "Lucky",
		description = "",
		type = "special",
		cost = 3
    },
	
	SpecialOmniscient = {
		name = "Omniscient",
		description = "",
		type = "special",
		cost = 3
    },
	
	SpecialStealthyShips = {
		name = "Stealthy Ships",
		description = "",
		type = "special",
		cost = 4
    },
	
	SpecialTransDimensional = {
		name = "Trans Dimensional",
		description = "",
		type = "special",
		cost = 5
    },
	
	SpecialWarlord = {
		name = "Warlord",
		description = "",
		type = "special",
		cost = 4
    },
}

RacialBonusKeys = {
    "population_growth_bonus",
    "farming_bonus",
    "production_bonus",
    "research_bonus",
    "economic_bonus",
    "spying_bonus",
    "ground_combat_bonus",
	"ship_defense_bonus",
	"ship_attack_bonus",
	"ship_cost_reduction",
    -- Add more here as needed
}

SystemTraitsKey = {
	"artifacts",
	"cache",
	"debris",
	"gems",
	"gold",
	"hero",
	"monster",
	"natives",
	"splinter",
	"wormhole"
}
SystemTraitsDefinitions = {
	artifacts = {
		name = "Artifacts",
		type = "planetary",
		description = "",
		research_bonus = 2,
	},
	
	cache = {
		name = "Cache",
		type = "system",
		description = "",
	},
	
	debris = {
		name = "Debris",
		type = "system",
		description = "",
	},

	gems = {
		name = "Gems",
		type = "planetary",
		description = "",
		economic_bonus = 3,
	},

	gold = {
		name = "Gold",
		type = "planetary",
		description = "",
		economic_bonus = 2
	},

	hero = {
		name = "Hero",
		type = "system",
		description = "",
		high_value = true
	},

	monster = {
		name = "Monster",
		type = "system",
		description = "",
	},

	natives = {
		name = "Natives",
		type = "system",
		description = "",
		high_value = true
	},

	splinter = {
		name = "Splinter Colony",
		type = "system",
		description = "",
		high_value = true
	},

	wormhole = {
		name = "Wormhole",
		type = "system",
		description = "",
		high_value = true
	}
}

PlanetTraitsDefinitions = {
	artifacts = {
		name = "Artifacts",
		description = "",
		research_bonus = 2,
	},


}

LeaderTraitsDefinitions = {
	-- Univeral Traits
	assassin = {
		name = "Assassin",
		description = "Has a chance of assassinating an enemy Spy every turn.",
	},
	commando = {
		name = "Commando",
		description_colony = "Increases the combat bonus of defending ground troops.",
		description_ship = "Increases the combat bonuses of ship's marines. Invading troops get 2.5 times this bonus.",
	},
	diplomat = {
		name = "Diplomat",
		description = "Increases the chance of success for diplomatic actions.",
	},
	famous = {
		name = "Famous",
		description = "Increases the chance of success for espionage actions.",
	},
	megawealth = {
		name = "Megawealth",
		description = "Increases the amount of BC gained from taxes.",
	},
	researcher = {
		name = "Researcher",
		description = "Increases the amount of RP gained from research.",
	},
	spymaster = {
		name = "Spymaster",
		description = "Increases the chance of success for espionage actions.",
	},
	tech_knowledge = {
		name = "Tech Knowledge",
		description = "Increases the chance of success for espionage actions.",
	},
	telepath = {
		name = "Telepath",
		description = "Increases the chance of success for espionage actions.",
	},
	trader = {
		name = "Trader",
		description = "Increases the amount of BC gained from trade.",
	},
	-- Colony Leader Traits
	enviromentalist = {
		name = "Enviromentalist",
		description = "Increases the chance of success for diplomatic actions.",
	},
	farming = {
		name = "Farming",
		description = "Increases the amount of food produced by farmers.",
	},
	financial = {
		name = "Financial",
		description = "Increases the amount of BC gained from taxes.",
	},
	instructor = {
		name = "Instructor",
		description = "Increases the chance of success for espionage actions.",
	},
	labor = {
		name = "Labor",
		description = "Increases the amount of production produced by laborers.",
	},
	medicine = {
		name = "Medicine",
		description = "Increases the chance of success for diplomatic actions.",
	},
	science = {
		name = "Science",
		description = "Increases the amount of RP gained from research.",
	},
	spiritual = {
		name = "Spiritual",
		description = "Increases the chance of success for diplomatic actions.",
	},
	tactics = {
		name = "Tactics",
		description = "Increases the chance of success for espionage actions.",
	},
	-- Ship Leader Traits
	engineer = {
		name = "Engineer",
		description = "Increases the chance of success for espionage actions.",
	},
	fighter_pilot = {
		name = "Fighter Pilot",
		description = "Increases the chance of success for espionage actions.",
	},
	galactic_lore = {
		name = "Galactic Lore",
		description = "Increases the chance of success for espionage actions.",
	},
	helmsman = {
		name = "Helmsman",
		description = "Increases the chance of success for espionage actions.",
	},
	navigator = {
		name = "Navigator",
		description = "Increases the chance of success for espionage actions.",
	},
	operations = {
		name = "Operations",
		description = "Provides extra Command Points for your empire.",
	},
	ordinance = {
		name = "Ordinance",
		description = "Increases the chance of success for espionage actions.",
	},
	security = {
		name = "Security",
		description = "Increases the combat strength of a ship's marines when boarded by enemy marines.",
	},
	weaponry = {
		name = "Weaponry",
		description = "Increases the beam attack of all ships in the fleet.",
	},
}

PlanetaryBonusKeys = {
    "population_growth_bonus",
    "farming_bonus",
    "production_bonus",
    "research_bonus",
    "economic_bonus",
    "spying_bonus",
    "ground_combat_bonus",
	"ship_defense_bonus",
	"ship_attack_bonus",
    -- Add more here as needed
}