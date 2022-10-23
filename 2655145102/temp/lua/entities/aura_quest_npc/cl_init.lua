include("shared.lua")

Aura_Quest = Aura_Quest or {}


function ENT:Initialize()
	self.modelBoundsMin, self.modelBoundsMax = self:GetModelBounds()
	Aura_Quest.QuestNPCs[self:GetNodeID()] = self
end

function ENT:OnRemove()
	if (self.GetPermaPropRemoval and self:GetPermaPropRemoval()) then return end
    Aura_Quest.QuestNPCs[self:GetNodeID()] = nil
end

ENT.RenderGroup = RENDERGROUP_BOTH

aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)

net.Receive("Aura_Open_Quest_Menu", function()
	LocalPlayer().questData = net.ReadTable()
	LocalPlayer().currentQuestNPC = net.ReadEntity()
	Aura_Sync_Story_Quests()
	Aura_Populate_NPC_Table()

	aura_scaleX = (ScrW() / 2560)
	aura_scaleY = (ScrH() / 1440)

	Aura_DrawQuestsDialogueBox(LocalPlayer().currentQuestNPC)
end)

function Aura_DrawQuestsDialogueBox(ent)
	local dialogueBox, titleText, optionsScroller = Aura_DrawNPCDialogueBase(ent)

	local options =
	{
		{ text = language.GetPhrase("Aura_Quest_Quest_ViewAvailableOption"), func = Aura_DrawQuestListMenu, closeMenu = true },
		{ text = language.GetPhrase("Aura_Quest_Quest_TurnInOption"), func = Aura_DrawTurnInQuestMenu, closeMenu = false },
		{ text = language.GetPhrase("Aura_Quest_Quest_AbandonOption"), func = Aura_DrawAbandonQuestMenu, closeMenu = false },
	}

	dialogueBox:PopulateDialogueBox(language.GetPhrase("Aura_Quest_Quest_NPCWelcomeText"), options, .75, .2)

end

function Aura_DrawQuestListMenu()
	if (LocalPlayer().questMenuOpen) then return end
	LocalPlayer().questMenuOpen = true

	local questListFunc = Aura_Quest.Convars["quest_npc_layout"].options[GetConVarString("quest_npc_layout")]
	local questListMenu = questListFunc()

	if (questListMenu and IsValid(questListMenu)) then
		function questListMenu:OnRemove()
			LocalPlayer().questMenuOpen = false
		end
	end
end

function Aura_DrawAbandonQuestMenu(dialogueBox)
	local title = {language.GetPhrase("Aura_Quest_Quest_AbandonPrompt")}
	local options =
	{
		{
			text = {language.GetPhrase("Aura_Quest_Quest_Story")},
		 	func = function()
				if (LocalPlayer().questData == nil) then
					LocalPlayer().questData = {}
				end
				local questData = LocalPlayer().questData["Story"]

				if (questData) then
					net.Start("Aura_Abandon_Quest")
					net.WriteTable(questData)
					net.SendToServer()
					LocalPlayer().questData["Story"] = false
				else
					LocalPlayer():ChatPrint("#Aura_Quest_Quest_NoStoryQuests")
				end
			end,
			closeMenu = true,
		},
		{
			text = {language.GetPhrase("Aura_Quest_Quest_NonStory")},
			func = function()
				if (LocalPlayer().questData == nil) then
					LocalPlayer().questData = {}
				end
				local questData = LocalPlayer().questData["NonStory"]

				if (questData) then
					net.Start("Aura_Abandon_Quest")
					net.WriteTable(questData)
					net.SendToServer()
					LocalPlayer().questData["NonStory"] = false
				else
					LocalPlayer():ChatPrint("#Aura_Quest_Quest_NoNonStoryQuests")
				end
			end,
			closeMenu = true,
		},
	}
	dialogueBox:PopulateDialogueBox(title, options, .5, .2)
end

function Aura_DrawTurnInQuestMenu(dialogueBox)
	title = {language.GetPhrase("Aura_Quest_Quest_TurnInQuestsPromt")}
	local options =
	{
		{
			text = {language.GetPhrase("Aura_Quest_Quest_TurnInOneQuest")},
			func = function()
				if (LocalPlayer().questData == nil) then
					LocalPlayer().questData = {}
				end
				local rewards = LocalPlayer().questData["Rewards"]

				Aura_DrawAllQuestRewards(dialogueBox, rewards)
			end,
			closeMenu = false
		},
		{
			text = {language.GetPhrase("Aura_Quest_Quest_TurnInAllQuests")}, 
			func = function()
				if (LocalPlayer().questData == nil) then
					LocalPlayer().questData = {}
				end
				local rewards = LocalPlayer().questData["Rewards"]

				if (rewards and #rewards > 0) then
					net.Start("Aura_Turn_In_Quest")
					net.WriteBool(false)
					net.SendToServer()
				else
					LocalPlayer():ChatPrint("#Aura_Quest_Quest_NoQuestsToTurnIn")
				end

				
			end, 
			closeMenu = true,
		},
	}
	dialogueBox:PopulateDialogueBox(title, options, .5, .2)

end

function Aura_DrawAllQuestRewards(dialogueBox, rewards)
	title = {language.GetPhrase("Aura_Quest_Quest_TurnInPrompt")}
	local options = {}
	if (rewards) then
		if (!table.IsEmpty(rewards)) then
			for k,v in pairs(rewards) do
				local name = v.type .. ", " .. language.GetPhrase("Aura_Quest_Quest_DifficultyWord") .. " " .. v.difficulty
				if (v.story) then
					name = v.title
				end
				local tbl = {}

				tbl.text = {name}

				tbl.func = function()
					net.Start("Aura_Turn_In_Quest")
					net.WriteBool(true)
					net.WriteInt(k,32)
					net.SendToServer()
				end

				tbl.closeMenu = true
				table.insert(options,tbl)
			end
		end
	end

	dialogueBox:PopulateDialogueBox(title, options, .5, .2)
end

local desctiptionLittleFont = "QuestFontQuestDescriptionBody"
local desctiptionTitleFont = "QuestFontQuestDescriptionTitle"

local function Aura_Quest_AddToDetailsTable(tbl, text, font, col)
	table.insert(tbl,{text = text, font = font, col = col})
end

function Aura_QuestGetDescription(quest)

	local mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))
	local titleTextColor = string.ToColor(GetConVarString("quest_desciption_title_text_color"))

	local details = {}

	Aura_Quest_AddToDetailsTable(details, "- " .. quest.title .. " -", "QuestFontQuestDescriptionMedium", mainTextColor)

	Aura_Quest_AddToDetailsTable(details, "#Aura_Quest_Quest_Type", desctiptionTitleFont, titleTextColor)
	Aura_Quest_AddToDetailsTable(details, quest.type, desctiptionLittleFont, mainTextColor)

	Aura_Quest_AddToDetailsTable(details, "#Aura_Quest_Quest_Description", desctiptionTitleFont, titleTextColor)
	Aura_Quest_AddToDetailsTable(details, quest.description, desctiptionLittleFont, mainTextColor)

	Aura_Quest_AddToDetailsTable(details, "#Aura_Quest_Quest_Difficulty", desctiptionTitleFont, titleTextColor)
	Aura_Quest_AddToDetailsTable(details, quest.difficulty, desctiptionLittleFont, mainTextColor)

	Aura_Quest_AddToDetailsTable(details, "#Aura_Quest_Quest_Rewards", desctiptionTitleFont, titleTextColor)
	Aura_Quest_AddToDetailsTable(details, language.GetPhrase("Aura_Quest_Money_Symbol") .. quest.rewards.money, desctiptionLittleFont, mainTextColor)

	if (quest.rewards.wiltosXP) then
		Aura_Quest_AddToDetailsTable(details, quest.rewards.wiltosXP .. " XP", desctiptionLittleFont, mainTextColor)
	end

	if (quest.stages) then
		Aura_Quest_AddToDetailsTable(details, "#Aura_Quest_Quest_Step", desctiptionTitleFont, titleTextColor)
		Aura_Quest_AddToDetailsTable(details, quest.stages, desctiptionLittleFont, mainTextColor)
	end

	if (!quest.story) then
		Aura_Quest_AddToDetailsTable(details, "#Aura_Quest_Quest_TimeLimit", desctiptionTitleFont, titleTextColor)
		Aura_Quest_AddToDetailsTable(details, quest.time, desctiptionLittleFont, mainTextColor)
	end
	return details
end

function Aura_SendQuestDataToServer(questData)
	net.Start("Aura_Set_Player_Quest")
	net.WriteData(Aura_CompressQuestData(questData))
	net.SendToServer()
end

local newSkin = SKIN

function newSkin:PaintCollapsibleCategory( panel, w, h )
	if ( h <= panel:GetHeaderHeight() ) then
		-- Little hack, draw the ComboBox's dropdown arrow to tell the player the category is collapsed and not empty
		if ( !panel:GetExpanded() ) then self.tex.Input.ComboBox.Button.Down( w - 18, h / 2 - 8, 15, 15 ) end
		return
	end
end
derma.DefineSkin( "AuraQuestSkins", "Auras Quest System Skins", newSkin )
derma.RefreshSkins()
