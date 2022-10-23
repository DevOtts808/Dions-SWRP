-- Clientside functions

aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)
local boxSizeX = 600 * aura_scaleX
local boxSizeY = 50 * aura_scaleY
local paddingX = 25 * aura_scaleX
local paddingY = 25 * aura_scaleY
local progressPadding = 7 * aura_scaleX
local fontMain = "QuestFontQuestSmall"
local progressText = "Progress: "
surface.SetFont(fontMain)
local progressTextX, progressTextY = surface.GetTextSize(progressText)
local progressPaddingLeft = progressTextX + 5 * aura_scaleX
local progressPaddingRight = progressTextX - (5 * aura_scaleX)
local progressBarLength = boxSizeX - progressPadding * 2 - progressPaddingLeft - progressPaddingRight
local progressBarHeight = 20 * aura_scaleY
local newBoxSizeY = boxSizeY
local questYPos = paddingY

hook.Add( "HUDPaint", "Aura_Draw_Quest_Overlay", function()
	if (LocalPlayer().questData) then 
		local nonStoryQuest = LocalPlayer().questData["NonStory"]
		local storyQuest = LocalPlayer().questData["Story"]
		if (nonStoryQuest or storyQuest) then
			local nonStoryQuestTypeData = {}
			local storyQuestTypeData = {}

			newBoxSizeY = boxSizeY
			if (istable(storyQuest) and !table.IsEmpty(storyQuest)) then
				newBoxSizeY = newBoxSizeY + 65 * aura_scaleX
				storyQuestTypeData = Aura_Quest.QuestTypes[storyQuest.type]
			end
			if (istable(nonStoryQuest) and !table.IsEmpty(nonStoryQuest)) then
				newBoxSizeY = newBoxSizeY + 65 * aura_scaleX
				nonStoryQuestTypeData = Aura_Quest.QuestTypes[nonStoryQuest.type]
			end
			if (nonStoryQuestTypeData or storyQuestTypeData) then
				paddingX = GetConVar("quest_hud_x_pos"):GetInt() or paddingX
	    		paddingY = GetConVar("quest_hud_y_pos"):GetInt() or paddingY

				surface.SetDrawColor(aura_quest_color_off_blue2)
				surface.DrawRect(paddingX,paddingY,boxSizeX,newBoxSizeY)

				surface.SetDrawColor(color_white)
				surface.DrawOutlinedRect(paddingX,paddingY,boxSizeX,newBoxSizeY)

				surface.SetFont( "QuestFontQuestMedium" )
				surface.SetTextColor( color_white )
				local text = "#Aura_Quest_HUD_QuestStatus"
				local textX,textY = surface.GetTextSize(text)
				questYPos = paddingY + textY

				surface.SetTextPos( paddingX + boxSizeX / 2 - textX/2, paddingY ) 
				surface.DrawText( text )

				if (nonStoryQuest and nonStoryQuestTypeData) then
					Aura_DetermineQuestHUDDraw(nonStoryQuest, nonStoryQuestTypeData)
				end
				if (storyQuest and storyQuestTypeData) then
					Aura_DetermineQuestHUDDraw(storyQuest, storyQuestTypeData)
				end
			end
		end
	end
end )

function Aura_DetermineQuestHUDDraw(quest, typeData)
	local objective = nil
	local progress = 0

	local prog = quest.progress or 50
	if (prog) then
		if (quest.entity) then
			objective = Entity(quest.entity)
		end
		if (quest.objective) then
			objective = Entity(quest.objective)
		end
		progress = math.Remap(prog,0,100,0,100)
		progress = math.Remap(progress,0,100,0,progressBarLength)
	end

	local textHeight = draw.GetFontHeight(fontMain)
	local progresspaddingX, progresspaddingY = paddingX + progressPadding, questYPos + textHeight + (10 * aura_scaleY)

	surface.SetDrawColor(color_white)
	surface.SetFont(fontMain)
	surface.SetTextPos(progresspaddingX,progresspaddingY - textHeight - (10 * aura_scaleY))
	local timeLeft = ""
	if (timer.Exists(LocalPlayer():SteamID64() .. "QuestTimer")) then
		timeLeft = math.Round(timer.TimeLeft(LocalPlayer():SteamID64() .. "QuestTimer"))
	end

	local textQuest = quest.type .. ", " .. language.GetPhrase("Aura_Quest_HUD_QuestLevel") .. " " .. quest.difficulty .. "   " .. language.GetPhrase("Aura_Quest_HUD_NonStory") .. "   " .. timeLeft
	if (quest.story) then
		textQuest = quest.title .. "   " .. language.GetPhrase("Aura_Quest_HUD_Story")
	end
	local textQuestX, textQuestY = surface.GetTextSize(textQuest)
	surface.DrawText(textQuest)

	surface.SetTextPos(progresspaddingX,progresspaddingY - (7 * aura_scaleY))
	surface.DrawText(progressText)

	local rad = progressPaddingRight/4
	local cirX, cirY = paddingX + boxSizeX - progressPaddingRight / 2, progresspaddingY - rad/2

	if (quest.stage) then
		surface.SetFont( "QuestFontQuestStoryEditSmall" )
		local stageText = (quest.stage - 1) .. "/" .. quest.stages
		local x,y = surface.GetTextSize(stageText)
		surface.SetTextPos(cirX - x/2,cirY - y/2)
		surface.SetTextColor(color_white)
		surface.DrawText(stageText)
	end

	if (IsValid(objective) and objective) then
		surface.SetDrawColor(aura_quest_color_dark_green)
		surface.DrawRect(progresspaddingX + progressPaddingLeft, progresspaddingY,progress,progressBarHeight)

		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(progresspaddingX + progressPaddingLeft, progresspaddingY,progressBarLength,progressBarHeight)

		surface.DrawCircle(cirX,cirY,rad,color_white)

		local diffFromObj = -math.rad(LocalPlayer():GetAngles().y - (LocalPlayer():GetPos() - objective:GetPos()):Angle().y)

		local iconPos = Vector(0,0,0)
		iconPos.x = rad * -math.sin(diffFromObj)
		iconPos.y = rad * -math.cos(diffFromObj)
		surface.DrawCircle(cirX - iconPos.x,cirY - iconPos.y,5, aura_quest_color_red)
	else
		surface.SetFont("QuestFontQuestStoryEdit")
		local noObjective = "#Aura_Quest_HUD_MissingQuestObjective"
		local noObjectiveX, noObjectiveY = surface.GetTextSize(noObjective)
		surface.SetTextPos(progresspaddingX + progressPaddingLeft, progresspaddingY)
		surface.SetTextColor(aura_quest_color_red)
		surface.DrawText(noObjective)
	end

	questYPos = questYPos + 65 * aura_scaleX
end