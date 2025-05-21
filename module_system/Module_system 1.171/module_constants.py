from ID_items import *
from ID_quests import *
from ID_factions import *

# #######################################################################
#	constant_id = constant_value
#
#		These constants are used in various files.
#		If you need to define a value that will be used in those files,
#		just define it here rather than copying it across each file, so
#		that it will be easy to change it if you need to.
#
#		for example, declaring example_num = 256 will then make it so
#		when you type example_num in any file with module_constants
#		in the import will make example_num become 256
#
#	The other, much more common use, is slots.
#	slot_id = slot_number
#
#		By using slots you can use operations to store/recieve
#		a value stored in the slot for such things as items, agents
#		factions, quests, parties, etc and so forth.
#
#		Ideally you'll use a different number per slot so as 
#		not to accidentally overwrite previously assigned slots, but 
#		things like items and scenes won't be sharing slot information,
#		so feel free to reset your numbering scheme per category.
#
#		The slots left in are purely for segmentation and categorization
#		efforts are are in no way REQUIRED. They're just to be helpful.
# #######################################################################

# #######################################################################
# 		Item Slots
# #######################################################################

item_slots = 0

# #######################################################################
# 		Agent Slots
# #######################################################################

agent_slots = 0
 
# #######################################################################
# 		Faction Slots
# #######################################################################

faction_slots = 0

slot_faction_trait_array = 1
slot_faction_government = 2


# #######################################################################
# 		Party Slots
# #######################################################################

party_slots = 0

slot_fleet_leader = 1
slot_fleet_moved = 2

slot_system_star_color = 1

# #######################################################################
# 		Scene Slots
# #######################################################################

scene_slots = 0


# #######################################################################
# 		Troop Slots
# #######################################################################

troop_slots = 0

# #######################################################################
# 		Player Slots
# #######################################################################

player_slots = 0

# #######################################################################
# 		Team Slots
# #######################################################################

team_slots = 0

# #######################################################################
# 		Quest Slots
# #######################################################################

quest_slots = 0

# #######################################################################
# 		Party Template Slots
# #######################################################################

party_template_slots = 0

slot_party_template_created = 1

# #######################################################################
# 		Scene Prop Slots
# #######################################################################

scene_prop_slots = 0

# #######################################################################
#		Miscellaneous
# #######################################################################
miscellaneous = 0

# #######################################################################
#		Galaxy Generation
# #######################################################################

# Galaxy Sizes
galaxy_size_small = 0
galaxy_size_medium = 1
galaxy_size_large = 2
galaxy_size_huge = 3

# Star Types
st_red_star = 1
st_green_star = 2
st_yellow_star = 3
st_blue_star = 4
st_white_star = 5
st_neutron_star = 6

# Planet Environment
planet_type_none = 0
planet_type_radiated = 1
planet_type_toxic = 2
planet_type_inferno = 3
planet_type_dead = 4
planet_type_tundra = 5
planet_type_barren = 6
planet_type_minimal = 7
planet_type_desert = 8
planet_type_steppe = 9
planet_type_arid = 10
planet_type_ocean = 11
planet_type_jungle = 12
planet_type_terran = 13
