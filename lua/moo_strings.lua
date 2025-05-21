NUM_PLAYABLE_RACES = 14

function create_race_lookup()
    playable_race_name_lookup = {}
    for id, name in ipairs(playable_race_names) do
        playable_race_name_lookup[name] = id
    end
end

function playable_race_id(race_name)
    -- Check if the lookup table exists, and create it if it doesn't
    if playable_race_name_lookup == nil then
        create_race_lookup()
    end
    -- Return the ID for the given race name, or default to 1
    return playable_race_name_lookup[race_name] or 1
end

playable_race_names = {"Alkari", "Bulrathi", "Darlock", "Human", "Klackon", "Meklar", "Mrrshan", "Psilon", "Sakkra", "Silicoid", "Elerian", "Gnolam", "Trilarian", "Terran"}

alkari_leader_names = {"Farseer", "Skylord", "Ariel", "Redwing", "Highsoar", "Sharpclaw", "Ariel", "Heggira", "Tavua Preet", "Tak Tochno", "Saguaro Ty", "Peerik Kree", "Voreet Zry", "Karaaw Hrik"}
bulrathi_leader_names = {"Grunk", "Bullux", "Krungo", "Monch", "Durpp", "Smurch", "Trebakka", "Mazurek", "Uzor", "Grorvog", "Krorvog", "Balrokzor", "Smurch", "Monch"}
darlock_leader_names = {"Ssithra", "Nazgur", "Darquan", "Morfane", "Shador", "Narzina", "Narzina", "Vale", "Ember", "Greymoran", "Mysvaleer", "Shador", "Morfane", "Darquan"}
human_leader_names = {"Durash IV", "Alexander", "Strader", "Johann III", "Lasitus", "Bladrov II", "Durash IV", "Strader", "Reid", "Alexander", "Bladrov II", "Lasitus", "Caesar", "Sargon"}
klackon_leader_names = {"Ixitixl", "K'kalak", "Kikitik", "Xantak", "Kaxal", "Klaquan", "Ixitixl", "Ezixl", "Virzixl", "Kaviq", "Qurtirqul", "K'kalak", "Kikitik", "Kaxal",}
meklar_leader_names = {"M5-35", "TX-1138", "CB-715", "QX-537", "INT-986", "TVC-15", "QX-537", "THX-1137", "CZK-21", "Cog Primus", "911-C4S", "M3-850T", "INT-986", "RSW-242", }
mrrshan_leader_names = {"Prrsha", "Miamar", "Mirana", "Shandra", "Jasana", "Yalara", "Darquan", "Miamar", "Fargul", "Parasha Vrrn", "Harrava Ril", "Yarrala Hrrsh", "Torfang", "Marupa",}
psilon_leader_names = {"Tachaon", "Quark", "Meson", "Kelvan", "Dynalon", "Zygot", "Psiros", "Amios", "Tssha", "Erga", "Uticus", "Menz", "Agitat", "Ekar", "Orgit", "Kelvan", "Dynalon", }
sakkra_leader_names = {"Hissa", "Kryssta", "Sauron", "Tyranid",  "Guanar", "Saurak", "Seurak", "Tyran", "Dactylus", "Guanar", "Sarezaear", "Ragazor", "Hissa", "Sauron", }
silicoid_leader_names = {"Igneous", "Crystous", "Geode", "Carnax", "Sedimin", "Granid", "Crystous", "Sandebar", "Igneus Maximus", "Quorzom", "Krakatoa", "Vorkronoa", "Geode", "Sedimin"}
elerian_leader_names = {"Fireblade", "Greywind", "Laurel", "Erethia", "Yarasi", "Myranmar", "Berylia", "Ellowyn",}
gnolam_leader_names = {"Dolgran", "Trant", "Vex", "Trorn", "Bortis", "Gnorm", "Navolok", "Volm",}
trilarian_leader_names = {"Aquailis", "Klirr", "Cress", "Everial", "Oraborus", "Llorian", "Wavya", "Calibar"}
terran_leader_names = {"Khoan", "Caesar", "Nobunaga", "Kissinger", "Montezuma", "Cortez"}
default_names = {"Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu", "Nu", "Xi", "Omicron", "Pi"}

RaceNameLists = {
    ["Alkari"] = alkari_leader_names,
    ["Bulrathi"] = bulrathi_leader_names,
    ["Darlock"] = darlock_leader_names,
    ["Human"] = human_leader_names,
    ["Klackon"] = klackon_leader_names,
    ["Meklar"] = meklar_leader_names,
    ["Mrrshan"] = mrrshan_leader_names,
    ["Psilon"] = psilon_leader_names,
    ["Sakkra"] = sakkra_leader_names,
    ["Silicoid"] = silicoid_leader_names,
    ["Elerian"] = elerian_leader_names,
    ["Gnolam"] = gnolam_leader_names,
    ["Trilarian"] = trilarian_leader_names,
    ["Terran"] = terran_leader_names,
    ["Default"] = default_names,
}

honorific_leader = {"Skylord", "Emperor", "Hindmost", "President", "Queen", "Overseer", "Empress", "Controller", "Hierarch", "Keystone", "Grand Marshal", "Commodore", "Stinger", "Khan"}


default_homeworld_names = { "Altair", "Ursa", "Nazin", "Sol", "Kholdan", "Meklon", "Fierias", "Mentar", "Sssla", "Cryslon", "Draconis", "Gnol", "Trilar", "Alpha Ceti"}
system_names = {
	"Paranar", "Denubius", "Draconis", "Zoctan", "Rigel", "Talas", "Moro", "Quayal", "Neptunus",
    "Jinga", "Argus", "Escalon", "Berel", "Collassa", "Whynil", "Nordia", "Tau Cygni", "Phyco", "Firma",
    "Keeta", "Arietis", "Rhilus", "Willow", "Mu Delphi", "Stalaz", "Gorra", "Beta Ceti", "Spica", "Omicron",
    "Rha", "Kailis", "Vulcan", "Centauri", "Herculis", "Endoria", "Kulthos", "Hyboria", "Zhardan", "Yarrow",
    "Incedius", "Paladia", "Romulas", "Galos", "Uxmai", "Thrax", "Laan", "Imra", "Selia", "Seidon",
    "Tao", "Rana", "Vox", "Maalor", "Xudax", "Helos", "Crypto", "Gion", "Phantos", "Reticuli",
    "Maretta", "Toranor", "Exis", "Tyr", "Ajax", "Obaca", "Dolz", "Drakka", "Ryoun", "Vega",
    "Anraq", "Gienah", "Rotan", "Proxima", "Mobas", "Iranha", "Celtsi", "Dunatis", "Morrig", "Primodius",
    "Nyarl", "Ukko", "Crius", "Hyades", "Kronos", "Guradas", "Rayden", "Kakata", "Misha", "Xendalla",
    "Artemis", "Aurora", "Proteus", "Esper", "Darrian", "Trax", "Xengara", "Nitzer", "Simius", "Bootis",
    "Pollus", "Cygni", "Aquilae", "Volantis", "Tauri", "Regulus", "Klystron", "Lyae", "Capella", "Alcor"
}
