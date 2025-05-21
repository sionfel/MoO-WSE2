from header_common import *
from header_presentations import *
from header_mission_templates import *
from ID_meshes import *
from header_operations import *
from header_triggers import *
from module_constants import *
import string

# #######################################################################
#
#	("presentation_id", flags, bg_mesh, [triggers]),
#
#  Each presentation record contains the following fields:
#  1) Presentation id: used for referencing presentations in other files. The prefix prsnt_ is automatically added before each presentation id.
#  2) Presentation flags. See header_presentations.py for a list of available flags
#  3) Presentation background mesh: See module_meshes.py for a list of available background meshes
#  4) Triggers: Simple triggers that are associated with the presentation
# #######################################################################
presentations = [

    # #######################################################################
    # 		Hardcoded, mostly things the engine will try to call and will
	#		cause errors if not declared, even if they do nothing.
	# #######################################################################
	
	# #######################################################################
	# 	Called by engine when game starts, can be used to add to the main
	# 	menu. The funny thing is that if it doesn't exist, there is no error,
	#	but if it does exist it ~A B S O L U T E L Y~ must be first.
	# #######################################################################
	("game_start", 0, 0,
		[(ti_on_presentation_load,[(presentation_set_duration, 0)]),
	]),
	
	# #######################################################################
	# Called by engine when pressing `ESC`, can be used to add to the escape menu
	# #######################################################################
	("game_escape", 0, 0,
		[(ti_on_presentation_load,[(presentation_set_duration, 0)]),
	]),
	# #######################################################################
	# Called by pressing the credits button on the main menu
	# #######################################################################
	("game_credits", 0, 0,
		[(ti_on_presentation_load,[(presentation_set_duration, 0)]),
	]),
	
	# #######################################################################
	# Called by engine when setting up a banner for Multiplayer, the engine
	# looks for its existance even if your module.ini has_multiplayer = 0
	# #######################################################################
	("game_profile_banner_selection", 0, 0,
		[(ti_on_presentation_load,[(presentation_set_duration, 0)]),
	]),
	
	# #######################################################################
	# Called by engine when setting up a custom battle from the main menu.
	#	Copy and Paste from Native if you would like to re-add,
	#	If you want to take out entirely, find :
	# initial_custom_battle_button_size_x, initial_custom_battle_button_size_y
	# initial_custom_battle_button_text_size_x, initial_custom_battle_button_text_size_y
	#	in game_variables.txt and set to 0.0
	# #######################################################################
	("game_custom_battle_designer", 0, 0,
		[(ti_on_presentation_load,[(presentation_set_duration, 0)]),
	]),
	
	# #######################################################################
	# Called by engine when looking at the admin menu in multiplayer, 
	# is hardcoded an required even if your module.ini has_multiplayer = 0
	# #######################################################################
	("game_multiplayer_admin_panel", 0, 0,
		[(ti_on_presentation_load,[(presentation_set_duration, 0)]),
	]),
	
	# #######################################################################
	# Called by the engine when a player exits the game. Basically used
	# in Native to show a purchase promo screen in demo mode.
	# #######################################################################
	("game_before_quit", 0, 0,
		[(ti_on_presentation_load,[(presentation_set_duration, 0),
		(set_shader_param_int, "@map_bar_status", 0),
		]),
	]),
	
	# #######################################################################
	# Called by the WSE2 engine when a modder opens the CTRL-R debug menu to
	# allow you to extra information to the agent view, i.e. slots/states/etc
	# #######################################################################
	#prsnt_wse_mission_debug_window
	("wse_mission_debug_window", 0, 0, [
		(ti_on_presentation_load, [      
			(set_fixed_point_multiplier, 1000),
			
			(presentation_set_duration, 999999),
		]),
	  
		(ti_on_presentation_run, [
			# (store_trigger_param_1, ":cur_time"),
			# (store_trigger_param_2, ":selected_agent_no"),
			
		]),
	]),

	
	# #######################################################################
	#		Add your stuff here. 
	#			Good Luck! You'll need it!
    # #######################################################################
	
	("game_creation", prsntf_manual_end_only, mesh_generation_options,
		[(ti_on_presentation_load,[
			(set_fixed_point_multiplier, 1000),
			
			(create_text_overlay, reg1, "@New Game", tf_center_justify|tf_with_outline|tf_single_line),
			
			(position_set_x, pos1, 2000),
			(position_set_y, pos1, 2000),
			(overlay_set_size, reg1, pos1),
			
			(position_set_x, pos1, 500),
			(position_set_y, pos1, 700),
			(overlay_set_position, reg1, pos1),
			
			(create_text_overlay, reg1, "@Difficulty", tf_center_justify|tf_single_line),
			
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, reg1, pos1),
			
			(position_set_x, pos1, 150),
			(position_set_y, pos1, 650),
			(overlay_set_position, reg1, pos1),
			
			(store_add, ":mesh", "mesh_tutor", "$g_game_difficulty"),
			(create_mesh_overlay, reg1, ":mesh"),
			(position_set_y, pos1, 535),
			(overlay_set_position, reg1, pos1),
			
			(create_combo_label_overlay, "$g_presentation_difficulty"),
			
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, "$g_presentation_difficulty", pos1),
			
			(position_set_x, pos1, 150),
			(position_set_y, pos1, 400),
			(overlay_set_position, "$g_presentation_difficulty", pos1),
			
			(overlay_add_item, "$g_presentation_difficulty", "@Tutor"),
			(overlay_add_item, "$g_presentation_difficulty", "@Easy"),
			(overlay_add_item, "$g_presentation_difficulty", "@Average"),
			(overlay_add_item, "$g_presentation_difficulty", "@Hard"),
			(overlay_add_item, "$g_presentation_difficulty", "@Impossible"),
			
			(overlay_set_val, "$g_presentation_difficulty", "$g_game_difficulty"),
			
			(create_text_overlay, reg1, "@Galaxy Size", tf_center_justify|tf_single_line),
			
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, reg1, pos1),
			
			(position_set_x, pos1, 500),
			(position_set_y, pos1, 650),
			(overlay_set_position, reg1, pos1),
			
			(store_add, ":mesh", "mesh_small", "$g_galaxy_size"),
			(create_mesh_overlay, reg1, ":mesh"),
			(position_set_y, pos1, 535),
			(overlay_set_position, reg1, pos1),
			
			(create_combo_label_overlay, "$g_presentation_g_size"),
			
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, "$g_presentation_g_size", pos1),
			
			(position_set_x, pos1, 500),
			(position_set_y, pos1, 400),
			(overlay_set_position, "$g_presentation_g_size", pos1),
			
			(overlay_add_item, "$g_presentation_g_size", "@Small"),
			(overlay_add_item, "$g_presentation_g_size", "@Medium"),
			(overlay_add_item, "$g_presentation_g_size", "@Large"),
			(overlay_add_item, "$g_presentation_g_size", "@Cluster"),
			(overlay_add_item, "$g_presentation_g_size", "@Huge"),
			
			(overlay_set_val, "$g_presentation_g_size", "$g_galaxy_size"),
			
			
			(create_text_overlay, reg1, "@Galaxy Age", tf_center_justify|tf_single_line),

			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, reg1, pos1),
			
			(position_set_x, pos1, 850),
			(position_set_y, pos1, 650),
			(overlay_set_position, reg1, pos1),
			
			(store_add, ":mesh", "mesh_age_average", "$g_galaxy_age"),
			(create_mesh_overlay, reg1, ":mesh"),
			(position_set_y, pos1, 535),
			(overlay_set_position, reg1, pos1),
			
			(create_combo_label_overlay, "$g_presentation_g_age"),
			
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, "$g_presentation_g_age", pos1),
			
			(position_set_x, pos1, 850),
			(position_set_y, pos1, 400),
			(overlay_set_position, "$g_presentation_g_age", pos1),
			
			(overlay_add_item, "$g_presentation_g_age", "@Average"),
			(overlay_add_item, "$g_presentation_g_age", "@Organic Rich"),
			(overlay_add_item, "$g_presentation_g_age", "@Mineral Rich"),

			(overlay_set_val, "$g_presentation_g_age", "$g_galaxy_age"),
			
			(create_text_overlay, reg1, "@Civilizations", tf_center_justify|tf_single_line),
						
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, reg1, pos1),
			
			(position_set_x, pos1, 150),
			(position_set_y, pos1, 350),
			(overlay_set_position, reg1, pos1),
			
			(store_add, ":mesh", "mesh_2", "$g_player_count"),
			(create_mesh_overlay, reg1, ":mesh"),
			(position_set_y, pos1, 235),
			(overlay_set_position, reg1, pos1),
			
			(create_combo_label_overlay, "$g_presentation_civ_count"),
			
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, "$g_presentation_civ_count", pos1),
			
			(position_set_x, pos1, 150),
			(position_set_y, pos1, 100),
			(overlay_set_position, "$g_presentation_civ_count", pos1),
			
			(try_for_range, reg1, 2, 9),
				(overlay_add_item, "$g_presentation_civ_count", "@{reg1}"),
			(try_end),
			
			(overlay_set_val, "$g_presentation_civ_count", "$g_player_count"),
			
			(create_text_overlay, reg1, "@Tech Level", tf_center_justify|tf_single_line),

			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, reg1, pos1),
			
			(position_set_x, pos1, 500),
			(position_set_y, pos1, 350),
			(overlay_set_position, reg1, pos1),
			
			(store_add, ":mesh", "mesh_prewarp", "$g_tech_level"),
			(create_mesh_overlay, reg1, ":mesh"),
			(position_set_y, pos1, 235),
			(overlay_set_position, reg1, pos1),
			
			(create_combo_label_overlay, "$g_presentation_tech_level"),
			
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 700),
			(overlay_set_size, "$g_presentation_tech_level", pos1),
			
			(position_set_x, pos1, 500),
			(position_set_y, pos1, 100),
			(overlay_set_position, "$g_presentation_tech_level", pos1),

			(overlay_add_item, "$g_presentation_tech_level", "@Pre Warp"),
			(overlay_add_item, "$g_presentation_tech_level", "@Average"),
			(overlay_add_item, "$g_presentation_tech_level", "@Post Warp"),
			(overlay_add_item, "$g_presentation_tech_level", "@Advance"),
			
			(overlay_set_val, "$g_presentation_tech_level", "$g_tech_level"),
			
			(create_game_button_overlay, "$g_presentation_accept", "@Accept"),
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 50),
			(overlay_set_position, "$g_presentation_accept", pos1),
			
			(create_game_button_overlay, "$g_presentation_cancel", "@Cancel"),
			(position_set_x, pos1, 300),
			(position_set_y, pos1, 50),
			(overlay_set_position, "$g_presentation_cancel", pos1),		
			
			(presentation_set_duration, 999999),
		]),
		
		(ti_on_presentation_run, [			
			(try_begin),
				(this_or_next|key_clicked, key_escape),
				(this_or_next|key_clicked, key_tab),
				(key_clicked, key_back_space),
				
				(jump_to_menu, "mnu_start_game_0"),
				(presentation_set_duration, 0),
			(else_try),
				(key_clicked, key_left_control),
				(set_fixed_point_multiplier, 1000),
				(mouse_get_position, pos2),
				(position_get_x, reg3, pos2),
				(position_get_y, reg4, pos2),
				(display_message, "@{reg3}, {reg4}"),
			(try_end),
		
		]),
		
		(ti_on_presentation_event_state_change, [
			(store_trigger_param_1, ":overlay_id"),
			(store_trigger_param_2, ":val"),
			
			(try_begin),
				(eq, ":overlay_id", "$g_presentation_accept"),
				(start_presentation, "prsnt_choose_race"),
			(else_try),
				(eq, ":overlay_id", "$g_presentation_cancel"),
				(jump_to_menu, "mnu_start_game_0"),
				(presentation_set_duration, 0),
			(else_try),
				(eq, ":overlay_id", "$g_presentation_difficulty"),
				(assign, "$g_game_difficulty", ":val"),
				(start_presentation, "prsnt_game_creation"),
			(else_try),
				(eq, ":overlay_id", "$g_presentation_g_size"), 
				(assign, "$g_galaxy_size", ":val"),
				(start_presentation, "prsnt_game_creation"),
			(else_try),
				(eq, ":overlay_id", "$g_presentation_g_age"), 
				(assign, "$g_galaxy_age", ":val"),
				(start_presentation, "prsnt_game_creation"),
			(else_try),
				(eq, ":overlay_id", "$g_presentation_civ_count"), 
				(assign, "$g_player_count", ":val"),
				(start_presentation, "prsnt_game_creation"),
			(else_try),
				(eq, ":overlay_id", "$g_presentation_tech_level"),
				(assign, "$g_tech_level", ":val"),
				(start_presentation, "prsnt_game_creation"),
			(try_end),
			
		]),
		(ti_on_presentation_mouse_press, [
			(store_trigger_param_1, ":overlay_id"),
			(store_trigger_param_2, ":button"),
			
			(eq, ":button", 1),
			(display_message, "@right click"),
			# (overlay_set_tooltip, ":overlay_id", "@tool_tip"),
			(dialog_box, "@tooltip", "@title"),
		]),
# Trigger Param 1: id of the object that mouse is pressed on
# Trigger Param 2: 0: left mouse button, 1 right mouse button, 2 middle mouse button
	]),
	
	("choose_race", prsntf_manual_end_only, mesh_loading_background,
		[(ti_on_presentation_load,[
			(set_fixed_point_multiplier, 1000),
			
			(create_text_overlay, reg1, "@Choose Race", tf_center_justify|tf_with_outline|tf_single_line),
			(position_set_x, pos1, 500),
			(position_set_y, pos1, 700),
			(overlay_set_position, reg1, pos1),
			
			(position_set_x, pos1, 2000),
			(position_set_y, pos1, 2000),
			(overlay_set_size, reg1, pos1),
			
			
			(create_text_overlay, "$g_presentation_race_title", "@Race", tf_center_justify|tf_with_outline|tf_single_line),
			(position_set_x, pos1, 1500),
			(position_set_y, pos1, 1500),
			(overlay_set_size, "$g_presentation_race_title", pos1),
			(position_set_x, pos1, 307),
			(position_set_y, pos1, 300),
			(overlay_set_position, "$g_presentation_race_title", pos1),
			(overlay_set_color, "$g_presentation_race_title", 0xffffffff),
			
			
			(str_clear, s1),
			(create_text_overlay, "$g_presentation_race_desc", s1, tf_scrollable|tf_left_align|tf_with_outline),
			(position_set_x, pos1, 1000),
			(position_set_y, pos1, 1000),
			(overlay_set_size, "$g_presentation_race_desc", pos1),
			(position_set_x, pos1, 400),
			(position_set_y, pos1, 290-120),
			(overlay_set_area_size, "$g_presentation_race_desc", pos1),
			(position_set_x, pos1, 100),
			(position_set_y, pos1, 120),
			(overlay_set_position, "$g_presentation_race_desc", pos1),
			(overlay_set_color, "$g_presentation_race_desc", 0xffffffff),
								
			
			# game_profile_window
			(create_mesh_overlay_with_tableau_material, reg2, -1, "tableau_troop_note_mesh", "trp_player"),
			# (create_mesh_overlay, reg2, "mesh_white_plane"),
			
			(position_set_x, pos1, 158),
			(position_set_y, pos1, 350),
			(overlay_set_position, reg2, pos1),
			
			(position_set_x, pos1, 1000),
			(position_set_y, pos1, 1000),
			(overlay_set_size, reg2, pos1),
			
			(create_game_button_overlay, "$g_presentation_race_01", "str_alkari"),
			(position_set_x, pos1, 660),
			(position_set_y, pos1, 585),
			(overlay_set_position, "$g_presentation_race_01", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_02", "str_bulrathi"),
			(position_set_x, pos1, 660),
			(position_set_y, pos1, 525),
			(overlay_set_position, "$g_presentation_race_02", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_03", "str_darlock"),
			(position_set_x, pos1, 660),
			(position_set_y, pos1, 465),
			(overlay_set_position, "$g_presentation_race_03", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_04", "str_human"),
			(position_set_x, pos1, 660),
			(position_set_y, pos1, 405),
			(overlay_set_position, "$g_presentation_race_04", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_05", "str_klackon"),
			(position_set_x, pos1, 660),
			(position_set_y, pos1, 345),
			(overlay_set_position, "$g_presentation_race_05", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_06", "str_meklar"),
			(position_set_x, pos1, 660),
			(position_set_y, pos1, 285),
			(overlay_set_position, "$g_presentation_race_06", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_07", "str_mrrshan"),
			(position_set_x, pos1, 660),
			(position_set_y, pos1, 225),
			(overlay_set_position, "$g_presentation_race_07", pos1),
			
			# 
			
			(create_game_button_overlay, "$g_presentation_race_08", "str_psilon"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 585),
			(overlay_set_position, "$g_presentation_race_08", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_09", "str_sakkra"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 525),
			(overlay_set_position, "$g_presentation_race_09", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_10", "str_silicoid"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 465),
			(overlay_set_position, "$g_presentation_race_10", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_11", "str_elerian"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 405),
			(overlay_set_position, "$g_presentation_race_11", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_12", "str_gnolam"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 345),
			(overlay_set_position, "$g_presentation_race_12", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_13", "str_trilarian"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 285),
			(overlay_set_position, "$g_presentation_race_13", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_14", "str_terran"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 225),
			(overlay_set_position, "$g_presentation_race_14", pos1),
			
			(create_game_button_overlay, "$g_presentation_race_15", "@Custom"),
			(position_set_x, pos1, 880),
			(position_set_y, pos1, 165),
			(overlay_set_position, "$g_presentation_race_15", pos1),
			
			
			(create_game_button_overlay, "$g_presentation_accept", "@Accept"),
			(position_set_x, pos1, 700),
			(position_set_y, pos1, 50),
			(overlay_set_position, "$g_presentation_accept", pos1),
			
			(create_game_button_overlay, "$g_presentation_cancel", "@Cancel"),
			(position_set_x, pos1, 300),
			(position_set_y, pos1, 50),
			(overlay_set_position, "$g_presentation_cancel", pos1),		
			
			(presentation_set_duration, 999999),
		]),
		
		(ti_on_presentation_run, [			
			(try_begin),
				(this_or_next|key_clicked, key_escape),
				(this_or_next|key_clicked, key_tab),
				(key_clicked, key_back_space),
				
				# (jump_to_menu, "mnu_start_game_0"),
				# (presentation_set_duration, 0),
				(start_presentation, "prsnt_game_creation"),
			(else_try),
				(key_clicked, key_left_control),
				(set_fixed_point_multiplier, 1000),
				(mouse_get_position, pos2),
				(position_get_x, reg3, pos2),
				(position_get_y, reg4, pos2),
				(display_message, "@{reg3}, {reg4}"),
			(try_end),
		
		]),
		
		(ti_on_presentation_event_state_change, [
			(store_trigger_param_1, ":overlay_id"),
			(store_trigger_param_2, ":val"),
			
			(try_begin),
				(eq, ":overlay_id", "$g_presentation_accept"),
				(presentation_set_duration, 0),
				# (jump_to_menu, "mnu_start_phase_2"),
				# (change_screen_map),
				
			(else_try),
				(eq, ":overlay_id", "$g_presentation_cancel"),
				(start_presentation, "prsnt_game_creation"),
			(else_try),
				(is_between, ":overlay_id", "$g_presentation_race_01", "$g_presentation_accept"),
				(store_sub, ":offset", ":overlay_id", "$g_presentation_race_01"),
				
				(try_begin),
					(ge, ":offset", 10),
					(val_add, ":offset", 2),
				(try_end),
				
				(store_add, ":title", "str_alkari", ":offset"),
				(store_add, ":desc", "str_alkari_desc", ":offset"),
				(overlay_set_text, "$g_presentation_race_title", ":title"),
				(overlay_set_text, "$g_presentation_race_desc", ":desc"),
			(try_end),
		]),
	]),
]
