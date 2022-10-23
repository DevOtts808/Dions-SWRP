Aura_Quest = Aura_Quest or {}
Aura_Quest.QuestTypes = Aura_Quest.QuestTypes or {}

Aura_Quest.QuestTypes["Kill Quest"] = -- This also acts as the "title" of the quest in the menu
{
	--[[-------------------------------------------------------------------------
	Don't touch these
	---------------------------------------------------------------------------]]
	kill = true, -- Any quest to kill an entity should have this flag
	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	-- Set the rewards to 0 instead of deleting them if you want to override them with another system
	rewards = 
	{
		money = 550, -- Default DarkRP money
		wiltosXP = 480, -- XP for wiltOS
	},
	-- If you want to add custom rewards in this 
	customRewardFunction = function(self, ply)
		-- self is the quest which has all the quest data in it
		-- ply is the player who turned the quest in
		
	end,

	menuIcon = "aura_quest_kill_quest_icon.png", -- The image to display in the quest menu when a quest of this type is shown
	chance = 33, -- The chance for this quest to be chosen, higher number is higher chance, does not have to equal 100 for all
	desc = "Slay the target to earn your reward.", -- The description as seen in the quest menu

	titlePresets = -- A list of "prefixs" to the titles of this type of quest, must work with the word "the" after them
	{
		{
			prefix = "Kill",
			suffix = "",
		},
		{
			prefix = "Defeat",
			suffix = "",
		},
		{
			prefix = "Slay",
			suffix = "",
		},
		{
			prefix = "Vanquish",
			suffix = "",
		},
		{
			prefix = "Put to rest",
			suffix = "",
		},
		{
			prefix = "Eliminate",
			suffix = "",
		},
	},

	editables = -- Anything in here will be seen in the story quest config menu to be changed
	{
		["Entities"] = -- A list of entities that can spawn at this location by default (can be adjusted in game later for each quest location if wanted) (Do not rename these variables though, it will break things)
		{
			{ -- Table should be set up like this for NPCs/enemies, HP will be scaled by difficulty as well
				["Name"] = "Sliced Zombie", -- This is the name that will be used to generate a title for the quest (Can also be a table to get a random name from)
				["Class"] = "npc_zombie_torso", -- Class, found in spawnmenu
				["Health"] = 100, -- Custom HP
				["Scale"] = 1, -- How big should the ents model be? (multiplier)
			},
			{
				["Name"] = "Sand Burrower",
				["Class"] = "npc_antlion",
				["Health"] = 100,
				["Scale"] = 1,
			},
			{
				["Name"] = "Undead",
				["Class"] = "npc_zombie",
				["Health"] = 100,
				["Scale"] = 1,
			},
		},
	}
}