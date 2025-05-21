from header_factions import *

# #######################################################################
# ("faction_id", "faction_name_string", faction_flags_usually_0, faction_coherence, [(other_faction, relations_num)], [ranks], color_hex),
#
#  Each faction record contains the following fields:
#  1) Faction id: used for referencing factions in other files.
#     The prefix fac_ is automatically added before each faction id.
#  2) Faction name.
#  3) Faction flags. See header_factions.py for a list of available flags
#  4) Faction coherence. Relation between members of this faction.
#		Values range between 0.0 and 1.0.
#  5) Relations. This is a list of relation records.
#     Each relation record is a tuple that contains the following fields:
#    5.1) Faction. Which other faction this relation is referring to
#    5.2) Value: Relation value between the two factions.
#         Values range between -1 and 1.
#  6) Ranks
#  7) Faction color (default is gray)
# #######################################################################

# #######################################################################		
#	I have never, ever seen Ranks used, I have no idea what it does.
#	I believe it's depreciated from earlier iterations.
# #######################################################################

def custom_race(seed):
	x = ["custom_race_%02d" % seed, "Custom Race %02d" % seed, 0, 0.9, [], []]
	return x
	
def independent_race(seed):
	x = ["independent_race_%02d" % seed, "Independent Race %02d" % seed, 0, 0.9, [], []]
	return x

factions = [
    
	# #######################################################################
	# 		These Three are Hardcoded
	# #######################################################################

	("no_faction", "No Faction", 0, 0.9, [], []),
	("commoners", "Unsettled", 0, 0.1, [], []),
	("outlaws", "Outlaws", max_player_rating(-30), 0.5, [("commoners",-0.6)], [], 0x888888),
	
	# #######################################################################
	#		Add new factions after here
	# #######################################################################
	
	# MoO 1 Races
	("alkari", "Alkari", 0, 0.9, [], []),
	("bulrathi", "Bulrathi", 0, 0.9, [], []),
	("darlock", "Darlock", 0, 0.9, [], []),
	("human", "Human", 0, 0.9, [], []),
	("klackon", "Klackon", 0, 0.9, [], []),
	("meklar", "Meklar", 0, 0.9, [], []),
	("mrrshan", "Mrrshan", 0, 0.9, [], []),
	("psilon", "Psilon", 0, 0.9, [], []),
	("sakkra", "Sakkra", 0, 0.9, [], []),
	("silicoid", "Silicoid", 0, 0.9, [], []),
	("orion", "Orion", 0, 0.9, [], []),
	
	# MoO 2 Races
	("antaran", "Antaran", 0, 0.9, [], []),
	("elerian", "Elerian", 0, 0.9, [], []),
	("gnolam", "Gnolam", 0, 0.9, [], []),
	("trilarian", "Trilarian", 0, 0.9, [], []),
	
	# MoO 4 (Not doing the ones from 3, lol)
	("terran", "Terran", 0, 0.9, [], []),
	
	("custom", "Custom Faction", 0, 0.9, [], []),
]
factions.extend(custom_race(i) for i in xrange(10))
factions.extend(independent_race(i) for i in xrange(10))
