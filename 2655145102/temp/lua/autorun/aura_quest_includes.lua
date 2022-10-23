-- Do not change anything in here, this is our load order to make sure everything exists when it should

function Aura_Quest_IncludeClient(path)
    if SERVER then
        AddCSLuaFile(path)
    else
        include(path)
    end
    --print("File: " .. path .. " has been included clientside")
end

function Aura_Quest_IncludeServer(path)
    if SERVER then
        include(path)
        --print("File: " .. path .. " has been included serverside")
    end
end

function Aura_Quest_IncludeShared(path)
    Aura_Quest_IncludeServer(path)
    Aura_Quest_IncludeClient(path)
end

if (SERVER) then
    -- Don't worry, not a backdoor, just downloading the content for the addon
    -- http://steamcommunity.com/sharedfiles/filedetails/?id=2358067003
    -- That is the link if you don't believe me
    resource.AddWorkshop("2358067003")
end

Aura_Quest_IncludeClient("quests_system/client/aura_quest_language.lua")

Aura_Quest_IncludeClient("quests_system/client/aura_quest_fonts.lua")
Aura_Quest_IncludeClient("quests_system/client/aura_quest_player_pref.lua")

Aura_Quest_IncludeClient("quests_system/client/aura_cl_utils.lua")
Aura_Quest_IncludeClient("quests_system/vgui/cl_quest_wrapping_dlabel.lua")
Aura_Quest_IncludeClient("quests_system/vgui/cl_quest_player_pref_menu.lua")
Aura_Quest_IncludeClient("quests_system/vgui/cl_quest_npc_face_box.lua")
Aura_Quest_IncludeClient("quests_system/vgui/cl_quest_dialogue_box.lua")

Aura_Quest_IncludeShared("quests_system/aura_quests_config.lua")

Aura_Quest_IncludeShared("quests_system/aura_quests_util.lua")
-- Lets us get all quest menu layouts even if you add more
local questMenuLayouts, directories = file.Find( "lua/quests_system/vgui/quest_menu_layouts/*", "GAME" )
for k,v in pairs(questMenuLayouts) do
    Aura_Quest_IncludeClient("quests_system/vgui/quest_menu_layouts/" .. v)
end
Aura_Quest_IncludeServer("quests_system/server/aura_quest_spawning_handler.lua")
Aura_Quest_IncludeShared("quests_system/aura_quest_object.lua")
Aura_Quest_IncludeShared("quests_system/aura_quests_hooks.lua")
Aura_Quest_IncludeServer("permaprops/sv_specialfcn_aura_quest_locations.lua")

Aura_Quest_IncludeClient("quests_system/client/aura_quest_story_menu.lua")
Aura_Quest_IncludeClient("quests_system/client/aura_quest_ply_client.lua")
Aura_Quest_IncludeServer("quests_system/server/aura_quest_ply_server.lua")

if (CLIENT) then
    hook.Add( "OnScreenSizeChanged", "Aura_SetQuestFontSizesCorrectly", function( oldWidth, oldHeight )
        aura_scaleX = (ScrW() / 2560)
        aura_scaleY = (ScrH() / 1440)

        Aura_Quest_IncludeClient("quests_system/client/aura_quest_fonts.lua")
    end )
end