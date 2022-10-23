--[[---------------------------------------------------------------------------
DarkRP custom jobs
---------------------------------------------------------------------------
This file contains your custom jobs.
This file should also contain jobs from DarkRP that you edited.

Note: If you want to edit a default DarkRP job, first disable it in darkrp_config/disabled_defaults.lua
      Once you've done that, copy and paste the job to this file and edit it.

The default jobs can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/jobrelated.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomJobFields

Add your custom jobs under the following line:
---------------------------------------------------------------------------]]

CLONE_CADET = DarkRP.createJob("Clone Cadet", {
    color = Color(110, 189, 46),
    model = "models/player/clone cadet/clonecadet.mdl",
    description = [[
        A brand new clone cadet.
    ]],
    weapons = {
        "rw_sw_trd_dc15s",
        "keys"
    },
    command = "cadet",
    max = 8,
    salary = 0,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Clone Troopers",
    canDemote = false,
    sortOrder = 1,
    PlayerSpawn = function(ply)
        ply:SetHealth(100)
        ply:SetMaxHealth(100)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

CLONE_TROOPER = DarkRP.createJob("Clone Trooper", {
    color = Color(255, 255, 255),
    model = "models/aussiwozzi/cgi/base/unassigned_trp.mdl",
    description = [[
        A newly trained clone trooper. Enlist in a regiment today!
    ]],
    weapons = {
        "rw_sw_dc15s",
		"rw_sw_dc17",
        "keys"
    },
    command = "CT",
    max = 8,
    salary = 20,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Clone Troopers",
    canDemote = false,
    sortOrder = 2,
    PlayerSpawn = function(ply)
        ply:SetHealth(200)
        ply:SetMaxHealth(200)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

CLONE_HEAVY = DarkRP.createJob("Clone Heavy", {
    color = Color(255, 255, 255),
    model = "models/aussiwozzi/cgi/base/unassigned_heavy.mdl",
    description = [[
        A newly trained clone trooper. Enlist in a regiment today!
    ]],
    weapons = {
        "rw_sw_dc15s",
        "rw_sw_dlt19",
        "rw_sw_nade_thermal",
		"rw_sw_dc17",
        "keys"
    },
    command = "CTHEAVY",
    max = 4,
    salary = 20,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Clone Troopers",
    canDemote = false,
    sortOrder = 3,
    PlayerSpawn = function(ply)
        ply:SetHealth(200)
        ply:SetMaxHealth(300)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
})

CLONE_SNIPER = DarkRP.createJob("Clone Sharpshooter", {
    color = Color(255, 255, 255),
    model = "models/aussiwozzi/cgi/base/unassigned_barc.mdl",
    description = [[
        A newly trained clone trooper. Enlist in a regiment today!
    ]],
    weapons = {
        "rw_sw_dc15s",
		"rw_sw_dc17ext",
		"rw_sw_dc15x",
		"realistic_hook",
        "keys"
    },
    command = "CTSHARP",
    max = 4,
    salary = 20,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Clone Troopers",
    canDemote = false,
    sortOrder = 4,
    PlayerSpawn = function(ply)
        ply:SetHealth(200)
        ply:SetMaxHealth(200)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

CLONE_DSGT = DarkRP.createJob("Drill Sergeant", {
    color = Color(255, 255, 255),
    model = "models/aussiwozzi/cgi/base/unassigned_arc.mdl",
    description = [[
        A leading clone trooper. Train new cadets, lead the unnasigned Clone Troopers and get them fit to join a regiment!
    ]],
    weapons = {
        "rw_sw_dc15s",
        "weapon_cuff_elastic",
		"rw_sw_stun_dc17",
		"weapon_officerboost_normal",
		"rw_sw_nade_thermal",
        "keys"
    },
    command = "DSGT",
    max = 2,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Clone Troopers",
    canDemote = false,
    sortOrder = 5,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end,
})

_212TH_ENLISTED = DarkRP.createJob("212th Enlisted", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_trooper.mdl",
    description = [[
        A shiny enlistee of the 212th attack battalion.
    ]],
    weapons = {
        "rw_sw_dc15s",
		"rw_sw_dc17",
		"rw_sw_pinglauncher",
        "keys"
    },
    command = "212thTRP",
    max = 8,
    salary = 40,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 1,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

_212TH_MEDIC = DarkRP.createJob("212th Medic", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_medic.mdl",
    description = [[
        A medic within the 212th attack battalion. Support your fellow troopers with healing and ammunition.
    ]],
    weapons = {
        "keys",
        "rw_sw_dc17ext",
        "weapon_bactanade",
        "rw_ammo_distributor",
        "weapon_bactainjector",
        "weapon_defibrilator",
        "rw_sw_pinglauncher",
        "rw_sw_dc15s"
    },
    command = "212thMED",
    max = 4,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 2,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

GHOST_NCO = DarkRP.createJob("212th Ghost NCO", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_ghost_company.mdl",
    description = [[
        Moving up in the ranks! A more experienced Non Commission Officer in the 212th attack battalion
    ]],
    weapons = {
        "rw_sw_dc15le_o",
        "keys",
        "rw_sw_dc17ext",
        "alydus_fortificationbuildertablet",
        "alydus_fusioncutter",
        "rw_sw_plx1"
    },
    command = "GHOSTNCO",
    max = 8,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 3,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end,
})

GHOST_OF = DarkRP.createJob("212th Ghost Officer", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_ghost_officer.mdl",
    description = [[
        A high ranking member of the 212th attack battalion. 
    ]],
    weapons = {
        "rw_sw_dc15le_o",
        "keys",
        "alydus_fortificationbuildertablet",
        "rw_sw_dc17ext",
        "rw_sw_plx1",
        "alydus_fusioncutter",
        "rw_sw_nade_thermal"
    },
    command = "GHOSTOF",
    max = 5,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 4,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
})

GHOST_MJR = DarkRP.createJob("212th Ghost Major", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_arc.mdl",
    description = [[
        The Major of the 212th attack battalion. 
    ]],
    weapons = {
        "keys",
        "rw_sw_rps4",
        "alydus_fortificationbuildertablet",
        "rw_sw_dc15le_o",
        "rw_sw_nade_thermal",
        "alydus_fusioncutter",
        "rw_sw_dual_dc17"
    },
    command = "GHOSTMJR",
    max = 1,
    salary = 90,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 5,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

AB_NCO = DarkRP.createJob("212th Airbourne NCO", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_pilot.mdl",
    description = [[
        Moving up in the ranks! A more experienced Non Commission Officer in the 212th attack battalion
    ]],
    weapons = {
        "rw_sw_dc15s",
        "rw_sw_pinglauncher",
        "keys",
        "rw_sw_dc17ext",
        "alydus_fusioncutter"
    },
    command = "ABNCO",
    max = 8,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 6,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end,
})

AB_OF = DarkRP.createJob("212th Airbourne Officer", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_pilot.mdl",
    description = [[
        A high ranking member of the 212th attack battalion. 
    ]],
    weapons = {
        "rw_sw_dc15s",
        "rw_sw_pinglauncher",
        "keys",
        "rw_sw_dc17ext",
        "alydus_fusioncutter"

    },
    command = "ABOF",
    max = 5,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 7,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
})

AB_MJR = DarkRP.createJob("212th Airbourne Major", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/2ndac_officer.mdl",
    description = [[
        The Major of the 212th attack battalion. 
    ]],
    weapons = {
        "keys",
        "rw_sw_dc15s",
        "alydus_fusioncutter",
        "rw_sw_dual_dc17",
        "rw_sw_pinglauncher",
    },
    command = "ABMJR",
    max = 1,
    salary = 90,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 8,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

_212TH_EXO = DarkRP.createJob("212th EXO Waxer", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_waxer.mdl",
    description = [[
        The Executive Officer of the 212th attack battalion. 
    ]],
    weapons = {
        "keys",
        "rw_sw_rps4",
        "rw_sw_dc15le_o",
        "holocomm",
        "rw_sw_nade_thermal",
        "alydus_fusioncutter",
        "rw_sw_dual_dc17ext"
    },
    command = "212thEXO",
    max = 1,
    salary = 90,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 9,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

_212TH_CO = DarkRP.createJob("212th Commander Cody", {
    color = Color(238, 161, 27),
    model = "models/aussiwozzi/cgi/base/212th_cody.mdl",
    description = [[
        The Commander of the 212th attack battalion. 
    ]],
    weapons = {
        "keys",
        "rw_sw_dc15le_o",
        "holocomm",
        "rw_sw_nade_thermal",
        "rw_sw_dual_dc17ext",
        "alydus_fusioncutter",
        "rw_sw_smartlauncher"
    },
    command = "212thCO",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "212th",
    canDemote = false,
    sortOrder = 10,
    PlayerSpawn = function(ply)
        ply:SetHealth(400)
        ply:SetMaxHealth(400)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

_501ST_ENLISTED = DarkRP.createJob("501st Enlisted", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_trooper.mdl",
    description = [[
        A Shiny 501st enlistee. Work your way up the ranks for better equipment!
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "keys",
        "rw_sw_dc17",
        "rw_sw_z6"
    },  
    command = "501stTRP",
    max = 8,
    salary = 40,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 1,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

_501ST_MEDIC = DarkRP.createJob("501st Medic", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_medic.mdl",
    description = [[
        A medic within the 501st Legion.
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "weapon_bactanade",
        "rw_ammo_distributor",
        "weapon_bactainjector",
        "weapon_defibrilator",
        "keys",
        "rw_sw_dc17",
        "rw_sw_z6"
    },
    command = "501stMED",
    max = 4,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 2,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

_501ST_ENG = DarkRP.createJob("501st Engineer", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_arf.mdl",
    description = [[
        501st support trooper..
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "alydus_fusioncutter",
        "defuse_kit",
        "alydus_fortificationbuildertablet",
        "keys",
        "rw_sw_dc17",
        "rw_sw_z6"
    },  
    command = "501stENG",
    max = 8,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 3,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

HVY_NCO = DarkRP.createJob("501st Heavy NCO", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_torrent.mdl",
    description = [[
        A newly inducted heavy trooper within the 501st legion.
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "rw_sw_nade_thermal",
        "keys",
        "rw_sw_dc17ext",
        "rw_sw_dp23",
        "rw_sw_z6"
    },
    command = "HVYNCO",
    max = 8,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 4,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end,
})

HVY_OF = DarkRP.createJob("501st Heavy Officer", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_officer.mdl",
    description = [[
        A high ranking heavy trooper in the 501st legion.
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "keys",
        "rw_sw_dual_dc17",
        "weapon_squadshield_arm",
        "weapon_officerboost_laststand",
        "rw_sw_dp23",
        "rw_sw_z6"
    },
    command = "HVYOF",
    max = 5,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 5,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
})

JET_NCO = DarkRP.createJob("501st Jet NCO", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_jet_trooper.mdl",
    description = [[
        A jet trooper belonging to the 501st legion.
    ]],
    weapons = {
        "rw_sw_dh17a",
        "keys",
        "rw_sw_dc15x",
        "rw_sw_nade_smoke",
        "rw_sw_dc15s"
    },
    command = "JETNCO",
    max = 4,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 6,
    PlayerSpawn = function(ply)
        ply:SetHealth(200)
        ply:SetMaxHealth(200)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

JET_OF = DarkRP.createJob("501st Jet Officer", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_jet_trooper.mdl",
    description = [[
        A jet trooper officer belonging to the 501st legion.
    ]],
    weapons = {
        "rw_sw_dual_dh17a",
        "keys",
        "weapon_officerboost_normal",
        "rw_sw_dc15x",
        "rw_sw_nade_smoke",
        "rw_sw_dc15s"
    },
    command = "JETOF",
    max = 4,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 7,
    PlayerSpawn = function(ply)
        ply:SetHealth(200)
        ply:SetMaxHealth(200)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end,
})

_501ST_MJR = DarkRP.createJob("501st Major Jesse", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_jesse.mdl",
    description = [[
        Major Jesse of the 501st Legion.
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "keys",
        "rw_sw_dual_dc17ext",
        "weapon_squadshield_arm",
        "weapon_officerboost_laststand",
        "realistic_hook",
        "rw_sw_dp23",
        "rw_sw_z6"
    },
    command = "501stMJR",
    max = 1,
    salary = 90,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 8,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

_501ST_EXO = DarkRP.createJob("501st EXO Appo", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_appo.mdl",
    description = [[
        Executive officer Appo of the 501st Legion.
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "keys",
        "rw_sw_dual_dc17ext",
        "weapon_squadshield_arm",
        "holocomm",
        "realistic_hook",
        "rw_sw_dp23",
        "weapon_officerboost_laststand",
        "rw_sw_z6"
    },
    command = "501stEXO",
    max = 1,
    salary = 90,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 9,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

_501ST_CO = DarkRP.createJob("501st Commander Rex", {
    color = Color(67, 83, 255),
    model = "models/aussiwozzi/cgi/base/501st_rex.mdl",
    description = [[
        Commander Rex of the 501st Legion.
    ]],
    weapons = {
        "rw_sw_dc15a_o",
        "keys",
        "holocomm",
        "rw_sw_dual_dc17ext",
        "weapon_squadshield_arm",
        "realistic_hook",
        "rw_sw_dp23",
        "weapon_officerboost_laststand",
        "rw_sw_z6"
    },
    command = "501stCO",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "501st",
    canDemote = false,
    sortOrder = 10,
    PlayerSpawn = function(ply)
        ply:SetHealth(400)
        ply:SetMaxHealth(400)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

CG_ENLISTED = DarkRP.createJob("CG Enlisted", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/CG_trooper.mdl",
    description = [[
        A newly enlisted shock trooper - securing the republic base and protecting key figures.
    ]],
    weapons = {
        "keys",
        "weapon_policeshield",
        "rw_sw_stun_dc15s",
        "weapon_cuff_elastic",
        "rw_sw_stun_dc17",
        "rw_sw_riotbaton"
    },
    command = "CGTRP",
    max = 8,
    salary = 40,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 1,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

CG_MEDIC = DarkRP.createJob("CG Medic", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/CG_medic.mdl",
    description = [[
        A newly enlisted shock trooper - securing the republic base and protecting key figures.
    ]],
    weapons = {
        "keys",
        "weapon_bactanade",
        "rw_ammo_distributor",
        "weapon_bactainjector",
        "weapon_defibrilator",
        "weapon_policeshield",
        "weapon_cuff_elastic",
        "rw_sw_stun_dc15s",
        "rw_sw_stun_dc17",
        "rw_sw_riotbaton"
    },
    command = "CGMED",
    max = 4,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 2,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

CG_ENG = DarkRP.createJob("CG Engineer", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/CG_tracker.mdl",
    description = [[
        501st support trooper..
    ]],
    weapons = {
        "weapon_cuff_elastic",
        "alydus_fusioncutter",
        "weapon_policeshield",
        "defuse_kit",
        "alydus_fortificationbuildertablet",
        "rw_sw_stun_dc15s",
        "rw_sw_stun_dc17",
        "rw_sw_riotbaton"
    },  
    command = "CGENG",
    max = 8,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 3,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(0)
        ply:SetMaxArmor(0)
    end,
})

CG_NCO = DarkRP.createJob("CG NCO", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/CG_officer.mdl",
    description = [[
        A non commissioned officer in the coruscaunt gaurd - securing the republic base and protecting key figures.
    ]],
    weapons = {
        "keys",
        "weapon_cuff_elastic",
        "weapon_policeshield",
        "rw_sw_stun_dc15s",
        "alydus_fortificationbuildertablet",
        "rw_sw_stun_dc17",
        "rw_sw_dp23",
        "rw_sw_riotbaton"
    },
    command = "CGNCO",
    max = 8,
    salary = 60,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 4,
    PlayerSpawn = function(ply)
        ply:SetHealth(300)
        ply:SetMaxHealth(300)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end,
})

CG_OF = DarkRP.createJob("CG Officer", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/cg_riot.mdl",
    description = [[
        An officer in the coruscaunt gaurd - securing the republic base and protecting key figures.
    ]],
    weapons = {
        "keys",
        "weapon_cuff_elastic",
        "weapon_policeshield",
        "rw_sw_stun_dc15s",
        "rw_sw_dual_dc17",
        "rw_sw_dp23",
        "rw_sw_riotbaton",
        "alydus_fortificationbuildertablet"
    },
    command = "CGOF",
    max = 4,
    salary = 80,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 5,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(100)
        ply:SetMaxArmor(100)
    end,
})

CG_MJR = DarkRP.createJob("CG Major", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/cg_jek.mdl",
    description = [[
        A major in the coruscaunt gaurd - securing the republic base and protecting key figures.
    ]],
    weapons = {
        "keys",
        "rw_sw_dc15a_o",
        "weapon_cuff_elastic",
        "weapon_policeshield",
        "rw_sw_stun_dc15s",
        "rw_sw_dual_dc17",
        "rw_sw_dp23",
        "rw_sw_riotbaton",
        "alydus_fortificationbuildertablet"
    },
    command = "CGMJR",
    max = 1,
    salary = 90,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 6,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

CG_EXO = DarkRP.createJob("CG EXO", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/cg_thorn.mdl",
    description = [[
        An executive officer in the coruscaunt gaurd - securing the republic base and protecting key figures.
    ]],
    weapons = {
        "keys",
        "weapon_policeshield",
        "rw_sw_dc15a_o",
        "weapon_cuff_elastic",
        "holocomm",
        "rw_sw_stun_dc15s",
        "rw_sw_dual_dc17ext",
        "rw_sw_dp23",
        "rw_sw_nade_stun",
        "rw_sw_riotbaton",
        "alydus_fortificationbuildertablet"
    },
    command = "CGEXO",
    max = 1,
    salary = 90,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 7,
    PlayerSpawn = function(ply)
        ply:SetHealth(350)
        ply:SetMaxHealth(350)
        ply:SetArmor(150)
        ply:SetMaxArmor(150)
    end,
})

CG_CO = DarkRP.createJob("CG Commander Fox", {
    color = Color(195, 9, 9),
    model = "models/aussiwozzi/cgi/base/cg_fox.mdl",
    description = [[
        An executive officer in the coruscaunt gaurd - securing the republic base and protecting key figures.
    ]],
    weapons = {
        "keys",
        "weapon_cuff_elastic",
        "rw_sw_dc15a_o",
        "weapon_policeshield",
        "holocomm",
        "rw_sw_stun_dc15s",
        "rw_sw_dual_dc17ext",
        "rw_sw_dp23",
        "rw_sw_nade_stun",
        "rw_sw_riotbaton",
        "alydus_fortificationbuildertablet",
        "weapon_officerboost_laststand"
    },
    command = "CGCO",
    max = 1,
    salary = 100,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CG",
    canDemote = false,
    sortOrder = 8,
    PlayerSpawn = function(ply)
        ply:SetHealth(400)
        ply:SetMaxHealth(400)
        ply:SetArmor(50)
        ply:SetMaxArmor(50)
    end,
})

AC_BG = DarkRP.createJob("Battalion General", {
    color = Color(75, 0, 0),
    model = {
        "models/aussiwozzi/cgi/base/rhc_2.mdl",
    },
    description = [[
        A Battalion General, assigned to specific regiments to oversee and assist their command.
    ]],
    weapons = {
        "keys",
        "weapon_cuff_elastic",
        "voice_amplifier",
        "holocomm",
        "weapon_bactanade",
        "weapon_bactainjector",
        "weapon_defibrilator",
        "rw_sw_dual_dc17s",
        "rw_sw_dlt19x",
        "rw_sw_westarm5",
        "alydus_fortificationbuildertablet"
    },
    command = "BG",
    max = 2,
    salary = 120,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Army Command",
    canDemote = false,
    sortOrder = 1,
    PlayerSpawn = function(ply)
        ply:SetHealth(400)
        ply:SetMaxHealth(400)
        ply:SetArmor(200)
        ply:SetMaxArmor(200)
    end,
})

AC_SG = DarkRP.createJob("Supreme General", {
    color = Color(75, 0, 0),
    model = {
        "models/aussiwozzi/cgi/base/rhc_1.mdl", 
    },
    description = [[
        The supreme General, Overseer of army command and operations.
    ]],
    weapons = {
        "keys",
        "weapon_cuff_elastic",
        "rw_sw_dual_dc17s",
        "voice_amplifier",
        "holocomm",
        "weapon_bactanade",
        "weapon_bactainjector",
        "weapon_defibrilator",
        "rw_sw_dlt19x",
        "rw_sw_westarm5",
        "rw_sw_rt97c",
        "alydus_fortificationbuildertablet"
    },
    command = "SG",
    max = 1,
    salary = 130,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "Army Command",
    canDemote = false,
    sortOrder = 2,
    PlayerSpawn = function(ply)
        ply:SetHealth(400)
        ply:SetMaxHealth(400)
        ply:SetArmor(200)
        ply:SetMaxArmor(200)
    end,
})

CIS_B1 = DarkRP.createJob("CIS B1 Droid", {
    color = Color(195, 9, 9),
    model = "models/b1_inf/pm_droid_b1_inf_pvt.mdl",
    description = [[
        A mass-produced B1 droid
    ]],
    weapons = {
        "keys",
        "rw_sw_e5"
    },
    command = "CISB1",
    max = 3,
    salary = 150,
    admin = 0,
    vote = false,
    hasLicense = false,
    category = "CIS",
    canDemote = false,
    sortOrder = 1,
    PlayerSpawn = function(ply)
        ply:SetHealth(1300)
        ply:SetMaxHealth(1300)
    end,
})
CIS_B2 = DarkRP.createJob("B2 Battle Droid", {
    color = Color(195, 9, 9),
    model = "models/b2_pvt/pm_droid_b2_pvt.mdl",
    description = [[
        A B2 super battle droid
    ]],
    weapons = {
        "keys",
        "rw_sw_b2rp_blaster",
        "rw_sw_b2rp_rocket"
    },
    command = "CISB2",
    max = 3,
    salary = 150,
    admin = 1,
    vote = false,
    hasLicense = false,
    category = "CIS",
    canDemote = false,
    sortOrder = 2,
    PlayerSpawn = function(ply)
        ply:SetHealth(2000)
        ply:SetMaxHealth(2000)
    end,
})

CIS_BX = DarkRP.createJob("BX Commando", {
    color = Color(195, 9, 9),
    model = "models/bx_captain/pm_droid_bx_captain.mdl",
    description = [[
        A formidable BX Commando droid
    ]],
    weapons = {
        "keys",
        "rw_sw_e5bx",
        "rw_sw_sg6"
    },
    command = "CISBX",
    max = 3,
    salary = 150,
    admin = 1,
    vote = false,
    hasLicense = false,
    category = "CIS",
    canDemote = false,
    sortOrder = 3,
    PlayerSpawn = function(ply)
        ply:SetHealth(2000)
        ply:SetMaxHealth(2000)
    end,
})
CIS_BXS = DarkRP.createJob("BX Commando Stalker", {
    color = Color(195, 9, 9),
    model = "models/bx_captain/pm_droid_bx_captain.mdl",
    description = [[
        A BX Commando droid built for long range enagement
    ]],
    weapons = {
        "keys",
        "rw_sw_e5s",
        "rw_sw_e5s_auto"
    },
    command = "CISBXS",
    max = 3,
    salary = 150,
    admin = 1,
    vote = false,
    hasLicense = false,
    category = "CIS",
    canDemote = false,
    sortOrder = 4,
    PlayerSpawn = function(ply)
        ply:SetHealth(1500)
        ply:SetMaxHealth(1500)
    end,
})
CIS_BXH = DarkRP.createJob("BX Commando Heavy", {
    color = Color(195, 9, 9),
    model = "models/bx_captain/pm_droid_bx_captain.mdl",
    description = [[
        A BX Commando droid built to handle heavier weaponary
    ]],
    weapons = {
        "keys",
        "rw_sw_z4",
        "rw_sw_sg6"
    },
    command = "CISBXH",
    max = 3,
    salary = 150,
    admin = 1,
    vote = false,
    hasLicense = false,
    category = "CIS",
    canDemote = false,
    sortOrder = 5,
    PlayerSpawn = function(ply)
        ply:SetHealth(2000)
        ply:SetMaxHealth(2000)
        ply:SetArmor(200)
        ply:SetMaxArmor(200)
    end,
})
CIS_TAC = DarkRP.createJob("CIS Tactical droid", {
    color = Color(195, 9, 9),
    model = {
        "models/super_tactical_kalani/pm_droid_tactical_kalani.mdl",
        "models/super_tactical_stuxnet/pm_droid_tactical_stuxnet.mdl",
        "models/tactical_black/pm_droid_tactical_black.mdl",
        "models/tactical_blue/pm_droid_tactical_blue.mdl",
        "models/tactical_gold/pm_droid_tactical_gold.mdl",
        "models/tactical_purple/pm_droid_tactical_purple.mdl",
        "models/tactical_red/pm_droid_tactical_red.mdl"
    },
    description = [[
        A CIS tactical droid
    ]],
    weapons = {
        "keys",
        "rw_sw_e5"
    },
    command = "CISTAC",
    max = 3,
    salary = 150,
    admin = 1,
    vote = false,
    hasLicense = false,
    category = "CIS",
    canDemote = false,
    sortOrder = 6,
    PlayerSpawn = function(ply)
        ply:SetHealth(3000)
        ply:SetMaxHealth(3000)
    end,
})

hehe cool edit :)
--[[---------------------------------------------------------------------------
Define which team joining players spawn into and what team you change to if demoted
---------------------------------------------------------------------------]]
GAMEMODE.DefaultTeam = CLONE_CADET
--[[---------------------------------------------------------------------------
Define which teams belong to civil protection
Civil protection can set warrants, make people wanted and do some other police related things
---------------------------------------------------------------------------]]
GAMEMODE.CivilProtection = {
    [TEAM_POLICE] = true,
    [TEAM_CHIEF] = true,
    [TEAM_MAYOR] = true,
}
--[[---------------------------------------------------------------------------
Jobs that are hitmen (enables the hitman menu)
---------------------------------------------------------------------------]]
DarkRP.addHitmanTeam(TEAM_MOB)
