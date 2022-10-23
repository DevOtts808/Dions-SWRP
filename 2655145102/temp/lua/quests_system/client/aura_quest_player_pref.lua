-- Player preferences (Convars)
Aura_Quest = Aura_Quest or {}
Aura_Quest.Convars =
{
	["quest_main_color_dark"] =
	{
		t = "Color",
		name = "Main Background Color Scheme",
		default = "0 37 60 220",
		description = "The color for most of the menu backgrounds in this addon (Default: Dark Blue)",
	},
	["quest_border_color"] =
	{
		t = "Color",
		name = "Main Border Color",
		default = "255 255 255 255",
		description = "The color for all box borders in this addon (Default: White)",
	},
	["quest_main_text_color"] =
	{
		t = "Color",
		name = "Main Text Color",
		default = "255 255 255 255",
		description = "The color for most text in this addon (Default: White)",
	},
	["quest_desciption_title_text_color"] =
	{
		t = "Color",
		name = "Description Title Text Color",
		default = "94 94 244 255",
		description = "The color for description titles in this addon (Default: White)",
	},
	["quest_hud_x_pos"] =
	{
		t = "Number",
		name = "Quest HUD X Position",
		default = "15",
		description = "The position for the quest HUD along the x-axis (left and right)",
		dimension = "x",
	},
	["quest_hud_y_pos"] =
	{
		t = "Number",
		name = "Quest HUD Y Position",
		default = "15",
		description = "The position for the quest HUD along the y-axis (up and down)",
		dimension = "y",
	},
	["quest_npc_layout"] =
	{
		t = "Dropdown",
		name = "NPC Quest List Layout",
		default = "Original",
		description = "What the layout looks like when you view the quest list from the Quest Master",
		options =
		{
		},
	},
}

for k,v in pairs(Aura_Quest.Convars) do
	CreateClientConVar(k,v.default,true,false)
end