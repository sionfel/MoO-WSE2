
def generate_strings(list):
	y = []
	for i in xrange(len(list)):
		_string = list[i]
		x = [_string.lower(), _string]
		y.append(x)
	return y
	
def generate_system_strings():
	y = []
	for i in xrange(len(system_names)):
		_string = system_names[i]
		x = ["system_name_%03d" % i, _string]
		y.append(x)
	y.append(["system_name_end", "Systems End"])
	return y
	

system_names = [
	"Paranar", "Denubius", "Draconis", "Zoctan", "Rigel", "Talas", "Moro", "Quayal", "Neptunus",
    "Jinga", "Argus", "Escalon", "Berel", "Collassa", "Whynil", "Nordia", "Tau Cygni", "Phyco", "Firma",
    "Keeta", "Arietis", "Rhilus", "Willow", "Mu Delphi", "Stalaz", "Gorra", "Beta Ceti", "Spica", "Omicron",
    "Rha", "Kailis", "Vulcan", "Centauri", "Herculis", "Endoria", "Kulthos", "Hyboria", "Zhardan", "Yarrow",
    "Incedius", "Paladia", "Romulas", "Galos", "Uxmai", "Thrax", "Laan", "Imra", "Selia", "Seidon",
    "Tao", "Rana", "Vox", "Maalor", "Xudax", "Helos", "Crypto", "Gion", "Phantos", "Reticuli",
    "Maretta", "Toranor", "Exis", "Tyr", "Ajax", "Obaca", "Dolz", "Drakka", "Ryoun", "Vega",
    "Anraq", "Gienah", "Rotan", "Proxima", "Mobas", "Iranha", "Celtsi", "Dunatis", "Morrig", "Primodius",
    "Nyarl", "Ukko", "Crius", "Hyades", "Kronos", "Guradas", "Rayden", "Kakata", "Misha", "Xendalla",
    "Artemis", "Aurora", "Proteus", "Esper", "Darrian", "Trax", "Xengara", "Nitzer", "Simius", "Bootis",
    "Pollus", "Cygni", "Aquilae", "Volantis", "Tauri", "Regulus", "Klystron", "Lyae", "Capella", "Alcor"
]

none_system_names = []
radiated_system_names = []
toxic_system_names = []
inferno_system_names = []
dead_system_names = []
tundra_system_names = []
barren_system_names = []
minimal_system_names = []
desert_system_names = []
arid_system_names = []
steppe_system_names = []
ocean_system_names = []
terran_system_names = []

alkari_system_names = ["Altair"]
bulrathi_system_names = ["Ursa"]
darlock_system_names = ["Nazin"]
human_system_names = ["Sol"]
klackon_system_names = ["Kholdan"]
meklar_system_names = ["Meklon"]
mrrshan_system_names = ["Fierias"]
psilon_system_names = ["Mentar"]
sakkra_system_names = ["Sssla"]
silicoid_system_names = ["Cryslon"]
orion_system_names = ["Orion"]
antaran_system_names = ["Antares"]
elerian_system_names = ["Draconis"]
gnolam_system_names = ["Gnol"]
trilarian_system_names = ["Trilar"]
terran_system_names = ["Alpha Ceti"]

# "Humans", "Mrrshans", "Silicoids", "Sakkras", "Psilons", "Alkaris", "Klackons", "Bulrathis", "Meklars", "Darloks"

alkari_ship_names = [ "FOXBAT", "SPARROWHAWK", "PELICAN", "FALCON", "SKY HAWK", "SPACE GULL", "WARBIRD", "WARHAWK", "WAREAGLE", "CONDOR", "DREADWING", "SKY MASTER",]
bulrathi_ship_names = [ "PAW", "PANDA", "PATROL", "HUNTER", "GLADIATOR", "SENTINEL", "CLAW", "TOOTH", "WARBEAR", "GRIZZLY", "PUNISHER", "RHINO",]
darlock_ship_names = ["SPIDER", "BUMBLEBEE", "NEEDLE", "HORNET", "SCORPION", "VENOM", "TARANTULA", "VIPER", "COBRA", "KING COBRA", "BLACK WIDOW", "DEATH WYN"]
human_ship_names = ["FIGHTER", "GUNBOAT", "COURIER", "FRIGATE", "DESTROYER", "CORVETTE", "CRUISER", "ESCORT", "WARSHIP", "DREADNOUGHT", "BATTLESHIP", "DREADSTAR",]
klackon_ship_names = ["SABRE", "CUTLASS", "DAGGER", "LANCER", "PEGASUS", "HORSEMAN", "RANGER", "KNIGHT", "AVENGER", "DRAGOON", "PALADIN", "EXCALIBER",]
meklar_ship_names = ["MARAUDER", "HYPERION", "DRACHMA", "INTRUDER", "PENETRATOR", "TORMENTER", "AJAX", "TORNADO", "NEXUS", "NEMESIS", "DEVASTATOR", "ANNIHILATOR",]
mrrshan_ship_names = ["WOLVERINE", "GRIFFIN", "FERRET", "LYNX", "CHEETAH", "BOBCAT", "PANTHER", "LEOPARD", "WARCAT", "SABRETOOTH", "PUMA", "TIGER", ]
psilon_ship_names = ["STARFIGHTER", "COMET", "SEEKER", "STAR WING", "STAR BLAZER", "STAR STREAK", "STAR BLADE", "DARK STAR", "CORAONA", "SUN FIRE", "STAR FURY", "NOVA",]
sakkra_ship_names = ["GOBLIN", "CYCLOPS", "DAEMON", "BANSHEE", "SPECTRE", "SPIRIT", "JUGGERNAUT", "VALKYRIE", "HYDRA", "TITAN", "COLOSSUS", "DRAGON",]
silicoid_ship_names = ["PIRANHA", "STINGRAY", "MINNOW", "MANTA", "BARRACUDA", "MOREY", "SHARK", "MAKO", "WHALE", "KRAKEN", "MONITOR", "POLARIS",]
orion_ship_names = ["GUARDIAN"]
antaran_ship_names = ["Antares"]
elerian_ship_names = ["Draconis"]
gnolam_ship_names = ["Gnol"]
trilarian_ship_names = ["Trilar"]
terran_ship_names = ["Alpha Ceti"]
