Aura_Quest = Aura_Quest or {}
Aura_Quest.QuestTypes = Aura_Quest.QuestTypes or {}

Aura_Quest.QuestTypes["Deliver Quest"] = 
{
	--[[-------------------------------------------------------------------------
	Don't touch these
	---------------------------------------------------------------------------]]
	pickup = true, -- Any quest where you have to interact with a prop to pick it up should have this flag
	deliver = true, -- Any quest to bring the item to another location
	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	multiNode = true, -- If you want a multistage quest to change its location after every "stage" then set this flag to true
	multiStage = 2, -- If a quest has multiple "stages" then this represents the amount of stages
	stageDifficultyScaling = 1, -- If you want the amount of stages to scale with the difficulty (so stages = stages + (difficulty * difficultyScaling))

	-- Set the rewards to 0 instead of deleting them if you want to override them with another system
	rewards = 
	{
		money = 300, -- Default DarkRP money
		wiltosXP = 180, -- XP for wiltOS
	},
	-- If you want to add custom rewards in this 
	customRewardFunction = function(self, ply)
		-- self is the quest which has all the quest data in it
		-- ply is the player who turned the quest in
		
	end,

	chance = 33, -- How likely the quest type is for being chosen when randomly generating a quest (Number are really arbitrary, higher is more chance compared to a type with a lower number)
	menuIcon = "aura_quest_deliver_quest_icon.png", -- Icon picture that shows in the icon quest menu layout
	desc = "Bring this item to the target to earn your reward.", -- The default description for this quest type
	secondaryEntType = "Destination Models", -- If we changed the name of the secondary entity type from the default, say what it is here

	-- Used for the dynamic titling system in the quest NPC menu
	titlePresets =
	{
		{
			prefix = "Deliver",
			suffix = "to the destination",
		},
		{
			prefix = "Bring",
			suffix = "safely to the drop point",
		},
		{
			prefix = "Collect",
			suffix = "and bring it to the objective",
		},
		{
			prefix = "Locate",
			suffix = "and deliver it to the designated point",
		},
	},

	editables = 
	{
		["Entities"] = 
		{
			{
				["Name"] = "Girl Scout Cookies",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_junk/cardboard_box001a.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
			{
				["Name"] = "Technological Components",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_junk/cardboard_box002a.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
			{
				["Name"] = "Food Shipment",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_junk/wood_crate001a.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
		},
		["Destination Models"] = -- A list of potential drop-off location models to spawn
		{
			{
				["Name"] = "Drop Point",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_wasteland/laundry_cart002.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
			{
				["Name"] = "Drop Point",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_junk/TrashDumpster01a.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
			{
				["Name"] = "Drop Point",
				["Class"] = "prop_physics",  -- Set to this if you want just a model to be spawned (but obviously set model to be what you want)
				["Model"] = "models/props_wasteland/laundry_cart001.mdl", -- This will be the model of the prop
				["Scale"] = 1,
			},
		},
	},
}

Aura_Quest.QuestTypes["Delivery Drop-off"] = -- You can rename this to something more appropriate, but the dropOff tag MUST remain that same name
{
	nonRealQuest = true, -- Set this flag for any type you don't want as an option to set as in the story quest menu
	dropOff = true, -- Set this flag to true if you want this to be a quest drop-off point (players go here for delivery quests)
	chance = 0, -- Set chance to 0 so that it is never picked for a random quest type, since technically it isn't a quest type (we just put it here for node purposes)
}