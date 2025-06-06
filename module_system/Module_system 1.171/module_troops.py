import random
from header_common import *
from header_items import *
from header_troops import *
from header_skills import *
from ID_factions import *
from ID_items import *
from ID_scenes import *


# #######################################################################
#
#	["troop_if", "troop_name", "plural_troop_name", flags, scene, 0, faction, [inventory_list], attributes, weapon_proficiencies, skills, face_code_1, face_code_2, troop_image],
#
#  Each troop contains the following fields:
#  1) Troop id (string): used for referencing troops in other files. The prefix trp_ is automatically added before each troop-id .
#  2) Troop name (string).
#  3) Plural troop name (string).
#  4) Troop flags (int). See header_troops.py for a list of available flags
#  5) Scene (int) (only applicable to heroes) For example: scn_reyvadin_castle|entry(1) puts troop in reyvadin castle's first entry point
#  6) Reserved (int). Put constant "reserved" or 0.
#  7) Faction (int)
#  8) Inventory (list): Must be a list of items
#  9) Attributes (int): Example usage:
#           str_6|agi_6|int_4|cha_5|level(5)
# 10) Weapon proficiencies (int): Example usage:
#           wp_one_handed(55)|wp_two_handed(90)|wp_polearm(36)|wp_archery(80)|wp_crossbow(24)|wp_throwing(45)
#     The function wp(x) will create random weapon proficiencies close to value x.
#     To make an expert archer with other weapon proficiencies close to 60 you can use something like:
#           wp_archery(160) | wp(60)
# 11) Skills (int): See header_skills.py to see a list of skills. Example:
#           knows_ironflesh_3|knows_power_strike_2|knows_athletics_2|knows_riding_2
# 12) Face code (int): You can obtain the face code by pressing ctrl+E in face generator screen
# 13) Face code (int)(2) (only applicable to regular troops, can be omitted for heroes):
#     The game will create random faces between Face code 1 and face code 2 for generated troops
# 14) Troop image (string): If this variable is set, the troop will use an image rather than its 3D visual during the conversations
# #######################################################################

# #######################################################################
#		Function Definitions
# #######################################################################

# #######################################################################
#		Definitions
#	NOTE: This is /not/ hardcoded, but I left it for ease of reading the code.
# #######################################################################

start_attrib = str_4|agi_4|int_4|cha_4

tf_guarantee_all = tf_guarantee_boots|tf_guarantee_armor|tf_guarantee_gloves|tf_guarantee_helmet|tf_guarantee_horse|tf_guarantee_shield|tf_guarantee_ranged

	# #######################################################################
	#	Troops
	# #######################################################################
troops = [

    # #######################################################################
    #	Hardcoded
	# #######################################################################

	["player", "Player", "Player", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["multiplayer_profile_troop_male", "multiplayer_profile_troop_male", "multiplayer_profile_troop_male", tf_hero|tf_guarantee_all, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["multiplayer_profile_troop_female", "multiplayer_profile_troop_female", "multiplayer_profile_troop_female", tf_hero|tf_female|tf_guarantee_all, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["temp_troop", "Temp Troop", "Temp Troop", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
    
	# #######################################################################
	#	You get free rein from here!
	#		Have fun!
	# #######################################################################
	
	# Faction Leaders
	["alkari_leader", "Sharpclaw", "Skylord Sharpclaw", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["bulrathi_leader", "Krungo", "Emperor Krungo", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["darlock_leader", "Darquan", "Hindmost Darquan", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["human_leader", "Strader", "President Strader", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["klackon_leader", "Kikitik", "Queen Kikitik", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["meklar_leader", "INT-986", "Overseer INT-986", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["mrrshan_leader", "Yalara", "Empress Yalara", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["psilon_leader", "Quark", "Controller Quark", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["sakkra_leader", "Saurak", "Hierarch Saurak", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["silicoid_leader", "Geode", "Keystone Geode", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["orion_leader", "Loknar", "Preserver Loknar", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["antaran_leader", "Xyphys", "Herald Xyphys", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["elerian_leader", "Berylia", "Grand Marshal Berylia", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["gnolam_leader", "Bortis", "Commodore Bortis", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["trilarian_leader", "Wavya", "Stinger Wavya", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	["terran_leader", "Khoan", "Khoan", tf_hero|tf_unmoveable_in_party_window, 0, 0, fac_commoners, [], start_attrib, 0, 0, 0, 0],
	
	# Colony Leaders
	["colony_leader_01", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_02", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_03", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_04", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_05", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_06", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_07", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_08", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_09", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_10", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_11", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_12", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_13", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_14", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_15", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_16", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_17", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_18", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_19", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_20", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_21", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_22", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_23", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_24", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_25", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_26", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_27", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_28", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_29", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_30", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_31", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_32", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_33", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_34", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_35", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["colony_leader_36", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	
	# Ship Leaders
	["ship_leader_01", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_02", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_03", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_04", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_05", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_06", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_07", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_08", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_09", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_10", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_11", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_12", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_13", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_14", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_15", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_16", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_17", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_18", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_19", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_20", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_21", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_22", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_23", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_24", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_25", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_26", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_27", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_28", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_29", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_30", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_31", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_32", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_33", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_34", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_35", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
	["ship_leader_36", "name", "name", 0, 0, 0, fac_commoners, [], 0, 0, 0, 0, 0],
]

# #######################################################################
#	Troop Tree Definitions
#		Pretty easy, for a troop that can only go one way:
#			upgrade(base_troop_id, upgraded_troop_id),
#		For a branching path:
#			upgrade(base_troop_id, upgraded_troop_id_1. upgraded_troop_id_2),
# #######################################################################