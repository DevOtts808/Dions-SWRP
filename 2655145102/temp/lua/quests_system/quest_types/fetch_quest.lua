Aura_Quest = Aura_Quest or {}
Aura_Quest.QuestTypes = Aura_Quest.QuestTypes or {}

Aura_Quest.QuestTypes["Fetch Quest"] = 
{
	--[[-------------------------------------------------------------------------
	Don't touch these
	---------------------------------------------------------------------------]]
	pickup = true, -- Any quest where you have to interact with a prop to pick it up should have this flag
	returnItem = true, -- Any quest where you return the item to a quest NPC 
	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]
	
	multiNode = true, -- If you want a multistage quest to change its location after every "stage" then set this flag to true
	multiStage = 1, -- If a quest has multiple "stages" then this represents the amount of stages
	stageDifficultyScaling = 1, -- If you want the amount of stages to scale with the difficulty (so stages = stages + (difficulty * difficultyScaling))

	-- Set the rewards to 0 instead of deleting them if you want to override them with another system
	rewards = 
	{
		money = 200, -- Default DarkRP money
		wiltosXP = 150, -- XP for wiltOS
	},
	-- If you want to add custom rewards in this 
	customRewardFunction = function(self, ply)
		-- self is the quest which has all the quest data in it
		-- ply is the player who turned the quest in
		
	end,

	chance = 33,
	menuIcon = "aura_quest_fetch_quest_icon.png",
	desc = "Find this item and return it to a " .. Aura_Quest.NPCOverheadName .. " to earn your reward.",

	completeText = --  A list of random strings to say when we return the item to the NPC
	{
		"Thanks for getting this for me!",
		"Ah, you found it!",
		"Thank you for bringing this back!",
		"Nice work getting this to me!",
	},

	-- Used for the dynamic titling system, will choose randomly between thse options, so a title could be like "Retrieve the Golden Scepter of Swag and bring it to the quest giver"
	titlePresets =
	{
		{
			prefix = "Retrieve",
			suffix = "and bring it to the quest giver",
		},
		{
			prefix = "Fetch",
			suffix = "and bring it to the quest giver",
		},
		{
			prefix = "Return",
			suffix = "to the quest giver",
		},
		{
			prefix = "Locate and bring back",
			suffix = "to the quest giver",
		},
		{
			prefix = "Collect",
			suffix = "for the quest giver",
		},
	},

	editables = 
	{
		["Entities"] = 
		{
			{
				["Name"] = "Oil Delivery",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_borealis/bluebarrel001.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
			{
				["Name"] = "Water Barrel",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_borealis/bluebarrel001.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
			{
				["Name"] ="Liquid Anthrax",				
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_borealis/bluebarrel001.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
		},
	},

	questDialogue = -- This table will let us have dialogue options pop up during specific parts of our quest
	{
		-- There are three parts to a quest, listed below as the things in the []
		["Quest Start"] =  -- (Will open before the quest has been fully started for things like a protect quest)
		{
			title = {},
			options =
			{
				{
					text = 
					{},
					serverFunc = [[]],
					closeMenu = false,
				},
			},
		},
		["Quest During"] =  -- (Will open while the quest is started and going on, example, enemies have started spawning for a protect quest)
		{ -- This is an example of a dialogue time where nothing happens, you give all the variables empty tables or nil/false values to make it empty
			title = -- What appears at the top of the text box when it opens as the NPCs dialogue
			{
				"Why are you here? You still have more things to get for me",
				"It seems you don't have all the packages, please bring them to me before we talk",
			},
			options = -- A list of options to choose from in the dialogue box
			{
				{
					text = -- Can be just a string or a table of text to choose from for this option
					{
						"Alright, sorry",
						"Okay",
						"Will do",
					},
					-- The serverFunc variable is what happens when this option is clicked, it must be formatted EXACTLY how I have it if you make it a multiline string like this
					-- This is one of the more complicated config options, as you can write your code using a string, which allows it to be passed between client and server, though it is only ran serverside
					-- This can also be a table of tables like this one to allow for sub-options (AKA you click it and it opens more dialogue options, see example below)
					serverFunc = [[]],
					closeMenu = true, -- If this option should close the menu, then this will be true
				},
			},
		},
		["Quest Complete"] = -- (Will open after the quest objective has been completed, but the quest still hasn't been "completed", like in this case, a protect quest when all enemies are dead and the timer is up)
		{
			title = -- What appears at the top of the text box when it opens as the NPCs dialogue
			{
				"Ah, you've found all the materials",
				"I see you've returned with the goods",
				"Nice work, you have everything I need",
				"Great job finding everything",
			},
			options = -- A list of options to choose from in the dialogue box
			{
				{
					text = -- Can be just a string or a table of text to choose from for this option
					{
						"Yeah whatever, just give me my reward (Complete Quest)",
						"You know it (Complete Quest)",
						"Just doing my job (Complete Quest)",
					},
					-- The serverFunc variable is what happens when this option is clicked, it must be formatted EXACTLY how I have it if you make it a multiline string like this
					-- This is one of the more complicated config options, as you can write your code using a string, which allows it to be passed between client and server, though it is only ran serverside
					-- This can also be a table of tables like this one to allow for sub-options (AKA you click it and it opens more dialogue options, see example below)
					serverFunc = [[
						local ent = args[3][1]
						ent.willTriggerDialogue = false
						Aura_OnCompleteQuest(self, ply)
					]],
					closeMenu = true, -- If this option should close the menu, then this will be true
				},
			},
		},
	},
}