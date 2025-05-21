from header_common import *
from header_operations import *
from module_constants import *
from module_constants import *
from header_parties import *
from header_skills import *
from header_mission_templates import *
from header_items import *
from header_triggers import *
from header_terrain_types import *
from header_music import *
from ID_animations import *

# #######################################################################
# scripts is a list of script records.
# Each script record contains the following two fields:
# 1) Script id: The prefix "script_" will be inserted when referencing scripts.
# 2) Operation block: This must be a valid operation block. See header_operations.py for reference.
# #######################################################################

# #######################################################################
#		(script_id, [operation_block]),
#	Pretty simple stuff. It's also pretty standard practice for the person making the code to do something like
#			#script_script_id:
# 			#This is a description of the script
# 			#INPUT:
#			#	Param 1: 
#			#	Param 2:
#			#OUTPUT: 
#			#	What the output would be.
# #######################################################################

# #######################################################################
#		I've left a few things intact that aren't strictly harcoded,
#		mostly because I don't have the time to build a mod to test to
#		see what they may break. And by that I mean tableau scripts.
# #######################################################################

scripts = [	
	
	# #######################################################################
	# 	Engine Scripts, the engine will look for these on load 
	#	so they you need them to prevent errors but they are not required 
	#	to stay in this order or to actually function.
	# #######################################################################

	#script_game_start:
	# This script is called by the engine when a new game is started
	# INPUT: none
	# OUTPUT: none
	("game_start",
	[
		(get_time, ":time", 1),			# Store UNIX Time
		(set_random_seed, ":time"),		# Using the UNIX time as the random seed
		(mtsrand, ":time"),				# Using the UNIX time as the random seed
		(mtrand, ":rand", 1, 10001),	# This is the ID for this run, for generating dictionaries
		(assign, reg2, ":rand"),
		(assign, "$g_save_id", ":rand"),
		(assign, "$g_random_seed", ":time"),
				
		# (dict_create, ":dictionary"),
		# (dict_set_str, ":dictionary", "@test_dialog", "@Hello!"),
		# (dict_save_json, ":dictionary", "@test_dictionary_{reg2}"),
		
		# (shell_open_url, "@https://discord.gg/RP9ZUUp"),
	]),

	#script_game_quick_start
	# This script is called from the game engine for initializing the global variables 
	# for tutorial, multiplayer and custom battle modes. Similar to game_start without 
	# the stuff for map and diplomacy things
	# INPUT: none
	# OUTPUT: none
	("game_quick_start",
	[
	]),

	#script_game_set_multiplayer_mission_end
	# This script is called from the game engine when a multiplayer map is ended in clients (not in server).
	# INPUT: none
	# OUTPUT: none
	("game_set_multiplayer_mission_end",
	[
		(assign, "$g_multiplayer_mission_end_screen", 1),
	]),
	
	#script_game_get_use_string
	# This script is called from the game engine for getting using information text
	# INPUT: used_scene_prop_id
	# OUTPUT: s0
	("game_get_use_string",
	[
	]),
	
	#script_game_enable_cheat_menu
	# This script is called from the game engine when user enters "cheatmenu from command console (ctrl+~).
	# INPUT:
	# none
	# OUTPUT:
	# none
	("game_enable_cheat_menu",
	[
	]),

	# script_game_event_party_encounter:
	# This script is called from the game engine whenever player party encounters another party or a battle on the world map
	# INPUT:
	# param1: encountered_party
	# param2: second encountered_party (if this was a battle
	("game_event_party_encounter",
	[
		# This script is left intact as I don't have parties to test what would happen if it were empty
		(store_script_param_1, "$g_encountered_party"),
		(store_script_param_2, "$g_encountered_party_2"), # Negative if non-battle

		(try_begin),
			(lt, "$g_encountered_party_2", 0), # non-battle
			(try_begin),
				(eq, "$g_encountered_party", "p_camp_bandits"), # camp
				(jump_to_menu, "mnu_camp"),
				# (start_presentation, "prsnt_choose_race"),
				(display_message, "@Viewing my colonies!"),
			(else_try),
				(display_message, "@Hi!"),
			(try_end),
		(else_try),
			(display_message, "@Hi 2!"),
		(try_end),
		
		# (change_screen_map),
	]),

	#script_game_event_simulate_battle:
	# This script is called whenever the game simulates the battle between two parties on the map.
	# INPUT:
	# param1: Defender Party
	# param2: Attacker Party
	("game_event_simulate_battle",
	[
	]),

	#script_game_event_battle_end:
	# This script is called whenever the game ends the battle between two parties on the map.
	# INPUT:
	# param1: Defender Party
	# param2: Attacker Party
	("game_event_battle_end",
	[
	]), 

	#script_game_get_item_buy_price_factor:
	# This script is called from the game engine for calculating the buying price of any item.
	# INPUT:
	# param1: item_kind_id
	# OUTPUT:
	# trigger_result and reg0 = price_factor
	("game_get_item_buy_price_factor",
	[
	]),

	#script_game_get_item_sell_price_factor:
	# This script is called from the game engine for calculating the selling price of any item.
	# INPUT:
	# param1: item_kind_id
	# OUTPUT:
	# trigger_result and reg0 = price_factor
	("game_get_item_sell_price_factor",
	[
	]),

	#script_game_event_buy_item:
	# This script is called from the game engine when player buys an item.
	# INPUT:
	# param1: item_kind_id
	("game_event_buy_item",
	[
	]),

	#script_game_event_sell_item:
	# This script is called from the game engine when player sells an item.
	# INPUT:
	# param1: item_kind_id
	("game_event_sell_item",
	[
	]),	

	# script_game_get_troop_wage
	# This script is called from the game engine for calculating troop wages.
	# Input:
	# param1: troop_id, param2: party-id
	# Output: reg0: weekly wage
	("game_get_troop_wage",
	[
	]),

	# script_game_get_total_wage
	# This script is called from the game engine for calculating total wage of the player party which is shown at the party window.
	# Input: none
	# Output: reg0: weekly wage
	("game_get_total_wage",
	[
	]),

	# script_game_get_join_cost
	# This script is called from the game engine for calculating troop join cost.
	# Input:
	# param1: troop_id,
	# Output: reg0: weekly wage
	("game_get_join_cost",
	[
	]),

	# script_game_get_upgrade_xp
	# This script is called from game engine for calculating needed troop upgrade exp
	# Input:
	# param1: troop_id,
	# Output: reg0 = needed exp for upgrade 
	("game_get_upgrade_xp",
	[
	]),

	# script_game_get_upgrade_cost
	# This script is called from game engine for calculating needed troop upgrade exp
	# Input:
	# param1: troop_id,
	# Output: reg0 = needed cost for upgrade
	("game_get_upgrade_cost",
	[
	]),

	# script_game_get_prisoner_price
	# This script is called from the game engine for calculating prisoner price
	# Input:
	# param1: troop_id,
	# Output: reg0
	("game_get_prisoner_price",
	[
	]),


	# script_game_check_prisoner_can_be_sold
	# This script is called from the game engine for checking if a given troop can be sold.
	# Input: 
	# param1: troop_id,
	# Output: reg0: 1= can be sold; 0= cannot be sold.
	("game_check_prisoner_can_be_sold",
	[
	]),

	# script_game_get_morale_of_troops_from_faction
	# This script is called from the game engine 
	# Input: 
	# param1: faction_no,
	# Output: reg0: extra morale x 100
	("game_get_morale_of_troops_from_faction",
	[
	]),

	#script_game_event_detect_party:
	# This script is called from the game engine when player party inspects another party.
	# INPUT:
	# param1: Party-id
	("game_event_detect_party",
	[
	]),

	#script_game_event_undetect_party:
	# This script is called from the game engine when player party inspects another party.
	# INPUT:
	# param1: Party-id
	("game_event_undetect_party",
	[
	]),

	#script_game_get_statistics_line:
	# This script is called from the game engine when statistics page is opened.
	# INPUT:
	# param1: line_no
	("game_get_statistics_line",
	[
	]),

	#script_game_get_date_text:
	# This script is called from the game engine when the date needs to be displayed.
	# INPUT: arg1 = number of days passed since the beginning of the game
	# OUTPUT: result string = date
	("game_get_date_text",
	[
	]),

	#script_game_get_money_text:
	# This script is called from the game engine when an amount of money needs to be displayed.
	# INPUT: arg1 = amount in units
	# OUTPUT: result string = money in text
	("game_get_money_text",
	[
		(store_script_param_1, reg1),
		(str_store_string, s1, "str_reg1_credit"),
		(set_result_string, s1),
	]),

	#script_game_get_party_companion_limit:
	# This script is called from the game engine when the companion limit is needed for a party.
	# INPUT: arg1 = none
	# OUTPUT: reg0 = companion_limit
	("game_get_party_companion_limit",
	[
	]),


	#script_game_reset_player_party_name:
	# This script is called from the game engine when the player name is changed.
	# INPUT: none
	# OUTPUT: none
	("game_reset_player_party_name",
	[
	]),

	#script_game_get_troop_note
	# This script is called from the game engine when the notes of a troop is needed.
	# INPUT: arg1 = troop_no, arg2 = note_index
	# OUTPUT: s0 = note
	("game_get_troop_note",
	[
	]),

	#script_game_get_center_note
	# This script is called from the game engine when the notes of a center is needed.
	# INPUT: arg1 = center_no, arg2 = note_index
	# OUTPUT: s0 = note
	("game_get_center_note",
	[
	]),

	#script_game_get_faction_note
	# This script is called from the game engine when the notes of a faction is needed.
	# INPUT: arg1 = faction_no, arg2 = note_index
	# OUTPUT: s0 = note
	("game_get_faction_note",
	[
	]),

	#script_game_get_quest_note
	# This script is called from the game engine when the notes of a quest is needed.
	# INPUT: arg1 = quest_no, arg2 = note_index
	# OUTPUT: s0 = note
	("game_get_quest_note",
	[
	]),

	#script_game_get_info_page_note
	# This script is called from the game engine when the notes of a info_page is needed.
	# INPUT: arg1 = info_page_no, arg2 = note_index
	# OUTPUT: s0 = note
	("game_get_info_page_note",
	[
	]),

	#script_game_get_scene_name
	# This script is called from the game engine when a name for the scene is needed.
	# INPUT: arg1 = scene_no
	# OUTPUT: s0 = name
	("game_get_scene_name",
	[
	]),

	#script_game_get_mission_template_name
	# This script is called from the game engine when a name for the mission template is needed.
	# INPUT: arg1 = mission_template_no
	# OUTPUT: s0 = name
	("game_get_mission_template_name",
	[
	]),

	#script_game_receive_url_response
	# response format should be like this:
	# [a number or a string]|[another number or a string]|[yet another number or a string] ...
	# here is an example response:
	# 12|Player|100|another string|142|323542|34454|yet another string
	# INPUT: arg1 = num_integers, arg2 = num_strings
	# reg0, reg1, reg2, ... up to 128 registers contain the integer values
	# s0, s1, s2, ... up to 128 strings contain the string values
	("game_receive_url_response",
	[
	]),
	#script_game_get_cheat_mode
	# dstn speculation for this whole entry: 
	# Assuming this script determines whether or not cheat mode on the ctrl+~ 
	# command line has been activated.
	# INPUT: NONE
	# OUTPUT: reg0 = cheatmenu_status, 0 for inactive, 1 for active. I assume. 
	("game_get_cheat_mode",
	[
	]),

	#script_game_receive_network_message
	# This script is called from the game engine when a new network message is received.
	# INPUT: arg1 = player_no, arg2 = event_type, arg3 = value, arg4 = value_2, arg5 = value_3, arg6 = value_4
	("game_receive_network_message",
	[
	]),

	#script_game_get_multiplayer_server_option_for_mission_template
	# Input: arg1 = mission_template_id, arg2 = option_index
	# Output: trigger_result = 1 for option available, 0 for not available
	# reg0 = option_value
	("game_get_multiplayer_server_option_for_mission_template",
	[
	]),

	#script_game_multiplayer_server_option_for_mission_template_to_string
	# Input: arg1 = mission_template_id, arg2 = option_index, arg3 = option_value
	# Output: s0 = option_text
	("game_multiplayer_server_option_for_mission_template_to_string",
	[
	]),

	#script_game_multiplayer_event_duel_offered
	# Input: arg1 = agent_no
	# Output: none
	("game_multiplayer_event_duel_offered",
	[
	]),
		 
	#script_game_get_multiplayer_game_type_enum
	# Input: none
	# Output: reg0:first type, reg1:type count
	("game_get_multiplayer_game_type_enum",
	[
	]),

	#script_game_multiplayer_get_game_type_mission_template
	# Input: arg1 = game_type
	# Output: mission_template 
	("game_multiplayer_get_game_type_mission_template",
	[
	]),

	#script_game_get_party_prisoner_limit
	# This script is called from the game engine when the prisoner limit is needed for a party.
	# INPUT: arg1 = party_no
	# OUTPUT: reg0 = prisoner_limit
	("game_get_party_prisoner_limit",
	[
	]),

	#script_game_get_item_extra_text:
	# This script is called from the game engine when an item's properties are displayed.
	# INPUT: arg1 = item_no, arg2 = extra_text_id (this can be between 0-7 (7 included)), arg3 = item_modifier
	# OUTPUT: result_string = item extra text, trigger_result = text color (0 for default)
	("game_get_item_extra_text",
	[
	]),

	#script_game_on_disembark:
	# This script is called from the game engine when the player reaches the shore with a ship.
	# INPUT: pos0 = disembark position
	# OUTPUT: none
	("game_on_disembark",
	[
	]),


	#script_game_context_menu_get_buttons:
	# This script is called from the game engine when the player clicks the right mouse button over a party on the map.
	# INPUT: arg1 = party_no
	# OUTPUT: none, fills the menu buttons
	("game_context_menu_get_buttons",
	[
	]),

	#script_game_event_context_menu_button_clicked:
	# This script is called from the game engine when the player clicks on a button at the right mouse menu.
	# INPUT: arg1 = party_no, arg2 = button_value
	# OUTPUT: none
	("game_event_context_menu_button_clicked",
	[
	]),

	#script_game_get_skill_modifier_for_troop
	# This script is called from the game engine when a skill's modifiers are needed
	# INPUT: arg1 = troop_no, arg2 = skill_no
	# OUTPUT: trigger_result = modifier_value
	("game_get_skill_modifier_for_troop",
	[
	]),

	#script_game_check_party_sees_party
	# This script is called from the game engine when a party is inside the range of another party
	# INPUT: arg1 = party_no_seer, arg2 = party_no_seen
	# OUTPUT: trigger_result = true or false (1 = true, 0 = false)
	("game_check_party_sees_party",
	[
		(store_script_param, ":seer", 1),
		(store_script_param, ":seen", 2),
		
		(try_begin),
			(eq, ":seen", "p_main_party"),
			
			(set_trigger_result, 0),
		(else_try),
			(set_trigger_result, 1),
		(try_end)
	]),

	#script_game_get_party_speed_multiplier
	# This script is called from the game engine when a skill's modifiers are needed
	# INPUT: arg1 = party_no
	# OUTPUT: trigger_result = multiplier (scaled by 100, meaning that giving 100 as the trigger result does not change the party speed)
	("game_get_party_speed_multiplier",
	[
		(set_trigger_result, 100),
	]),

	#script_game_get_console_command
	# This script is called from the game engine when a console command is entered from the dedicated server.
	# INPUT: anything
	# OUTPUT: s0 = result text
	("game_get_console_command",
	[
	]),
	
	# script_game_missile_launch
	# Input: arg1 = shooter_agent_id, arg2 = agent_weapon_item_id, 
	# arg3 = missile_weapon_id, arg4 = missile_item_id
	# pos1 = weapon_item_position
	# Output: none 
	("game_missile_launch",
	[
	]),
	
	#script_game_missile_dives_into_water
	# Called each time a missile dives into water
	# INPUT
	# script param 1 = missile item no
	# script param 2 = launcher item no
	# script param 3 = shooter agent no
	# script param 4 = missile item modifier
	# script param 5 = launcher item modifier
	# script param 6 = missile no
	# pos1 = water impact position and rotation
	("game_missile_dives_into_water", [
		# (store_script_param, ":missile_item_no", 1),
		# (store_script_param, ":launcher_item_no", 2),
		# (store_script_param, ":shooter_agent_no", 3),
		# (store_script_param, ":missile_item_modifier", 4),
		# (store_script_param, ":launcher_item_modifier", 5),
		# (store_script_param, ":missile_no", 6),
	]),
	
	#script_game_troop_upgrades_button_clicked
	# This script is called from the game engine when the player clicks on said button from the party screen
	# INPUT: arg1 = troop_id
	("game_troop_upgrades_button_clicked",
	[
	]),
	
	#script_game_troop_upgrades_button_clicked
	# This script is called from the game engine when the player clicks the character button or presses the
	# relevant gamekey default is 'c'
	("game_character_screen_requested",
	[
		(try_begin),
			(display_message, "@Races Presentation should open"),
		(try_end),
	
		(set_trigger_result, 1),
		
	]),
	
	
	#script_wse_multiplayer_message_received
	# Called each time a composite multiplayer message is received
	# INPUT
	# script param 1 = sender player no
	# script param 2 = event no
	("wse_multiplayer_message_received", [
		# (store_script_param, ":player_no", 1),
		# (store_script_param, ":event_no", 2),
	]),

	#script_wse_game_saved
	# Called each time after game is saved successfully
	("wse_game_saved", [
		# (store_script_param, ":savegame_no", 1),
	]),

	#script_wse_savegame_loaded
	# Called each time after savegame is loaded successfully
	("wse_savegame_loaded", [
		# (store_script_param, ":savegame_no", 1),
	]),

	#script_wse_chat_message_received
	# Called each time a chat message is received (both for servers and clients)
	# INPUT
	# script param 1 = sender player no
	# script param 2 = chat type (0 = global, 1 = team)
	# s0 = message
	# OUTPUT
	# trigger result = anything non-zero suppresses default chat behavior. Server will not even broadcast messages to clients.
	# result string = changes message text for default chat behavior (if not suppressed).
	("wse_chat_message_received", [
		# (store_script_param, ":player_no", 1),
		# (store_script_param, ":chat_type", 2),
	]),

	#script_wse_console_command_received
	# Called each time a command is typed on the dedicated server console or received with RCON (after parsing standard commands)
	# INPUT
	# script param 1 = command type (0 - local, 1 - remote)
	# script param 2 = num parts if bAutoSplitModuleConsoleCommands enabled
	# s0 = text
	# OUTPUT
	# trigger result = anything non-zero if the command succeeded
	# result string = message to display on success (if empty, default message will be used)
	("wse_console_command_received", [
		# (store_script_param, ":command_type", 1),
		# (store_script_param, ":num_parts", 2),
		
		# (store_script_param, ":command_type", 1),
		
	]),

	#script_wse_get_agent_scale
	# Called each time an agent is created
	# INPUT
	# script param 1 = troop no
	# script param 2 = horse item no
	# script param 3 = horse item modifier
	# script param 4 = player no
	# OUTPUT
	# trigger result = agent scale (fixed point)
	("wse_get_agent_scale", [
		# (store_script_param, ":troop_no", 1),
		# (store_script_param, ":horse_item_no", 2),
		# (store_script_param, ":horse_item_modifier", 3),
		# (store_script_param, ":player_no", 4),
	]),

	#script_wse_window_opened
	# Called each time a window (party/inventory/character) is opened
	# INPUT
	# script param 1 = window no
	# script param 2 = window param 1
	# script param 3 = window param 2
	# OUTPUT
	# trigger result = presentation that replaces the window (if not set or negative, window will open normally)
	("wse_window_opened", [
		(store_script_param, ":window_no", 1),
		# (store_script_param, ":window_param_1", 2),
		# (store_script_param, ":window_param_2", 3),
		
		(assign, ":presentation", 0),
		(try_begin),
			(eq, ":window_no", window_inventory),
			# Leaders
		(else_try),
			(eq, ":window_no", window_party),
			# Info
		(else_try),
			(eq, ":window_no", window_character),
			# Picked Up earlier, do not worry
			(assign, ":presentation", -1),
			(assign, "$g_leader_created", 1),
		(try_end),
		
		(set_trigger_result, ":presentation"),
	]),
	
	#script_wse_get_server_info
	# Called each time a http request for server info received (http://server_ip:server_port/)
	# OUTPUT
	# trigger result = anything non-zero replace message text for response info 
	# result string =  message text for response info 
	("wse_get_server_info", [
	]),

	#script_wse_initial_window_start
	# Called each time after initial window started with bMainMenuScene=true (requires WSE2)
	("wse_initial_window_start", [
	]),

	
# #######################################################################
# 	Tableau Scripts! I could probably  have removed these outright, 
# 	but I think I'll leave them in.	Mostly because I know nothing 
# 	about tableau and I don't feel confident that I could erase the 
# 	few left in the code. I did remove the retirement tableau!				
# #######################################################################
	
	#script_add_troop_to_cur_tableau
	# INPUT: troop_no
	# OUTPUT: none
	("add_troop_to_cur_tableau",
	[
		(store_script_param, ":troop_no",1),

		(set_fixed_point_multiplier, 100),
		(assign, ":banner_mesh", -1),

		(cur_tableau_clear_override_items),
		 
		(cur_tableau_set_override_flags, af_override_head|af_override_weapons),
		 
		(init_position, pos2),
		(cur_tableau_set_camera_parameters, 1, 6, 6, 10, 10000),

		(init_position, pos5),
		(assign, ":eye_height", 162),
		(store_mul, ":camera_distance", ":troop_no", 87323),
		(assign, ":camera_distance", 139),
		(store_mul, ":camera_yaw", ":troop_no", 124337),
		(val_mod, ":camera_yaw", 50),
		(val_add, ":camera_yaw", -25),
		(store_mul, ":camera_pitch", ":troop_no", 98123),
		(val_mod, ":camera_pitch", 20),
		(val_add, ":camera_pitch", -14),
		(assign, ":animation", "anim_stand_man"),

		(position_set_z, pos5, ":eye_height"),

		# camera looks towards -z axis
		(position_rotate_x, pos5, -90),
		(position_rotate_z, pos5, 180),

		# now apply yaw and pitch
		(position_rotate_y, pos5, ":camera_yaw"),
		(position_rotate_x, pos5, ":camera_pitch"),
		(position_move_z, pos5, ":camera_distance", 0),
		(position_move_x, pos5, 5, 0),

		(try_begin),
			(ge, ":banner_mesh", 0),

			(init_position, pos1),
			(position_set_z, pos1, -1500),
			(position_set_x, pos1, 265),
			(position_set_y, pos1, 400),
			(position_transform_position_to_parent, pos3, pos5, pos1),
			(cur_tableau_add_mesh, ":banner_mesh", pos3, 400, 0),
		(try_end),
		
		(cur_tableau_add_troop, ":troop_no", pos2, ":animation" , 0),

		(cur_tableau_set_camera_position, pos5),

		(copy_position, pos8, pos5),
		(position_rotate_x, pos8, -90), #y axis aligned with camera now. z is up
		(position_rotate_z, pos8, 30), 
		(position_rotate_x, pos8, -60), 
		(cur_tableau_add_sun_light, pos8, 175,150,125),
	]),

	#script_add_troop_to_cur_tableau_for_character
	# INPUT: troop_no
	# OUTPUT: none
	("add_troop_to_cur_tableau_for_character",
	[
		(store_script_param, ":troop_no",1),

		(set_fixed_point_multiplier, 100),

		(cur_tableau_clear_override_items),
		(cur_tableau_set_override_flags, af_override_fullhelm),

		 
		(init_position, pos2),
		(cur_tableau_set_camera_parameters, 1, 4, 8, 10, 10000),

		(init_position, pos5),
		(assign, ":cam_height", 150),

		(assign, ":camera_distance", 360),
		(assign, ":camera_yaw", -15),
		(assign, ":camera_pitch", -18),
		(assign, ":animation", anim_stand_man),
		 
		(position_set_z, pos5, ":cam_height"),

		# camera looks towards -z axis
		(position_rotate_x, pos5, -90),
		(position_rotate_z, pos5, 180),

		# now apply yaw and pitch
		(position_rotate_y, pos5, ":camera_yaw"),
		(position_rotate_x, pos5, ":camera_pitch"),
		(position_move_z, pos5, ":camera_distance", 0),
		(position_move_x, pos5, 5, 0),

		(try_begin),
			(troop_is_hero, ":troop_no"),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", -1),
		(else_try),
			(store_mul, ":random_seed", ":troop_no", 126233),
			(val_mod, ":random_seed", 1000),
			(val_add, ":random_seed", 1),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", ":random_seed"),
		(try_end),

		(cur_tableau_set_camera_position, pos5),

		(copy_position, pos8, pos5),
		(position_rotate_x, pos8, -90), #y axis aligned with camera now. z is up
		(position_rotate_z, pos8, 30), 
		(position_rotate_x, pos8, -60), 
		(cur_tableau_add_sun_light, pos8, 175,150,125),
	]),

	#script_add_troop_to_cur_tableau_for_inventory
	# INPUT: troop_no
	# OUTPUT: none
	("add_troop_to_cur_tableau_for_inventory",
	[
		(store_script_param, ":troop_no",1),
		(store_mod, ":side", ":troop_no", 4), #side flag is inside troop_no value
		(val_div, ":troop_no", 4), #removing the flag bit
		(val_mul, ":side", 90), #to degrees

		(set_fixed_point_multiplier, 100),

		(cur_tableau_clear_override_items),
		 
		(init_position, pos2),
		(position_rotate_z, pos2, ":side"),
		(cur_tableau_set_camera_parameters, 1, 4, 6, 10, 10000),

		(init_position, pos5),
		(assign, ":cam_height", 105),

		(assign, ":camera_distance", 380),
		(assign, ":camera_yaw", -15),
		(assign, ":camera_pitch", -18),
		(assign, ":animation", anim_stand_man),
		 
		(position_set_z, pos5, ":cam_height"),

		# camera looks towards -z axis
		(position_rotate_x, pos5, -90),
		(position_rotate_z, pos5, 180),

		# now apply yaw and pitch
		(position_rotate_y, pos5, ":camera_yaw"),
		(position_rotate_x, pos5, ":camera_pitch"),
		(position_move_z, pos5, ":camera_distance", 0),
		(position_move_x, pos5, 5, 0),

		(try_begin),
			(troop_is_hero, ":troop_no"),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", -1),
		(else_try),
			(store_mul, ":random_seed", ":troop_no", 126233),
			(val_mod, ":random_seed", 1000),
			(val_add, ":random_seed", 1),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", ":random_seed"),
		(try_end),

		(cur_tableau_set_camera_position, pos5),

		(copy_position, pos8, pos5),
		(position_rotate_x, pos8, -90), #y axis aligned with camera now. z is up
		(position_rotate_z, pos8, 30), 
		(position_rotate_x, pos8, -60), 
		(cur_tableau_add_sun_light, pos8, 175,150,125),
	]),

	#script_add_troop_to_cur_tableau_for_profile
	# INPUT: troop_no
	# OUTPUT: none
	("add_troop_to_cur_tableau_for_profile",
	[
		(store_script_param, ":troop_no",1),

		(set_fixed_point_multiplier, 100),

		(cur_tableau_clear_override_items),
		 
		(cur_tableau_set_camera_parameters, 1, 4, 6, 10, 10000),

		(init_position, pos5),
		(assign, ":cam_height", 105),

		(assign, ":camera_distance", 380),
		(assign, ":camera_yaw", -15),
		(assign, ":camera_pitch", -18),
		(assign, ":animation", anim_stand_man),
		 
		(position_set_z, pos5, ":cam_height"),

		# camera looks towards -z axis
		(position_rotate_x, pos5, -90),
		(position_rotate_z, pos5, 180),

		# now apply yaw and pitch
		(position_rotate_y, pos5, ":camera_yaw"),
		(position_rotate_x, pos5, ":camera_pitch"),
		(position_move_z, pos5, ":camera_distance", 0),
		(position_move_x, pos5, 5, 0),

		(init_position, pos2),
		(try_begin),
			(troop_is_hero, ":troop_no"),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", -1),
		(else_try),
			(store_mul, ":random_seed", ":troop_no", 126233),
			(val_mod, ":random_seed", 1000),
			(val_add, ":random_seed", 1),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", ":random_seed"),
		(try_end),

		(cur_tableau_set_camera_position, pos5),

		(copy_position, pos8, pos5),
		(position_rotate_x, pos8, -90), #y axis aligned with camera now. z is up
		(position_rotate_z, pos8, 30), 
		(position_rotate_x, pos8, -60), 
		(cur_tableau_add_sun_light, pos8, 175,150,125),
	]),

	#script_add_troop_to_cur_tableau_for_party
	# INPUT: troop_no
	# OUTPUT: none
	("add_troop_to_cur_tableau_for_party",
	[
		(store_script_param, ":troop_no",1),
		(store_mod, ":hide_weapons", ":troop_no", 2), #hide_weapons flag is inside troop_no value
		(val_div, ":troop_no", 2), #removing the flag bit

		(set_fixed_point_multiplier, 100),

		(cur_tableau_clear_override_items),
		(try_begin),
		(eq, ":hide_weapons", 1),
		(cur_tableau_set_override_flags, af_override_fullhelm|af_override_head|af_override_weapons),
		(try_end),
		 
		(init_position, pos2),
		(cur_tableau_set_camera_parameters, 1, 6, 6, 10, 10000),

		(init_position, pos5),
		(assign, ":cam_height", 105),

		(assign, ":camera_distance", 450),
		(assign, ":camera_yaw", 15),
		(assign, ":camera_pitch", -18),
		(assign, ":animation", anim_stand_man),
		 
		(troop_get_inventory_slot, ":horse_item", ":troop_no", ek_horse),
		(try_begin),
			(gt, ":horse_item", 0),
			(eq, ":hide_weapons", 0),
			(cur_tableau_add_horse, ":horse_item", pos2, "anim_horse_stand", 0),
			(assign, ":animation", "anim_ride_0"),
			(assign, ":camera_yaw", 23),
			(assign, ":cam_height", 150),
			(assign, ":camera_distance", 550),
		(try_end),
		(position_set_z, pos5, ":cam_height"),

		# camera looks towards -z axis
		(position_rotate_x, pos5, -90),
		(position_rotate_z, pos5, 180),

		# now apply yaw and pitch
		(position_rotate_y, pos5, ":camera_yaw"),
		(position_rotate_x, pos5, ":camera_pitch"),
		(position_move_z, pos5, ":camera_distance", 0),
		(position_move_x, pos5, 5, 0),

		(try_begin),
			(troop_is_hero, ":troop_no"),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", -1),
		(else_try),
			(store_mul, ":random_seed", ":troop_no", 126233),
			(val_mod, ":random_seed", 1000),
			(val_add, ":random_seed", 1),
			(cur_tableau_add_troop, ":troop_no", pos2, ":animation", ":random_seed"),
		(try_end),

		(cur_tableau_set_camera_position, pos5),

		(copy_position, pos8, pos5),
		(position_rotate_x, pos8, -90), #y axis aligned with camera now. z is up
		(position_rotate_z, pos8, 30), 
		(position_rotate_x, pos8, -60), 
		(cur_tableau_add_sun_light, pos8, 175,150,125),
	]),
	 
	# #######################################################################
	# #	Add your scripts here!
	# #						Go hog wild!
	# #######################################################################
	
	#script_generate_galaxy
	# This script is used during map generation to determine the number of stars in a galaxy, 
	# as well as their relative distance as well as place the nebula blobs
	# INPUT: galaxy_size
	# OUTPUT: none
	("generate_galaxy", [
		(store_script_param, ":size", 1),
		
		# galaxy_size_small = 0
		# galaxy_size_medium = 1
		# galaxy_size_large = 2
		# galaxy_size_huge = 3
		
		(assign, ":total_stars", 24),
		(assign, ":nebula_min", 0),
		(assign, ":nebula_max", 1),
		
		(try_begin),
			(gt, ":size", galaxy_size_small),
			(val_add, ":total_stars", 24),
			(val_add, ":nebula_min", 1),
			(val_add, ":nebula_max", 1),
			(gt, ":size", galaxy_size_medium),
			(val_add, ":total_stars", 22),
			(val_add, ":nebula_min", 1),
			(val_add, ":nebula_max", 1),
			(gt, ":size", galaxy_size_large),
			(val_add, ":total_stars", 38),
			(val_add, ":nebula_max", 1),
		(try_end),
		
		(mtrand, ":nebula_count", ":nebula_min", ":nebula_max"),
		
		(try_begin),
			(try_for_range, reg1, 0, ":nebula_count"),
				# Store a random position on the map, spawn a clump of nebula party templates
				(map_get_land_position_around_position, pos2, pos1, 10000),
				(spawn_around_party, 0, "pt_nebula"),
				(party_set_position, reg0, pos2),
			(try_end),
		(try_end),
		
		(assign, ":id", 1),
		(try_for_range, ":name", "str_system_name_000", "str_system_name_end"),
			(troop_set_slot, "trp_temp_troop", ":id", ":name"),
			(val_add, ":id", 1),
			(troop_set_slot, "trp_temp_troop", 0, ":id"),
		(try_end),
		
		(try_for_range, reg1, 0, ":total_stars"),
			# Store a random position on the map, spawn a system party template
			(map_get_land_position_around_position, pos2, pos1, 10000),
			(spawn_around_party, 0, "pt_system"),
			(party_set_position, reg0, pos2),
			
			(party_set_flags, reg0, pf_is_static, 1),
			(party_set_flags, reg0, pf_hide_defenders, 1),
			(party_set_flags, reg0, pf_no_label, 1),
			# (party_set_flags, reg0, pf_show_faction, 1),
			(party_set_flags, reg0, pf_always_visible, 1),
			#(party_add_particle_system, reg0, "psys_sun_blue_01"),
			
			(call_script, "script_determine_star_color", reg0),
			
			(mtrand, ":rand", 0, 4),

			(party_get_slot, ":icon", reg0, slot_system_star_color),
			(val_sub, ":icon", 1),
			(val_mul, ":icon", 4),
			(val_add, ":icon", ":rand"),
			(val_add, ":icon", "icon_star_red_01"),
			
			(party_set_icon, reg0, ":icon"),
			
			(troop_get_slot, ":length", "trp_temp_troop", 0),
			(store_random_in_range, ":slot", 1, ":length"),
			(troop_get_slot, ":name", "trp_temp_troop", ":slot"),
			# (store_add, ":len_plus", ":length", 1),
			
			(try_for_range, ":rem", ":slot", ":length"),
				(store_add, ":next_slot", ":rem", 1),
				(troop_get_slot, ":next_val", "trp_temp_troop", ":next_slot"),
				(troop_set_slot, "trp_temp_troop", ":rem", ":next_val"),
			(try_end),
			
			(val_sub, ":length", 1),
			(troop_set_slot, "trp_temp_troop", 0, ":length"),
			
			(str_store_string, s1, ":name"),
			(party_set_name, reg0, s1),
		(try_end),		
	]),
	
	#script_determine_star_color
	# This script is used during map generation to determine what star the system has, 
	# further calling a planet environment script to assign its type 
	# INPUT: party_id
	# OUTPUT: none
	("determine_star_color", [
		(store_script_param, ":party", 1),
		
		(mtrand, ":rand", 1, 101),
			
		(try_begin),
			(is_between, ":rand", 70, 101),
			# Red Star
			(party_set_slot, ":party", slot_system_star_color, st_red_star),
		(else_try),
			(is_between, ":rand", 45, 70),
			# Green Star
			(party_set_slot, ":party", slot_system_star_color, st_green_star),
		(else_try),
			(is_between, ":rand", 30, 45),
			# Yellow Star
			(party_set_slot, ":party", slot_system_star_color, st_yellow_star),
		(else_try),
			(is_between, ":rand", 15, 30),
			# Blue Star
			(party_set_slot, ":party", slot_system_star_color, st_blue_star),
		(else_try),
			(is_between, ":rand", 5, 15),
			# White Star
			(party_set_slot, ":party", slot_system_star_color, st_white_star),
		(else_try),
			# Neutron Star
			(party_set_slot, ":party", slot_system_star_color, st_neutron_star),
		(try_end),
	]),
	
	#script_determine_planet_type
	# This script is used during map generation to determine what type of planet 
	# a newly created system has, depending on the star and whether it is inside a nebula
	# INPUT: Star Type
	# OUTPUT:	reg1: Planet Environment
	#			reg2: Planet Size
	#			
	("determine_planet_type", [
		(store_script_param, ":star_type", 1),
		(store_script_param, ":is_nebula", 2),
		
		(mtrand, ":rand", 1, 101),
		
		(assign, ":planet_type", planet_type_none),
		
		(try_begin),
			(eq, ":star_type", st_red_star),
			
			(try_begin),
				(neq, ":is_nebula", 1),
				
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 90, 95),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 85, 90),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 80, 85),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 75, 80),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 70, 75),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 65, 70),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 55, 65),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 45, 55),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 30, 45),
					(assign, ":planet_type", planet_type_arid),
				(else_try),
					(is_between, ":rand", 20, 30),
					(assign, ":planet_type", planet_type_ocean),
				(else_try),
					(is_between, ":rand", 10, 20),
					(assign, ":planet_type", planet_type_jungle),
				(else_try),
					(is_between, ":rand", 5, 10),
					(assign, ":planet_type", planet_type_terran),
				(try_end),
			(else_try),
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 90, 95),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 85, 90),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 80, 85),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 75, 80),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 70, 75),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 65, 70),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 55, 65),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 45, 55),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 30, 45),
					(assign, ":planet_type", planet_type_arid),
				(else_try),
					(is_between, ":rand", 25, 30),
					(assign, ":planet_type", planet_type_ocean),
				(try_end),
			(try_end),
		(else_try),
			(eq, ":star_type", st_green_star),
			
			(try_begin),
				(neq, ":is_nebula", 1),
				
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 90, 95),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 85, 90),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 80, 85),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 75, 80),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 70, 75),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 65, 70),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 60, 65),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 50, 60),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 40, 50),
					(assign, ":planet_type", planet_type_arid),
				(else_try),
					(is_between, ":rand", 30, 40),
					(assign, ":planet_type", planet_type_ocean),
				(else_try),
					(is_between, ":rand", 20, 30),
					(assign, ":planet_type", planet_type_jungle),
				(else_try),
					(is_between, ":rand", 5, 15),
					(assign, ":planet_type", planet_type_terran),
				(try_end),
			(else_try),
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 90, 95),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 85, 90),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 80, 85),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 75, 80),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 70, 75),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 65, 70),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 60, 65),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 50, 60),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 40, 50),
					(assign, ":planet_type", planet_type_arid),
				(else_try),
					(is_between, ":rand", 30, 40),
					(assign, ":planet_type", planet_type_ocean),
				(else_try),
					(is_between, ":rand", 25, 30),
					(assign, ":planet_type", planet_type_jungle),
				(try_end),
			(try_end),
		(else_try),
			(eq, ":star_type", st_yellow_star),
			
			(try_begin),
				(neq, ":is_nebula", 1),
				
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 90, 95),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 85, 90),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 80, 85),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 75, 80),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 70, 75),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 60, 70),
					(assign, ":planet_type", planet_type_arid),
				(else_try),
					(is_between, ":rand", 50, 60),
					(assign, ":planet_type", planet_type_ocean),
				(else_try),
					(is_between, ":rand", 40, 50),
					(assign, ":planet_type", planet_type_jungle),
				(else_try),
					(is_between, ":rand", 0, 40),
					(assign, ":planet_type", planet_type_terran),
				(try_end),	
			(else_try),
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 90, 95),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 85, 90),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 80, 85),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 75, 80),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 70, 75),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 65, 70),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 60, 65),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 50, 60),
					(assign, ":planet_type", planet_type_arid),
				(else_try),
					(is_between, ":rand", 40, 50),
					(assign, ":planet_type", planet_type_ocean),
				(else_try),
					(is_between, ":rand", 30, 40),
					(assign, ":planet_type", planet_type_jungle),
				(else_try),
					(is_between, ":rand", 10, 30),
					(assign, ":planet_type", planet_type_terran),
				(try_end),
			(try_end),	
		(else_try),
			(eq, ":star_type", st_blue_star),
			
			(try_begin),
				(neq, ":is_nebula", 1),
				
				(try_begin),
					(is_between, ":rand", 90, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 80, 90),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 70, 80),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 60, 70),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 50, 60),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 40, 50),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 30, 40),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 25, 30),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 20, 25),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 15, 20),
					(assign, ":planet_type", planet_type_arid),
				(try_end),
			(else_try),
				(try_begin),
					(is_between, ":rand", 90, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 80, 90),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 70, 80),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 60, 70),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 50, 60),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 40, 50),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 35, 40),
					(assign, ":planet_type", planet_type_minimal),
				(try_end),
			(try_end),
		(else_try),
			(eq, ":star_type", st_white_star),
			
			(try_begin),
				(neq, ":is_nebula", 1),
				
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 85, 95),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 75, 85),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 65, 75),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 55, 65),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 45, 55),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 35, 45),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 25, 35),
					(assign, ":planet_type", planet_type_desert),
				(else_try),
					(is_between, ":rand", 20, 25),
					(assign, ":planet_type", planet_type_steppe),
				(else_try),
					(is_between, ":rand", 15, 20),
					(assign, ":planet_type", planet_type_arid),
				(else_try),
					(is_between, ":rand", 10, 15),
					(assign, ":planet_type", planet_type_ocean),
				(try_end),
			(else_try),
				(try_begin),
					(is_between, ":rand", 95, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 85, 95),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 75, 85),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 65, 75),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 55, 65),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 45, 55),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 35, 45),
					(assign, ":planet_type", planet_type_minimal),
				(else_try),
					(is_between, ":rand", 30, 35),
					(assign, ":planet_type", planet_type_desert),
				(try_end),
			(try_end),
		(else_try),
			(eq, ":star_type", st_neutron_star),
			
			(try_begin),
				(neq, ":is_nebula", 1),
				
				(try_begin),
					(is_between, ":rand", 75, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 60, 75),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 45, 60),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 35, 45),
					(assign, ":planet_type", planet_type_dead),
				(else_try),
					(is_between, ":rand", 30, 35),
					(assign, ":planet_type", planet_type_tundra),
				(else_try),
					(is_between, ":rand", 25, 30),
					(assign, ":planet_type", planet_type_barren),
				(else_try),
					(is_between, ":rand", 20, 25),
					(assign, ":planet_type", planet_type_minimal),
				(try_end),
			(else_try),
				(try_begin),
					(is_between, ":rand", 75, 101),
					(assign, ":planet_type", planet_type_radiated),
				(else_try),
					(is_between, ":rand", 60, 75),
					(assign, ":planet_type", planet_type_toxic),
				(else_try),
					(is_between, ":rand", 45, 60),
					(assign, ":planet_type", planet_type_inferno),
				(else_try),
					(is_between, ":rand", 40, 45),
					(assign, ":planet_type", planet_type_dead),
				(try_end),
			(try_end),
		(try_end),
		
		(assign, reg1, ":planet_type"),
	]),
	
	#script_determine_star_color
	# This script is used during map generation to determine what star the system has, 
	# further calling a planet environment script to assign its type 
	# INPUT: party_id
	# OUTPUT: none
	("reveal_system_name", [
		(store_script_param, ":party", 1),
		
		(party_set_flags, ":party", pf_label_medium, 1),
	]),
	
		#script_determine_star_color
	# This script is used during map generation to determine what star the system has, 
	# further calling a planet environment script to assign its type 
	# INPUT: party_id
	# OUTPUT: none
	("stardate_to_s1", [
		(assign, ":stardate", 35000),
		(val_add, ":stardate", "$g_turns_taken"),
		(store_mod, ":decimal", ":stardate", 10),
		(store_div, reg1, ":stardate", 10),
		(assign, reg2, ":decimal"),
		(str_store_string, s1, "@{reg1}.{reg2}"),
	]),
	
	
]