from header_meshes import *

# #######################################################################
# ("mesh_id", flags, "actual_mesh_in_brf_name", x_axis, y_axis, z_axis, x_rot, y_rot, z_rot, x_scale, y_scale, z_scale),
#
#  Each mesh record contains the following fields:
#  1) Mesh id: used for referencing meshes in other files. The prefix mesh_ is automatically added before each mesh id.
#  2) Mesh flags. See header_meshes.py for a list of available flags
#  3) Mesh resource name: Resource name of the mesh
#  4) Mesh translation on x axis: Will be done automatically when the mesh is loaded
#  5) Mesh translation on y axis: Will be done automatically when the mesh is loaded
#  6) Mesh translation on z axis: Will be done automatically when the mesh is loaded
#  7) Mesh rotation angle over x axis: Will be done automatically when the mesh is loaded
#  8) Mesh rotation angle over y axis: Will be done automatically when the mesh is loaded
#  9) Mesh rotation angle over z axis: Will be done automatically when the mesh is loaded
#  10) Mesh x scale: Will be done automatically when the mesh is loaded
#  11) Mesh y scale: Will be done automatically when the mesh is loaded
#  12) Mesh z scale: Will be done automatically when the mesh is loaded
# #######################################################################



meshes = [
	# #######################################################################
	#	The hardcodedness of these two is debateable, but lacking them does
	#	cause rgl_log to print warnings. It defaults to these same two meshes
	#	if they are missing, so it's more of ~warning avoidance system~
	# #######################################################################
	("main_menu_background", -0x00000001, "main_menu_nord", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("loading_background", 0, "load_screen_2", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	# #######################################################################
	#	G L H F ! ! !
	# #######################################################################
	
	("checkbox_off", render_order_plus_1, "checkbox_off", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("checkbox_on", render_order_plus_1, "checkbox_on", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("white_plane", 0, "white_plane", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("generation_options", 0, "generation_options", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("2", 0, "icon_2", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("3", 0, "icon_3", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("4", 0, "icon_4", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("5", 0, "icon_5", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("6", 0, "icon_6", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("7", 0, "icon_7", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("8", 0, "icon_8", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("tutor", 0, "icon_tutor", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("easy", 0, "icon_easy", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("average", 0, "icon_average", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("hard", 0, "icon_hard", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("impossible", 0, "icon_impossible", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("prewarp", 0, "icon_prewarp", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("tech_average", 0, "icon_tech_average", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("postwarp", 0, "icon_postwarp", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("advance", 0, "icon_advance", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("small", 0, "icon_small", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("medium", 0, "icon_medium", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("large", 0, "icon_large", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("cluster", 0, "icon_cluster", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("huge", 0, "icon_huge", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("age_average", 0, "icon_age_average", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("age_organic", 0, "icon_age_organic", 0, 0, 0, 0, 0, 0, 1, 1, 1),
	("age_mineral", 0, "icon_age_mineral", 0, 0, 0, 0, 0, 0, 1, 1, 1),
]