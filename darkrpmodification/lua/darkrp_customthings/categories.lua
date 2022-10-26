--[[-----------------------------------------------------------------------
Categories
---------------------------------------------------------------------------
The categories of the default F4 menu.

Please read this page for more information:
https://darkrp.miraheze.org/wiki/DarkRP:Categories

In case that page can't be reached, here's an example with explanation:

DarkRP.createCategory{
    name = "Citizens", -- The name of the category.
    categorises = "jobs", -- What it categorises. MUST be one of "jobs", "entities", "shipments", "weapons", "vehicles", "ammo".
    startExpanded = true, -- Whether the category is expanded when you open the F4 menu.
    color = Color(0, 107, 0, 255), -- The color of the category header.
    canSee = function(ply) return true end, -- OPTIONAL: whether the player can see this category AND EVERYTHING IN IT.
    sortOrder = 100, -- OPTIONAL: With this you can decide where your category is. Low numbers to put it on top, high numbers to put it on the bottom. It's 100 by default.
}


Add new categories under the next line!
---------------------------------------------------------------------------]]

DarkRP.createCategory {
    name = "Clone Troopers",
    categorises = "jobs",
    startExpanded = false,
    color = Color(255, 255, 255),
    sortOrder = 1,
}
DarkRP.createCategory {
    name = "501st",
    categorises = "jobs",
    startExpanded = true,
    color = Color(27, 52, 238),
    sortOrder = 2,
}
DarkRP.createCategory {
    name = "212th",
    categorises = "jobs",
    startExpanded = true,
    color = Color(238, 161, 27),
    sortOrder = 3,
}
DarkRP.createCategory {
    name = "CG",
    categorises = "jobs",
    startExpanded = false,
    color = Color(195, 9, 9),
    sortOrder = 4,
}
DarkRP.createCategory {
    name = "Army Command",
    categorises = "jobs",
    startExpanded = true,
    color = Color(75, 0, 0),
    sortOrder = 7,
}
DarkRP.createCategory {
    name = "Criminals",
    categorises = "jobs",
    startExpanded = false,
    color = Color(195, 9, 9),
    sortOrder = 8,
}
DarkRP.createCategory {
    name = "CIS",
    categorises = "jobs",
    startExpanded = false,
    color = Color(195, 9, 9),
    sortOrder = 9,
}
DarkRP.createCategory {
    name = "Air Vehicles",
    categorises = "entities",
    startExpanded = true,
    color = Color(250, 0, 0),
    sortOrder = 1,
    canSee = function(ply) 
         return table.HasValue({AC_BG, AC_SG, _212TH_CO, _212TH_EXO, AB_MJR, AB_OF, AB_NCO}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Ground Vehicles",
    categorises = "entities",
    startExpanded = true,
    color = Color(250, 0, 0),
    sortOrder = 2,
    canSee = function(ply) 
         return table.HasValue({AC_BG, AC_SG, _212TH_CO, _212TH_EXO, GHOST_MJR, GHOST_OF, GHOST_NCO}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Equipment",
    categorises = "entities",
    startExpanded = true,
    color = Color(250, 0, 0),
    sortOrder = 3,
    canSee = function(ply) 
         return table.HasValue({_501ST_JET, _501ST_JETOF}, ply:Team()) 
    end,
}
DarkRP.createCategory {
    name = "Drugs",
    categorises = "entities",
    startExpanded = true,
    color = Color(250, 0, 0),
    sortOrder = 4,
    canSee = function(ply) 
         return table.HasValue({CRIM_DRUG}, ply:Team()) 
    end,
}