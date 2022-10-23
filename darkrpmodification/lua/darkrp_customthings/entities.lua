--[[---------------------------------------------------------------------------
DarkRP custom entities
---------------------------------------------------------------------------

This file contains your custom entities.
This file should also contain entities from DarkRP that you edited.

Note: If you want to edit a default DarkRP entity, first disable it in darkrp_config/disabled_defaults.lua
    Once you've done that, copy and paste the entity to this file and edit it.

The default entities can be found here:
https://github.com/FPtje/DarkRP/blob/master/gamemode/config/addentities.lua

For examples and explanation please visit this wiki page:
https://darkrp.miraheze.org/wiki/DarkRP:CustomEntityFields

Add entities under the following line:
---------------------------------------------------------------------------]]
DarkRP.createEntity("LAAT", {
    ent = "lfs_fb_laatigunship",
    cmd = "buyLAAT",
    model = "models/fisher/laat/laatspace.mdl",
    price = 500,
    max = 1,
    sortOrder = 1,
    allowed = {
        AC_BG,
        AC_SG,
        _212TH_CO, 
        _212TH_EXO, 
        AB_MJR, 
        AB_OF, 
        AB_NCO
    },
    category = "Air Vehicles",
})
DarkRP.createEntity("LAAT-C", {
    ent = "lunasflightschool_laatcgunship",
    cmd = "buyLAATC",
    model = "models/blu/laat_c.mdl",
    price = 500,
    max = 1,
    sortOrder = 2,
    allowed = {
        AC_BG,
        AC_SG,
        _212TH_CO, 
        _212TH_EXO, 
        AB_MJR,
        AB_OF,
        AB_NCO
    },
    category = "Air Vehicles",
})
DarkRP.createEntity("ARC-170", {
    ent = "lunasflightschool_arc170",
    cmd = "buyARC",
    model = "models/blu/arc170.mdl",
    price = 500,
    max = 1,
    sortOrder = 3,
    allowed = {
        AC_BG,
        AC_SG,
        _212TH_CO, 
        _212TH_EXO,
        AB_MJR,
        AB_OF,
        AB_NCO
    },
    category = "Air Vehicles",
})

DarkRP.createEntity("NBT-630", {
    ent = "lunasflightschool_nbt630",
    cmd = "buyNBT",
    model = "models/sweaw/ships/rep_ntb630_servius.mdl",
    price = 500,
    max = 1,
    sortOrder = 4,
    allowed = {
        AC_BG,
        AC_SG,
        _212TH_CO, 
        _212TH_EXO, 
        AB_MJR,
        AB_OF
    },
    category = "Air Vehicles",
})

DarkRP.createEntity("TX130", {
    ent = "lunasflightschool_iftx",
    cmd = "buyTX",
    model = "models/blu/iftx.mdl",
    price = 500,
    max = 1,
    sortOrder = 1,
    allowed = {
        _212TH_CO, 
        _212TH_EXO,
        GHOST_MJR, 
        GHOST_OF, 
        GHOST_NCO
    },
    category = "Ground Vehicles",
})
DarkRP.createEntity("ATTE", {
    ent = "lunasflightschool_atte",
    cmd = "buyATTE",
    model = "models/blu/atte.mdl",
    price = 500,
    max = 1,
    sortOrder = 2,
    allowed = {
        _212TH_CO, 
        _212TH_EXO,
        GHOST_MJR, 
        GHOST_OF
    },
    category = "Ground Vehicles",
})
DarkRP.createEntity("AV7", {
    ent = "lfs_av7",
    cmd = "buyAV7",
    model = "models/cannon_barrel/cannon_barrel.mdl",
    price = 500,
    max = 1,
    sortOrder = 3,
    allowed = {
        _212TH_CO, 
        _212TH_EXO,
        GHOST_MJR
    },
    category = "Ground Vehicles",
})
DarkRP.createEntity("BARC speeder", {
    ent = "heracles421_lfs_barc",
    cmd = "buyBARC",
    model = "models/barc/barc.mdl",
    price = 500,
    max = 1,
    sortOrder = 4,
    allowed = {
        AC_BG,
        AC_SG,
        _212TH_CO, 
        _212TH_EXO,
        GHOST_MJR, 
        GHOST_OF,
        GHOST_NCO
        
    },
    category = "Ground Vehicles",
})
DarkRP.createEntity("Jetpack", {
    ent = "sneakyjetpack",
    cmd = "buyJetpack",
    model = "sneakyjetpack",
    price = 500,
    max = 1,
    sortOrder = 1,
    allowed = {
        JET_NCO,
        JET_OF,
        AC_BG,
        AC_SG
    },
    category = "Equipment",
})
DarkRP.createEntity("Juggernaut Suit", {
    ent = "suit_juggernaut",
    cmd = "buyJugg",
    model = "models/moxfort/501st-juggernaut.mdl",
    price = 500,
    max = 1,
    sortOrder = 2,
    allowed = {
        HVY_NCO,
        HVY_OF,
        _501ST_MJR,
        _501ST_EXO,
        _501ST_CO
    },
    category = "Equipment",
})