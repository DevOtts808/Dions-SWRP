Aura_Quest = Aura_Quest or {}
Aura_Quest.QuestTypes = Aura_Quest.QuestTypes or {}

Aura_Quest.QuestTypes["Protect Quest"] =
{
	--[[-------------------------------------------------------------------------
	Don't touch these
	---------------------------------------------------------------------------]]
	protect = true, -- Set this flag to true if your quest involves protecting an NPC from enemies
	waitForQuestTrigger = true, -- We have to wait to spawn secondary entities till the trigger is called, which in this case is talking to the NPC
	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]
	
	-- Set the rewards to 0 instead of deleting them if you want to override them with another system
	rewards = 
	{
		money = 1500, -- Default DarkRP money
		wiltosXP = 0, -- XP for wiltOS
	},
	-- If you want to add custom rewards in this 
	customRewardFunction = function(self, ply)
		-- self is the quest which has all the quest data in it
		-- ply is the player who turned the quest in
		
	end,

	chance = 20, -- default is 33
	menuIcon = "aura_quest_protect_quest_icon.png",
	desc = "Ensure the safety of the target to earn your reward",

	primaryEntType = "Protection Targets", -- The name we see in the story quest config menu, in this case, ours is "Protection Targets" (ONLY CHANGE THIS WHEN IT IS NOT "Entities")
	secondaryEntType = "Hostile Entities", -- If we have a secondary entity that spawns for the quest, in this case, hostiles to protect the main target from, we set the name here as it is set below!
	secondaryNodeType = "Protect Quest Enemy Spawnpoint", -- The name of our secondary nodes quest type, important for parenting nodes

	questDialogue = -- This table will let us have dialogue options pop up during specific parts of our quest
	{
		-- There are three parts to a quest, listed below as the things in the []
		["Quest Start"] =  -- (Will open before the quest has been fully started for things like a protect quest)
		{
			title = -- What appears at the top of the text box when it opens as the NPCs dialogue
			{
				"Finally, my backup!",
				"Hey, I thought you clones worked fast!",
				"Took you long enough! Help me!",
			},
			options = -- A list of options to choose from in the dialogue box
			{
				{
					text = -- Can be just a string or a table of text to choose from for this option
					{
						"Sure, lets do it (Start Quest)",
						"Let's get down to business (Start Quest)",
						"Just leave it to me (Start Quest)",
					},
					-- This serverFunc simply just starts the spawning of secondary quest entities and marks our quest as "started" for dialogue purposes
					serverFunc = [[
						local ent = args[3][1]
						self.taggedForStart = false
						self.taggedQuestStarted = true
						Aura_CreateSecondaryQuestEntities(self, ply)
					]],
					closeMenu = true, -- If this option should close the menu, then this will be true
				},
			},
		},
		["Quest During"] =  -- (Will open while the quest is started and going on, example, enemies have started spawning for a protect quest)
		{ -- This is an example of a dialogue time where nothing happens, you give all the variables empty tables or nil/false values to make it empty
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
		["Quest Complete"] = -- (Will open after the quest objective has been completed, but the quest still hasn't been "completed", like in this case, a protect quest when all enemies are dead and the timer is up)
		{
			title = -- What appears at the top of the text box when it opens as the NPCs dialogue
			{
				"Thank you for aiding me in this fight!",
				"Couldn't have done it without you.",
				"Nice work out there!",
				"You sure saved my ass...",
			},
			options = -- A list of options to choose from in the dialogue box
			{
				{
					text = -- Can be just a string or a table of text to choose from for this option
					{
						"Yeah whatever, just give me my reward (Complete Quest)",
						"Any time (Complete Quest)",
						"Just doing my job (Complete Quest)",
					},
					-- The serverFunc variable is what happens when this option is clicked, it must be formatted EXACTLY how I have it if you make it a multiline string like this
					-- This is one of the more complicated config options, as you can write your code using a string, which allows it to be passed between client and server, though it is only ran serverside
					-- This can also be a table of tables like this one to allow for sub-options (AKA you click it and it opens more dialogue options, see example below)
					serverFunc = [[
						local ent = args[3][1]
						Aura_OnCompleteQuest(self, ply)

						ent:Remove()
					]],
					closeMenu = true, -- If this option should close the menu, then this will be true
				},
				{
					text =
					{
						"How did you end up in this scenario in the first place?"
					},
					
					serverFunc = [[]],
					-- This is an example of what it looks like to have sub-choices for a dialogue option
					subOptions = 
					{
						title =
						{
							"What, you never been caught in an ambush before?"
						},
						options = 
						{
							{
								text = {"Fair enough"},
								serverFunc = [[]], -- An example of nothing special happening when you click the button (Besides closing the dialogue box if you set it to)
								closeMenu = true, -- Close the menu after this is clicked
							}
						},
					},
					closeMenu = false, -- If you want the dialogue box to stay open (say if you have more options that come up) this should be false
				},
			},
		},
	},

	titlePresets =
	{	
		{
			prefix = "Ensure the safety of",
			suffix = "",
		},
		{
			prefix = "Protect",
			suffix = "",
		},
		{
			prefix = "Watch over",
			suffix = "",
		},
		{
			prefix = "Defend",
			suffix = "",
		},
		{
			prefix = "Safeguard",
			suffix = "",
		},
	},

	editables =
	{
		["Protection Targets"] =
		{
			{
				["Name"] = "Republic Navy officer",
				["Class"] = "npc_zombie",
				["Health"] = 250,
				["Scale"] = 1,
				["Weapon"] = "rw_sw_dc15s",
				["Weapon"] = "rw_sw_dc15s",
			},
		},
		["Hostile Entities"] = -- A list of potential enemies to spawn at each hostile node (THIS MUST MATCH secondaryEntType)
		{
			{
				["Name"] = "B1 Battle Droid",
				["Class"] = "npc_zombie_torso",
				["Health"] = 100,
				["Scale"] = 1,
			},
			{
				["Name"] = "BX Commando Droid",
				["Class"] = "npc_antlion",
				["Health"] = 100,
				["Scale"] = 1,
				["Weapon"] = "rw_sw_dc15s",
			},
			{
				["Name"] = "B2 Super Battle Droid",
				["Class"] = "npc_zombie",
				["Health"] = 100,
				["Scale"] = 1,
				["Weapon"] = "rw_sw_dc15s",
			},
		},
	},
	
	editableValues = -- Any custom values you want to be editable in the story quest menu
	{
		["Protection Time"] = 90, -- The amount of time enemies will spawn for, so if the wave count is 3 and the time is 15, there will be a wave every 5 seconds (15/3)
		["Spawn Number"] = 10, -- The number of hostile entities to spawn every "wave" (this number is multiplied by Aura_Quest.DifficultySpawnNumberMult)
		["Waves"] = 3, -- The total number of waves to spawn
	}
}

Aura_Quest.QuestTypes["Protect Quest Enemy Spawnpoint"] = -- This is an example of a "quest" type that isnt actually for quests, it is for setting nodes for these types (in this case, a node for a hostile to spawn at for a protection quest)
{
	nonRealQuest = true, -- Set this flag for any type you don't want as an option to set as in the story quest menu
	spawnPoint = true, -- Set this flag to true if you want this to be an enemy spawn point for protect quests
	questType = "Protect Quest", -- If this node is linked to another SPECIFIC node, then we need to define which one it is so we can give a button to get a random node of that quest type
	chance = 0, -- Set chance to 0 so that it is never picked for a random quest type, since technically it isn't a quest type (we just put it here for node purposes)
}