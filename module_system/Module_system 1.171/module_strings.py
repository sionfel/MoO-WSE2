# -*- coding: utf-8 -*-
# #######################################################################
#	("string-id", "string"),
#	This file was also missing a header, but probably on account 
#	of its simplicity
#
#	Field 1: String ID (string) 
#	Field 2: String Contents (string)
# #######################################################################

from names_lists import *

strings = [

# #######################################################################
#	These four strings are the only explicitly required strings
# #######################################################################

	("no_string", "NO STRING!"),
	("empty_string", " "),
	("yes", "Yes."),
	("no", "No."),
  
# #######################################################################
#	But, these may be referenced, so, I have chosen to leave them here.
# #######################################################################

	("blank_string", " "),
	("ERROR_string", "{!}ERROR!!!ERROR!!!!ERROR!!!ERROR!!!ERROR!!!ERROR!!!!ERROR!!!ERROR!!!!ERROR!!!ERROR!!!!ERROR!!!ERROR!!!!ERROR!!!ERROR!!!!ERROR!!!ERROR!!!!!"),
	("noone", "no one"),
	("s0", "{!}{s0}"),
	("blank_s1", "{!} {s1}"),
	("reg1", "{!}{reg1}"),
	("s50_comma_s51", "{!}{s50}, {s51}"),
	("s50_and_s51", "{s50} and {s51}"),
	("s52_comma_s51", "{!}{s52}, {s51}"),
	("s52_and_s51", "{s52} and {s51}"),
	("s5_s_party", "{s5}'s Party"),
	
	("msg_battle_won", "Battle won! Press tab key to leave..."),
	
	("randomize", "Randomize"),
	("hold_fire", "Hold Fire"),
	("blunt_hold_fire", "Blunt / Hold Fire"),
	
	("finished", "(Finished)"),
	
	("delivered_damage", "Delivered {reg60} damage."),
	
	("cant_use_inventory_now", "Can't access inventory now."),
	("cant_use_inventory_arena", "Can't access inventory in the arena."),
	("cant_use_inventory_disguised", "Can't access inventory while you're disguised."),
	("cant_use_inventory_tutorial", "Can't access inventory in the training camp."),

# #######################################################################
# 	Feel free to add your strings here!
# #######################################################################
	("test_string", "Lorem ipsum dolor sit amet, consectetur adipiscing elit.^^Aliquam ac nisl metus. Integer ac volutpat nisi, sit amet euismod quam. Duis justo justo, rutrum eget pretium id, ultricies sit amet mauris. Mauris convallis urna a nulla sodales, eu tristique velit gravida. Duis ut leo sed ex ornare tempor ut elementum lorem. Sed blandit est quis maximus commodo. Nam ullamcorper pellentesque varius. Morbi ut tincidunt mi, a ornare odio. Sed blandit dapibus nisl, in hendrerit lacus. Morbi condimentum in mi sit amet condimentum. Curabitur bibendum tempor elit, id auctor nulla interdum vel. Phasellus vulputate, neque id sodales pretium, erat nisi placerat augue, non dignissim sapien nunc laoreet orci. Maecenas tempus, arcu eget congue tincidunt, neque est mattis quam, ut placerat ex libero sit amet turpis. Vestibulum rhoncus urna id fermentum cursus. Duis iaculis velit velit, nec dignissim neque lacinia nec. Phasellus quis urna quis enim vulputate posuere. Donec scelerisque dui quis placerat vulputate. Nunc sit amet dui vestibulum, blandit ante nec, vulputate mi. Etiam elementum lacinia sem nec eleifend. Donec non consequat risus, eget venenatis ex. Curabitur tincidunt vestibulum metus vel bibendum. Nam porttitor eros eu lorem feugiat aliquam. Nunc est orci, ultricies a velit eget, interdum tincidunt orci. Ut justo sapien, tincidunt at metus ut, finibus tristique nisi. Cras non mi vulputate erat interdum porttitor sed vel metus. Suspendisse nunc sapien, eleifend ut sem sed, ultrices consectetur urna. Donec massa eros, laoreet non varius non, fringilla eu arcu. Nullam sagittis id elit sed aliquam. Suspendisse convallis ex rhoncus orci bibendum, ac consectetur velit interdum. Cras dignissim, urna at faucibus tristique, erat nulla imperdiet neque, ac scelerisque felis urna ut ipsum. Morbi dapibus elit est, ut laoreet tortor luctus sed. Pellentesque leo augue, mollis vel eros vel, gravida convallis lacus. Pellentesque bibendum non justo quis viverra. Curabitur posuere massa eu mi elementum, sit amet placerat augue eleifend. Vestibulum commodo lacinia pulvinar. Proin gravida justo sed pretium elementum. Sed vehicula ultrices eros nec gravida. Integer eu viverra ante. Vestibulum lectus turpis, tempor id nisi et, efficitur euismod lacus. Ut tincidunt, massa id facilisis placerat, magna lorem interdum eros, non consectetur odio mi accumsan nisi. Etiam rutrum at turpis eu tempor. Duis pulvinar efficitur tellus non hendrerit. Nullam at porta sem. Aenean in volutpat ex. Maecenas pellentesque aliquam justo, id mollis massa sagittis vitae. Quisque a accumsan dui."),

	# Races
	("alkari", "Alkari"),
	("bulrathi", "Bulrathi"),
	("darlock", "Darlock"),
	("human", "Human"),
	("klackon", "Klackon"),
	("meklar", "Meklar"),
	("mrrshan", "Mrrshan"),
	("psilon", "Psilon"),
	("sakkra", "Sakkra"),
	("silicoid", "Silicoid"),
	("orion", "Orion"),
	
	# MoO 2 Races
	("antaran", "Antaran"),
	("elerian", "Elerian"),
	("gnolam", "Gnolam"),
	("trilarian", "Trilarian"),
	
	# MoO 4 (Not doing the ones from 3, lol)
	("terran", "Terran"),
	
	# Races
	("alkari_desc", "The Alkari are descended from large birds and are still capable of limited flight. From an early age Alkari learn to master the subtleties of flight and three dimensional motion. As a result, Alkari make superior pilots: their ships are very difficult to hit and, given equivalent designs, their ships will move before any others except the Mrrshan. Alkari pilots add three levels of defense to any spacecraft they pilot in combat and add +3 to their ship initiatives.^^To take full advantage of the Alkari’s combat bonus, Alkari players should build small and medium ships. The defensive bonus tremendously reduces the amount of damage taken."),
	("bulrathi_desc", "The Bulrathi are a fierce bear-like race that possesses incredible strength and constitution. No other race can match the Bulrathi in personal combat, giving them a +25 bonus in all ground attacks.^^Bulrathi players should always attempt to take colonies with ground forces even if outnumbered."),
	("darlock_desc", "The Darlok are a ruthless race of shapeshifters capable of taking on the form of nearly any living being. This unusual ability to change forms makes them superior spies and allows them a bonus to all sabotage, espionage, and security functions. Darlok spy networks cost only half as much as other races’ spies. The Darlok add +30 to their Spy Fate rolls and add +20 to their security. Of course, no one trusts a Darlok.^^Darlok players should concentrate on one or two areas of technology for a technological advantage and steal the rest."),
	("human_desc", "While man may be physically weaker than many of the other races, his talent for trading and generally amiable nature has made him one of the best diplomats in the universe. Humans receive an additional 25% profit when trading, double the effect of good diplomatic actions, and add +5 diplomatic levels when offering treaties and trade agreements, and in the High Council.^^Since the Humans’ advantage is gained from interaction, human players should immediately begin making deals with other races."),
	("klackon_desc", "The Klackons are a large ant-like race with an extremely ordered society. Each individual is born to serve a single purpose, and does so without question. As a result, the Klackons are mobilized into an industrious society where each unit of population produces double the output of other races. The Klackon’s bonus is cumulative with planetology bonuses.^^Klackons excel in quickly making productive new colonies."),
	("meklar_desc", "For centuries the Meklars have developed and worn powered exoskeletons to compensate for their physical weakness. As a result, the Meklars are the acknowledged masters of cybernetic interfaces and are able to control two additional factories per population above and beyond their normal technological limit. Also, Meklars also do not need to pay to refit factories for Robotic Control.^^Since Meklars can create powerful industries, Meklar players do not need to expand as quickly as the other races."),
	("mrrshan_desc", "The Mrrshans are descendants of very large hunting cats, and although they have in general been able to curb their aggressive impulses, the Mrrshans still retain a keen hunter nature. Their sheer ferocity and natural instincts make Mrrshans the best gunners in the universe. Mrrshan ships move first in most situations and add four levels to their attack rolls. Mrrshan ships equipped with multiple fire weapons can be particularly nasty.^^Like the Alkari, Mrrshan players should begin the game in an offensive posture and should attack their enemies almost immediately."),
	("psilon_desc", "The Psilons are a brilliant, unemotional race devoted solely to hard logic and the quest for knowledge. Their superior minds and research techniques allow them to gain a +50% bonus to all their research efforts. They can also select from a greater number of devices to research than other races.^^Psilon players should invest heavily in research, then guard their discoveries with high internal security. Technological advantages should be used as quickly as possible against more primitive races."),
	("sakkra_desc", "The Sakkra are a race of cold-blooded reptiles which are hatched from eggs like their dinosaur ancestors. Sakkras reproduce at twice the normal rate, and also get that reproduction bonus in addition to the benefits from Fertile or Gaia planets. They even receive the bonus when cloning.^^Sakkra players should never allow their planets to fill up. Their advantage is in their growth rate and they should constantly expand and create new colonies."),
	("silicoid_desc", "The Silicoids are a race of rock-beings. They are immune to the effects of waste and can land on star systems with any type of environment. Silicoids do not benefit from fertile or gaia environments. Due to their crystalline nature, Silicoid populations grow at only half the rate of other races.^^Even though the Silicoids already possess many of the planetology tech advantages, Silicoid players cannot ignore planetology altogether. Planetology is necessary to expand the size of planets, and the additional production bonus is always important."),
	("orion_desc", "Orion"),
	
	# MoO 2 Races
	("antaran_desc", "Antaran"),
	("elerian_desc", "The warrior castes of the Elerians are the only face most outsiders ever see. This humanoid society is matriarchal, and to date only females are allowed to join the military. Those who do are provided with the best possible training. Thus, Elerian ships gain a 20% defensive and 20% offensive bonus in combat. While the females fight, the all-male philosopher caste has developed incredible mental powers. Their meditations have produced remote knowledge of every system in the galaxy, and their telepathic powers are second to none. The Elerians' social structure is strengthened by a Feudal government in which only the warrior castes hold positions of power."),
	("gnolam_desc", "The Gnolams are a dwarf-like people from a Low-G home world whose society focuses almost exclusively on monetary gain as a measure of status. As a result, the Gnolams are Fantastic Traders, and thus receive greater benefit from trade treaties and higher than normal income from excess food and trade goods. The capitalistic nature of the Gnolam race is so intense that each unit of Gnolam population generates an additional 1 BC per turn. The Gnolams' Low-G roots put them at a 10% disadvantage in ground combat. To maximize the potential for profit, their government is a business-friendly Dictatorship. Somehow, these lucky creatures always manage to avoid the consequences of random natural disasters."),
	("trilarian_desc", "Trilarians are aquatic life forms. This race suffers none of the usual penalties associated with living on ocean and swamp worlds. In addition, there is a legend among the Trilarians that their race is descended from a long-lost Antaran colony. Regardless of whether there is any truth to this, this race has proven to be Trans-Dimensional. Even without the aid of FTL drives, Trilarian pilots can move their ships from star to star, though slowly. Ships with FTL drives move more quickly than they ordinarily would. The Trilarian government is a Dictatorship."),
	
	# MoO 4 (Not doing the ones from 3, lol)
	("terran_desc", "It was during the darkest times of human history that the Age of the Khans dawned. All over their homeworld civil unrest was mounting as society crumbled under the weight of deviancy, corruption and greed.^Mankind was poised to destroy itself in a tidal wave of chaos and despair when the First of the Khans rose to power. His callous rule was one of drastic measures, of cullings and purges. Castes were established, dissidents were hushed, and little by little the race was forced to survive.^Following his example, the Terran Khanate has continued to secure the survival of their species, and now seeks to guarantee its place in the galaxy for generations to come."),
	
	("reg1_credit", "{reg1} BC"),
	("stardate_reg1_reg2", "{reg1}.{reg2}"),	
]

strings.extend(generate_system_strings())

