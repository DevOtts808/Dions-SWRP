Aura_Quest = Aura_Quest or {} -- No touch


-- This is the language settings, you can change them here to change what each text says according to the name
-- You only change the second part of the argument, so if you want to change one, do not replace the text with underscores in it, just the text after
-- Try to follow the general format of these if you change them, like if there is a space at the start or end, keep it, or a colon, ect

-- If you would like to change the text associated with prompts for specific quest types, you must edit the text in the quest types files found in aura_quest_system\lua\quests_system\quest_types
-- (The above point is done so that those specific lines are centralized, and not harder to find in this file)

-- The same principle applies to configuration settings, the names of the config settings can be set via the file aura_quest_system\lua\quests_system\client\aura_quest_player_pref.lua
-- Again, this is for centralization, as personally, to move those names somewhere else, when the preferences can be removed or added, obfuscates things in my opinion


--[[-------------------------------------------------------------------------
Errors
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_Something_Went_Wrong","Something went wrong, that quest does not exist, please notify staff.")
language.Add("Aura_Quest_Error_Spawning","Uh oh, something went wrong when spawning primary quest entities, please contact staff!")
language.Add("Aura_Quest_Error_SpawningSecondary","Uh oh, something went wrong when spawning secondary quest entities, please contact staff!")
language.Add("Aura_Quest_Error_NoSecondaryNodes","Uh oh, there are no secondary quest nodes set up for this quest type!, please contact staff!")
language.Add("Aura_Quest_Error_NoSecondaryNodesQuestType","Missing node quest type:")
language.Add("Aura_Quest_Error_NodeDoesNotExist","ERROR: Node does not exist to spawn entity at!")
language.Add("Aura_Quest_Error_NoValidNodeType","ERROR: Node type was not a valid type while spawning entities, aborting")

language.Add("Aura_Quest_Missing_Node","This quest has no node associated with it, please let staff know.")
language.Add("Aura_Quest_Choose_Another_Quest","Please choose another quest, sorry for the inconvenience.")

language.Add("Aura_Quest_Already_Done","Sorry, but you have already completed this quest")
language.Add("Aura_Quest_No_Permission","You do not have permission to use this command!")

language.Add("Aura_Quest_Not_Yours","This is not your quest item!")
language.Add("Aura_Quest_Not_Time","I should probably get the item to deliver first...") -- When the player tried to deliver an item they do not have


language.Add("Aura_Quest_FunctionDoesNotExist","Something went wrong, the function associated with this dialogue option does not exist")
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Quest announcements
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_Quest_Complete","Quest Complete:")
language.Add("Aura_Quest_Return","Return to an NPC to collect your reward!")
language.Add("Aura_Quest_Turned_In","Quest turned in:")
language.Add("Aura_Quest_Given_Up","You have given up quest:")
language.Add("Aura_Quest_Out_Of_Time","You have run out of time for your quest!")

language.Add("Aura_Quest_Reward_Gotten","Received")
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Debug mode
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_Debug_On","You have enabled quest debug mode")
language.Add("Aura_Quest_Debug_Off","You have disabled quest debug mode")
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Quest parts completed or failed
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_Target_Died","Your target has died! Quest failed:")
language.Add("Aura_Quest_Target_Safe","Target has been kept safe, talk to them to complete your quest")

language.Add("Aura_Quest_Objective_Destroyed","One of your quest objectives has been destroyed!")
language.Add("Aura_Quest_Objective_Deposited","deposited") -- This one should not be capitalized because it shows at the end of a sentence
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Misc
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_Node_No_Type","No Quest Type Set")
language.Add("Aura_Quest_Money_Symbol","$")
language.Add("Aura_Quest_wOS_XP","combat XP")
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Quest Menu
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_NonStoryQuests","Non-Story Quests")
language.Add("Aura_Quest_StoryQuests","Story Quests")
language.Add("Aura_Quest_AcceptQuest","Accept Quest")
language.Add("Aura_Quest_NeedsOtherQuests","Sorry, but you need to complete the following quests to take this quest:")
language.Add("Aura_Quest_QuestAlreadyCompleted","Sorry, but you have already completed this quest")
language.Add("Aura_Quest_StoryQuestAlreadyAccepted","You already have a story quest accepted!")
language.Add("Aura_Quest_AcceptStoryQuest","You have acquired a story quest!")
language.Add("Aura_Quest_NonStoryQuestAlreadyAccepted","You already have a non-story quest accepted!")
language.Add("Aura_Quest_AcceptNonStoryQuest","You have acquired a non-story quest!")
language.Add("Aura_Quest_Details","Details")
language.Add("Aura_Quest_Menu","Quest Menu")


language.Add("Aura_Quest_Quest_NPCWelcomeText","Hey there, what can I do for you today?")
language.Add("Aura_Quest_Quest_ViewAvailableOption","View available quests")
language.Add("Aura_Quest_Quest_TurnInOption","Turn in quests")
language.Add("Aura_Quest_Quest_AbandonOption","Abandon quests")


language.Add("Aura_Quest_Quest_Type","Quest Type")
language.Add("Aura_Quest_Quest_Description","Quest Description")
language.Add("Aura_Quest_Quest_Difficulty","Quest Difficulty")
language.Add("Aura_Quest_Quest_Rewards","Quest Reward(s)")


language.Add("Aura_Quest_Quest_Step","Quest Steps")
language.Add("Aura_Quest_Quest_TimeLimit","Time Limit (Seconds)")


language.Add("Aura_Quest_Quest_DifficultyWord","difficulty")


language.Add("Aura_Quest_Quest_NoQuestsToTurnIn","You do not have any quests to turn in!")


language.Add("Aura_Quest_Quest_TurnInPrompt","Which quest would you like to turn in?")
language.Add("Aura_Quest_Quest_TurnInQuestsPromt","Would you like to turn in just one quest, or all?")
language.Add("Aura_Quest_Quest_TurnInOneQuest","Just one")
language.Add("Aura_Quest_Quest_TurnInAllQuests","All")


language.Add("Aura_Quest_Quest_AbandonPrompt","What kind of quest would you like to abandon?")
language.Add("Aura_Quest_Quest_Story","Story")
language.Add("Aura_Quest_Quest_NonStory","Non-story")
language.Add("Aura_Quest_Quest_NoNonStoryQuests","You do not have an active non-story quest!")
language.Add("Aura_Quest_Quest_NoStoryQuests","You do not have an active story quest!")


Aura_Quest.CloseText = -- Chooses a random one from the list for what the "leave dialogue" buttons option will say
{
	"Sorry, nothing for now",
	"Nevermind",
	"Sorry, have to go now",
	"Talk to you later",
	"See ya",
}
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
Settings Menu
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_Settings_CurrentValue","Current Value:")
language.Add("Aura_Quest_Settings_DefaultValue","Default:")
language.Add("Aura_Quest_Settings_ResetValue","Reset to default")
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
HUD
---------------------------------------------------------------------------]]
language.Add("Aura_Quest_HUD_QuestStatus","- Quest Status -")
language.Add("Aura_Quest_HUD_QuestLevel","level") -- This word is lowercase because it is after a comma in the context of where it is used
language.Add("Aura_Quest_HUD_NonStory","(Non-Story)")
language.Add("Aura_Quest_HUD_NonStory","(Story)")
language.Add("Aura_Quest_HUD_MissingQuestObjective","Error: missing quest objective, notify staff!")
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]