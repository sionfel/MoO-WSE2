from header_common import *
from header_operations import *
from header_parties import *
from header_items import *
from header_skills import *
from header_triggers import *
from header_troops import *
from module_constants import *

# #######################################################################
#	(check_interval, delay_interval, rearm_interval, [conditions], [consequences]),
#
#  Each trigger contains the following fields:
# 1) Check interval: How frequently this trigger will be checked
# 2) Delay interval: Time to wait before applying the consequences of the trigger
#    After its conditions have been evaluated as true.
# 3) Re-arm interval. How much time must pass after applying the consequences of the trigger for the trigger to become active again.
#    You can put the constant ti_once here to make sure that the trigger never becomes active again after it fires once.
# 4) Conditions block (list). This must be a valid operation block. See header_operations.py for reference.
#    Every time the trigger is checked, the conditions block will be executed.
#    If the conditions block returns true, the consequences block will be executed.
#    If the conditions block is empty, it is assumed that it always evaluates to true.
# 5) Consequences block (list). This must be a valid operation block. See header_operations.py for reference. 
# #######################################################################

# #######################################################################
#	Used on the overworld to trigger events if conditions are true 
#	during the interval of which it was checked. 
#
#	Used very often to do things like restock vendors, add parties 
#	to the map, and check quest progress. 
#
#	If you do not need to use the delay, rearm, and conditions 
#	use simple_triggers instead.
# #######################################################################

triggers = [

    (0, 0, 0, [(key_clicked, key_left_control),],
    [
		(set_fixed_point_multiplier, 1000),
		(mouse_get_position, pos2),
		(position_get_x, reg3, pos2),
		(position_get_y, reg4, pos2),
		(display_message, "@{reg3}, {reg4}"),
    ]),	
	
	(0, 0, 0, [
		(this_or_next|key_clicked, key_left),
		(key_clicked, key_right),
	],
    [
		(try_begin),
			(key_clicked, key_right),
			(val_add, "$g_mapbar_state", 1),
			
			(try_begin),
				(gt, "$g_mapbar_state", 2),
				(assign, "$g_mapbar_state", 0),
			(try_end),
			
		(else_try),
			(val_sub, "$g_mapbar_state", 1),
			
			(try_begin),
				(lt, "$g_mapbar_state", 0),
				(assign, "$g_mapbar_state", 2),
			(try_end),
			
		(try_end),
		
		(set_shader_param_int, "@map_bar_status", "$g_mapbar_state"),
			
    ]),	
	
	(0, 0, 0, [(game_key_clicked, gk_attack),], [
		(set_fixed_point_multiplier, 1000),
		(mouse_get_position, pos2),
		(position_get_x, ":x", pos2),
		(position_get_y, ":y", pos2),
		
		(try_begin),
			(is_between, ":x", 330, 444),
			(lt, ":y", 35),
			
			(start_presentation, "prsnt_choose_race"),
		(else_try),
			(lt, ":x", 830),
			(gt, ":y", 35),
			
			(get_mouse_map_coordinates, pos1),
			
			# (position_get_x, reg1, pos1),
			# (position_get_y, reg2, pos1),
			# (position_set_z, pos1, 1000),
			# (position_get_z, reg3, pos1),
			# (display_message, "@{reg1}, {reg2}, {reg3}"),
			
			# (party_set_position, 0, pos1),
			(set_fixed_point_multiplier, 100),
			(assign, ":dist", 999999),
			(assign, ":nearest_party", -1),
			
			(try_for_parties, ":party"),
				(neq, ":party", "p_main_party"),
				(party_get_position, pos2, ":party"),
				(get_distance_between_positions, ":check_dist", pos1, pos2),
				(lt, ":check_dist", ":dist"),
				(assign, ":nearest_party", ":party"),
				(assign, ":dist", ":check_dist"),
				(copy_position, pos3, pos2),
			(try_end),
			
			# (str_store_party_name, s1, ":nearest_party"),
			# (assign, reg1, ":dist"),
			# 
			# (display_message, "@found {s1}, {reg1}"),
			# 
			# (position_get_x, reg1, pos3),
			# (position_get_y, reg2, pos3),
			# (position_get_z, reg3, pos3),
			# 
			# (display_message, "@{reg1}, {reg2}, {reg3}"),
			
			(try_begin),
				(lt, ":dist", 200),
			
				(party_get_position, pos2, ":nearest_party"),
				(lua_set_top, 0),
				(lua_push_int, ":nearest_party"),
				(lua_call, "@send_star_orbits", 1),
				(lua_set_top, 0),
				(party_set_position, "p_main_party", pos2),
				# (party_relocate_near_party, "p_main_party", ":nearest_party", 0),
				(set_camera_follow_party, "p_main_party", 1),
				(set_fixed_point_multiplier, 1000),
				#text
				(call_script, "script_stardate_to_s1"),
				(str_store_string, s2, "@{s1}^"),
				(try_for_range, reg1, 0, 60),
					(str_clear, s1),
					(try_begin),
						(eq, reg1, 7),
						(str_store_string, s1, "@Treasury Credits"),
					(else_try),
						(eq, reg1, 8),
						(str_store_string, s1, "@Credits Change"),
					(else_try),
						(eq, reg1, 18),
						(str_store_string, s1, "@Command Points"),
					(else_try),
						(eq, reg1, 27),
						(str_store_string, s1, "@Net Food"),
					(else_try),
						(eq, reg1, 37),
						(str_store_string, s1, "@Freighter Fleet"),
					(else_try),
						(eq, reg1, 45),
						(str_store_string, s1, "@Breakthrough %"),
					(else_try),
						(eq, reg1, 46),
						(str_store_string, s1, "@~ Turns Left"),
					(else_try),
						(eq, reg1, 47),
						(str_store_string, s1, "@Current Research Points"),
					(try_end),
					(str_store_string, s2, "@{s2}{s1}^"),
				(try_end),
				
				(tutorial_message, -1),
				(tutorial_message_set_size, 15, 15),
				(tutorial_message_set_position, 913, 715),
				(tutorial_message_set_center_justify, 1),
				(tutorial_message_set_background, 0),
				(tutorial_message, s2, 0xffffffff),
			(try_end),
		(else_try),
			(gt, ":x", 830),
			(lt, ":y", 75),
			# (display_message, "@Next Turn"),
			(lua_call, "@NextTurn"),
			(lua_call, "@savegame"),
			(question_box, "@Are you sure you would like to advance to the next turn?", "@Yes", "@No"),
			# (val_add, "$g_turns_taken", 1),
		(try_end),
	])
]
