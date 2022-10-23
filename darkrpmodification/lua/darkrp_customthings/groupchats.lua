--[[---------------------------------------------------------------------------
Group chats
---------------------------------------------------------------------------
Team chat for when you have a certain job.
e.g. with the default police group chat, police officers, chiefs and mayors can
talk to one another through /g or team chat.

HOW TO MAKE A GROUP CHAT:
Simple method:
GAMEMODE:AddGroupChat(List of team variables separated by comma)

Advanced method:
GAMEMODE:AddGroupChat(a function with ply as argument that returns whether a random player is in one chat group)
This is for people who know how to script Lua.

---------------------------------------------------------------------------]]
-- Example: GAMEMODE:AddGroupChat(TEAM_MOB, TEAM_GANG)
-- Example: GAMEMODE:AddGroupChat(function(ply) return ply:isCP() end)

GAMEMODE:AddGroupChat(_501ST_ENLISTED, _501ST_MEDIC, _501st_ENG, HVY_NCO, HVY_OF, JET_NCO, JET_OF, _501ST_MJR, _501ST_EXO, _501ST_CO)
GAMEMODE:AddGroupChat(_212TH_ENLISTED, _212TH_MEDIC, GHOST_NCO, GHOST_OF, GHOST_MJR, AB_NCO, AB_OF, AB_MJR, _212TH_EXO, _212TH_CO)
GAMEMODE:AddGroupChat(CG_ENLISTED, CG_MEDIC, CG_ENG, CG_NCO, CG_OF, CG_MJR, CG_EXO, CG_CO)
GAMEMODE:AddGroupChat(AC_BG, AC_SG)
GAMEMODE:AddGroupChat(CIS_B1, CIS_B2, CIS_BX, CIS_BXS, CIS_BXH, CIS_TAC)