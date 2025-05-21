-- buildings.lua

PlanetaryStructuresDefinitions = {
    -- Planetary Structures
    -- Used to determine what structures are built on a planet
    -- Each structure has a name and a function that determines if it can be built on the planet
    -- The function takes the planet as an argument and returns true or false
    -- The function is called when the player tries to build the structure on the planet
    -- If the function returns true, the structure is built, otherwise it is not built
    -- id, tech, cost, maintenance, group
    alien_control_center = {
        id = 1,
        tech_id = 5,
        cost = 60,
        maintenance = 1,
        group = 4
    },

    armor_barracks = {
        id = 2,
        tech_id = 14,
        cost = 150,
        maintenance = 2,
        group = 0
    },

    artemis_system_net = {
        id = 3,
        tech_id = 15,
        cost = 1000,
        maintenance = 5,
        group = 7
    },

    astro_university = {
        id = 4,
        tech_id = 18,
        cost = 200,
        maintenance = 4,
        group = 1
    },

    atmosphere_renewer = {
        id = 5,
        tech_id = 19,
        cost = 150,
        maintenance = 3,
        group = 2
    },

    autolab = {
        id = 6,
        tech_id = 21,
        cost = 200,
		maintenance = 3,
		group = 1
	},
 
	automated_factory = {
		id = 7,
		tech_id = 22,
		cost = 60,
		maintenance = 1,
		group = 3
	},

	battlestation = {
		id = 8,
		tech_id = 27,
		cost = 1000,
		maintenance = 3,
		group = 7
	},

	capitol = {
		id = 9,
		tech_id = 32,
		cost = 200,
		maintenance = 0,
		group = 1
	},

	cloning_center = {
        id = 10,
        tech_id = 39,
        cost = 100,
        maintenance = 2,
        group = 0
	},

	colony_base = {
        id = 11,
        tech_id = 40,
        cost = 200,
        maintenance = 0,
        group = 0
	},

	deep_core_mine = {
        id = 12,
        tech_id = 49,
        cost = 250,
        maintenance = 3,
        group = 0
	},

	core_waste_dump = {
        id = 13,
        tech_id = 50,
        cost = 200,
        maintenance = 8,
        group = 0
	},

	dimensional_portal = {
        id = 14,
        tech_id = 52,
        cost = 500,
        maintenance = 2,
        group = 7
	},

	biospheres = {
        id = 15,
        tech_id = 61,
        cost = 60,
        maintenance = 1,
        group = 3
	},

	food_replicators = {
        id = 16,
        tech_id = 68,
        cost = 200,
        maintenance = 10,
        group = 1
	},

	gaia_transformation = {
        id = 17,
        tech_id = 74,
        cost = 500,
        maintenance = 0,
        group = 1
	},

	currency_exchange = {
        id = 18,
        tech_id = 75,
        cost = 250,
        maintenance = 3,
        group = 5
	},

	galactic_cybernet = {
        id = 19,
        tech_id = 76,
        cost = 250,
        maintenance = 3,
        group = 5
	},

	holo_simulator = {
        id = 20,
        tech_id = 86,
        cost = 120,
        maintenance = 1,
        group = 3
	},

	hydroponic_farm = {
        id = 21,
        tech_id = 87,
        cost = 60,
        maintenance = 2,
        group = 0
	},

	marine_barracks = {
        id = 22,
        tech_id = 103,
        cost = 60,
        maintenance = 1,
        group = 0
	},

	barrier_shield = {
        id = 23,
        tech_id = 129,
        cost = 500,
        maintenance = 5,
        group = 2
	},

	flux_shield = {
        id = 24,
        tech_id = 130,
        cost = 200,
        maintenance = 3,
        group = 1
	},

	gravity_generator = {
        id = 25,
        tech_id = 131,
        cost = 120,
        maintenance = 2,
        group = 1
	},

	missile_base = {
        id = 26,
        tech_id = 132,
        cost = 120,
        maintenance = 2,
        group = 2
	},

	ground_batteries = {
        id = 27,
        tech_id = 133,
        cost = 200,
        maintenance = 2,
        group = 2
	},

	radiation_shield = {
        id = 28,
        tech_id = 134,
        cost = 80,
        maintenance = 1,
        group = 0
	},

	stock_exchange = {
        id = 29,
        tech_id = 135,
        cost = 150,
        maintenance = 2,
        group = 1
	},

	supercomputer = {
        id = 30,
        tech_id = 136,
        cost = 150,
        maintenance = 2,
        group = 2
	},

	pleasure_dome = {
        id = 31,
        tech_id = 141,
        cost = 250,
        maintenance = 3,
        group = 0
	},

	pollution_processor = {
        id = 32,
        tech_id = 142,
        cost = 80,
        maintenance = 1,
        group = 0
	},

	recyclotron = {
        id = 33,
        tech_id = 152,
        cost = 200,
        maintenance = 3,
        group = 1
	},

	robotic_factory = {
        id = 34,
        tech_id = 154,
        cost = 200,
        maintenance = 3,
        group = 1
	},

	research_lab = {
        id = 35,
        tech_id = 155,
        cost = 60,
        maintenance = 1,
        group = 0
	},

	robo_miner_plant = {
        id = 36,
        tech_id = 156,
        cost = 150,
        maintenance = 2,
        group = 3
	},

	soil_enrichment = {
        id = 37,
        tech_id = 162,
        cost = 120,
        maintenance = 0,
        group = 0
	},

	space_academy = {
        id = 38,
        tech_id = 163,
        cost = 100,
        maintenance = 2,
        group = 1
	},

	spaceport = {
        id = 39,
        tech_id = 164,
        cost = 80,
        maintenance = 1,
        group = 0
	}, 

	star_base = {
        id = 40,
        tech_id = 168,
        cost = 400,
        maintenance = 2,
        group = 7
	},

	star_fortress = {
        id = 41,
        tech_id = 169,
        cost = 2500,
        maintenance = 4,
        group = 7
	},

	stellar_converter = {
        id = 42,
        tech_id = 174,
        cost = 1000,
        maintenance = 6,
        group = 0
	},

	subterranean_farms = {
        id = 43,
        tech_id = 178,
        cost = 150,
        maintenance = 4,
        group = 0
	},

	terraforming = {
        id = 44,
        tech_id = 183,
        cost = 250,
        maintenance = 0,
        group = 0
	},

	warp_interdictor = {
        id = 45,
        tech_id = 197,
        cost = 300,
        maintenance = 3,
        group = 0
	},

	weather_controller = {
        id = 46,
        tech_id = 198,
        cost = 200,
        maintenance = 3,
        group = 0
	},

	fighter_garrison = {
        id = 47,
        tech_id = 67,
        cost = 150,
        maintenance = 2,
        group = 0
	},

	artificial_planet = {
        id = 48,
        tech_id = 16,
        cost = 800,
        maintenance = 0,
        group = 0
	},
 
}



SystemStructureDefinitions = {
    -- System Structures
    -- Used to determine what structures are built on the system
    -- Each structure has a name and a function that determines if it can be built on the system
    -- The function takes the system as an argument and returns true or false
    -- The function is called when the player tries to build the structure on the system
    -- If the function returns true, the structure is built, otherwise it is not built
}