from header_game_menus import *
from header_parties import *
from header_items import *
from header_mission_templates import *
from header_music import *
from header_terrain_types import *
from module_constants import *

# #######################################################################
#  ("menu_id", flags, "menu_text", "mesh_name", [<operations>], [<options>]),
#
#   Each game menu is a tuple that contains the following fields:
#  
#  1) Game-menu id (string): used for referencing game-menus in other files.
#     The prefix menu_ is automatically added before each game-menu-id
#
#  2) Game-menu flags (int). See header_game_menus.py for a list of available flags.
#     You can also specify menu text color here, with the menu_text_color macro
#  3) Game-menu text (string).
#  4) mesh-name (string). Not currently used. Must be the string "none"
#  5) Operations block (list). A list of operations. See header_operations.py for reference.
#     The operations block is executed when the game menu is activated.
#  6) List of Menu options (List).
#     Each menu-option record is a tuple containing the following fields:
#   6.1) Menu-option-id (string) used for referencing game-menus in other files.
#        The prefix mno_ is automatically added before each menu-option.
#   6.2) Conditions block (list). This must be a valid operation block. See header_operations.py for reference. 
#        The conditions are executed for each menu option to decide whether the option will be shown to the player or not.
#   6.3) Menu-option text (string).
#   6.4) Consequences block (list). This must be a valid operation block. See header_operations.py for reference. 
#        The consequences are executed for the menu option that has been selected by the player.
#
#
# Note: The first Menu is the initial character creation menu.
# #######################################################################

# #######################################################################
#	I also found no reference to which menu items were hardcoded 
#	in the Native file, so I can't tell you if these are ~truly~ hardcoded 
#	or if they are just referenced somewhere else that got overlooked.
#
#		TODO:
#			Syntax Cleanup
#			Figure out how the start game menus actually work.
#				They seem hardcoded to be called in a certain order and
#				force interaction with hardcoded presentations.			
#
#		If I were to gamble, I think the only things required will 
#		be things that have a gamekey attached to them. 
# #######################################################################



game_menus = [

    # #######################################################################
	#	These are required to stay in this order
	# #######################################################################
    ("start_game_0", menu_text_color(0xFF000000)|mnf_disable_all_keys,
    "Start Game 0",
    "none",
    [],
    [		
		("start_phase_1", [], "Go to Start Phase 2",
		[
		    (jump_to_menu, "mnu_start_phase_2"),
			(start_presentation, "prsnt_game_creation"),
			(str_store_string, s1, "@Create Your Character"),
		]),

        ("go_back", [], "Go back",
        [
            (change_screen_quit),
        ]),
    ]),
	
	("start_phase_2", mnf_disable_all_keys,
	"Start Phase 2",
	"none",
	[],
	[
	    ("create_character", [(eq, "$g_leader_created", 0),], "Create Your Leader",
		[
			
		    (change_screen_return, 0),
			(troop_set_skill_points, "trp_player", 0),
			(troop_set_attribute_points, "trp_player", 0),
			(troop_set_proficiency_points, "trp_player", 0),
			(str_store_string, s1, "@Go to World Map"),
		]),
		
		("map", [(eq, "$g_leader_created", 1),], "Go to World Map",
		[
			# (call_script, "script_generate_galaxy", galaxy_size_huge),
			(lua_set_top, 0),
			(lua_call, "@UniverseGeneration"),
			(lua_set_top, 0),
		    (change_screen_return, 0),
		]),
		
		("go_back", [(eq, "$g_leader_created", 0),], "Go back",
        [
            (jump_to_menu, "mnu_start_game_0"),
        ]),
	]),
	
	("start_game_3", mnf_disable_all_keys,
	"Start Game 3",
	"none",
	[],
	[
		("return", [], "Return",
		[
		    (change_screen_quit),
		]),
	]),
	
	("tutorial", mnf_disable_all_keys,
	"Tutorial",
	"none",
	[],
	[
	    ("return", [], "Return",
		[
		    (change_screen_quit),
		]),
	]),

    ("reports", 0,
    "Planets",
    "none",
    [],
    [
        ("resume_travelling", [], "Resume traveling.",
        [
		    (change_screen_return),
        ]),
    ]),

    ("camp", mnf_disable_all_keys,
    "Camp",
    "none",
    [],
    [
        ("camp_wait_here", [], "Rest.",
        [
            (rest_for_hours_interactive, 24 * 365, 5, 1),
            (change_screen_return),
        ]),
		
        ("resume_travelling", [], "Dismantle camp.",
        [
            (change_screen_return),
        ]),
    ]),
	
	# #######################################################################
	#	Now is your time to shine!
	# #######################################################################
	
 ]
