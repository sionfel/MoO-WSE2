from header_physics_materials import *

####################################################################################################################
#	This file allows the modder to register their physics materials in the WSE2 Shader BRF format.
#	Each physics material record contains the following fields:
#	1) Material Name: String,
#	2) Flags: Int, 
#	3) Friction Coefficient: Float,
#	("material_name", flags, friction_coefficient),
####################################################################################################################

physics_materials = [
	("default", 0, 0.5),
]