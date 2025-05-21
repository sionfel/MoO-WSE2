from header_common import *
from header_operations import *
from header_mission_templates import *
from header_animations import *
from header_sounds import *
from header_music import *
from header_items import *
from module_constants import *

# #######################################################################
#   Each mission-template is a tuple that contains the following fields:
#  1) Mission-template id (string): used for referencing mission-templates in other files.
#     The prefix mt_ is automatically added before each mission-template id
#
#  2) Mission-template flags (int): See header_mission-templates.py for a list of available flags
#  3) Mission-type(int): Which mission types this mission template matches.
#     For mission-types to be used with the default party-meeting system,
#     this should be 'charge' or 'charge_with_ally' otherwise must be -1.
#     
#  4) Mission description text (string).
#  5) List of spawn records (list): Each spawn record is a tuple that contains the following fields:
#    5.1) entry-no: Troops spawned from this spawn record will use this entry
#    5.2) spawn flags.
#    5.3) alter flags. which equipment will be overriden
#    5.4) ai flags.
#    5.5) Number of troops to spawn.
#    5.6) list of equipment to add to troops spawned from here (maximum 8).
#  6) List of triggers (list).
#     See module_triggers.py for infomation about triggers.
# #######################################################################

mission_templates = [

    # #######################################################################
    #		town_default and conversation_encounter are HARDCODED! 
	#	Absolutely DO NOT move. You can modify them, but be cool about it.
	# #######################################################################
    ("town_default", 0, -1,
    "Town Default",
    [
	    (0, mtef_scene_source|mtef_team_0, af_override_horse, 0, 1, []),
    ],     
    []),

    ("conversation_encounter", 0, -1,
    "Conversation Encounter",
    [
	    (0, mtef_visitor_source, af_override_fullhelm, 0, 1, []), 
		(1, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
        (2, mtef_visitor_source, af_override_fullhelm, 0, 1, []), 
		(3, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(4, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(5, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(6, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
        (7, mtef_visitor_source, af_override_fullhelm, 0, 1, []), 
		(8, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(9, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(10, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(11, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		
        # prisoners now...
        (12, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(13, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(14, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(15, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(16, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
    
	    # Other party
        (17, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(18, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(19, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(20, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(21, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(22, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(23, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(24, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(25, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(26, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(27, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(28, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(29, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(30, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
		(31, mtef_visitor_source, af_override_fullhelm, 0, 1, []),
    ],
    [],
    ),
  
    # #######################################################################
	#	I left lead_charge in because it is so commonly used, but it's not
	#						~ R E Q U I R E D ~ 
	#										y'know.
	# #######################################################################

    ("lead_charge", mtf_battle_mode, charge,
    "Lead Charge",
    [
        (1, mtef_defenders|mtef_team_0, 0, aif_start_alarmed, 12, []),
        (0, mtef_defenders|mtef_team_0, 0, aif_start_alarmed, 0, []),
        (4, mtef_attackers|mtef_team_1, 0, aif_start_alarmed, 12, []),
        (4, mtef_attackers|mtef_team_1, 0, aif_start_alarmed, 0, []),
    ],
    [
    ]),
	
	# #######################################################################
	#	Feel free to plug away here.
	# #######################################################################
]
