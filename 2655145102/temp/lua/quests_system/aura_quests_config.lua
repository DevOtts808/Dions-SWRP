Aura_Quest = Aura_Quest or {}


Aura_Quest.AdminPrivilages = -- Who can edit quest location settings
{
	["superadmin"] = true,
	["admin"] = true
}

Aura_Quest.StoryQuestPrivilages = -- Who can add, edit, or remove story quests
{
	["superadmin"] = true,
}


Aura_Quest.SaveEntDataOnRemoved = true -- If this is true then we save Story quest entity data when the map is cleaned up, and when the player disconnects (for a time limit set below)

Aura_Quest.StoryQuestCommand = "!qs" -- Opens the menu to add, remove, or edit story quests, capitalization does not matter (players with StoryQuestPrivilages ULX ranks can use)
Aura_Quest.DebugCommand = "!questDebug" -- Quest debug command mode, capitalization does not matter (players with AdminPrivilages ULX ranks can use)
Aura_Quest.DefaultEntitySpawnRange = 50 -- The default range for quest nodes to spawn entities at (Can be set in the edit properties menu of each node)

Aura_Quest.QuestsAvailableMin = 15 -- The max amount of random quests to be made when quests refresh
Aura_Quest.QuestsAvailableMax = 40 -- The max amount of random quests to be made when quests refresh
Aura_Quest.QuestRefreshTime = 180 -- The amount of time in seconds for quests to refresh
Aura_Quest.NPCDeath = false -- Will Quest NPCs be killed when shot at
Aura_Quest.NPCModel = "models/odessa.mdl" -- The model for the quest NPC
Aura_Quest.NPCOverheadName = "Quest Master" -- The name that shows over the quest NPCs head

Aura_Quest.MaxRandomDifficulty = 5 -- Highest level difficulty that can be randomly generated
Aura_Quest.DifficultyToTime = 120 -- Time in seconds to complete quest PER level of difficulty (level 1 difficulty is 120 seconds, level 2 is 240, ect) (Keep in mind your map size here, as a bigger map needs more time for players to get to the objective)
Aura_Quest.RewardMult = 1 -- Multiplier for the reward per level of difficulty (Total Reward = difficulty * mult * reward) (Set to 0 for no multiplier)
Aura_Quest.DifficultyHealthMult = 1 -- Multiplier for the HP of enemies for kill quests based on difficulty (Total HP = hp * difficulty * mult) (Set to 0 for no multiplier)
Aura_Quest.DifficultySpawnNumberMult = 1 -- Multiplier for the number of enemies that will spawn during quests that spawn multiple enemies (Example: Protection quest) (Total enemies = enemies * difficulty * mult) (set to 0 for no multiplier)

Aura_Quest.FolderName = "aura_quest_data" -- The name of the folder we want to store our data in (if you change this it will reset data unless you copy/paste it over)\
Aura_Quest.StoryFolderName = "story_quests" -- The name of the folder that we will store all of the story quest data in

--[[-------------------------------------------------------------------------
Quest types are complicated, I recommened you just don't mess with them at all, its hard to make 
such an opened concept so specific and work for a "base", so please, if you do make a new category or edit one
read EVERY comment related to them

THESE ARE THE DEFAULT QUEST TYPES, PLEASE READ ALL COMMENTS RELATED TO THEM BEFORE DOING
ANY CONFIGURING WITH THEM, OTHERWISE IT WILL (most likely) NOT WORK PROPERLY IF YOU DO IT WRONG

IMPORTANT THINGS TO NOTE:
IF YOU HAVE **ANYTHING** IN THE editables TABLE, MAKE SURE IT HAS A TWO-SUBTABLE STRUCTURE
EXAMPLE:

editables = 
{
	["Name of editable category"] =
	{
		["Editable value 1"] = "Bruh",
		["Edtiable value 2"] = "Bruh Again",
	}
}

ADDITIONALLY, ALL editables TABLES MUST HAVE AT LEAST ONE "THING" IN ITS DATA
AKA ONE ENTITY, ONE MODEL, ONE OF WHATEVER YOUR CATEGORY IS FOR **EACH** CATEGORY
THAT DOES MEAN YES, YOU CAN HAVE MORE THAN ONE CATEGORY OF STUFF (if you write a custom quest type at least)

Literally if you want to define a custom quest type, I suggest you just "redesign" and existing quest type, and keep the base objectives and such, just changing visual stuff, otherwise
you will find there is a whole lot to integrate lol, I can't design a perfectly fluid quest system cause, as you know, things have to be coded to make them work
---------------------------------------------------------------------------]]
Aura_Quest.QuestTypes = -- These are all filled in through each types respective file, done to make things a lot less cluttered
{
}

--[[-------------------------------------------------------------------------
Do not touch this section below, this is to ensure that if you save the config file that it won't delete all quest types in server data
---------------------------------------------------------------------------]]
-- Lets us get all quest types even if you add more
local questTypes, directories = file.Find( "lua/quests_system/quest_types/*", "GAME" )
for k,v in pairs(questTypes) do
    Aura_Quest_IncludeShared("quests_system/quest_types/" .. v)
end
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]