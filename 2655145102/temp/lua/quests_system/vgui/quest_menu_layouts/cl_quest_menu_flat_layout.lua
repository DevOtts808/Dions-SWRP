function Aura_DrawQuestListMenuFLAT()

	local darkColor = string.ToColor(GetConVarString("quest_main_color_dark"))
    local borderColor = string.ToColor(GetConVarString("quest_border_color"))
    local mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))

	local imgSizeX = 900 * aura_scaleX * 1.5
	local imgSizeY = 664 * aura_scaleY * 1.5
	local questPanel = vgui.Create( "DPanel" )

	local mainPadding = 5 * aura_scaleX
	local sectionsPadding = 50 * aura_scaleY
	local titlePadding = 75 * aura_scaleY

	questPanel:SetSize( imgSizeX, imgSizeY )
	questPanel:Center()
	questPanel:SetSize( imgSizeX, 0 )
	questPanel:MakePopup()

	questPanel:SizeTo(imgSizeX,imgSizeY,.5,0,5, function() end)

	function questPanel:Paint(w,h)
		blurpanel(self, 5)
		draw.RoundedBox(0,0,0,w,h,darkColor)
		surface.DrawOutlinedRect(0,0,w,h, 3 * aura_scaleX)

		surface.SetDrawColor(borderColor)
		--surface.DrawOutlinedRect(mainPadding, mainPadding + titlePadding,w - mainPadding * 2,h - mainPadding * 2 - titlePadding)
		surface.DrawOutlinedRect(0,0,w,h, 3 * aura_scaleX)

		--surface.DrawOutlinedRect(0, 0, w, titlePadding, 3 * aura_scaleX)
	end

	local title = vgui.Create("DLabel", questPanel)
	title:SetText("#Aura_Quest_Menu")
	title:SetFont("QuestFontMain")
	title:SetTextColor(mainTextColor)
	title:SizeToContents()
	title:SetPos(0, mainPadding)
	title:CenterHorizontal()

	function title:Paint(w,h)
		surface.SetDrawColor(borderColor)
		surface.DrawLine(0,h-1,w,h-1)
	end

	local closeButton = vgui.Create("DButton", questPanel)
	closeButton:SetSize(50 * aura_scaleX, 50 * aura_scaleY)
	closeButton:SetPos(questPanel:GetWide() - closeButton:GetWide() - 13 * aura_scaleX, 10 * aura_scaleY)
	closeButton:SetText("")

	closeButton.Paint = function(pan, w, h)
		surface.SetDrawColor(aura_quest_color_red)
		surface.DrawLine(0, 0, w, h)
		surface.DrawLine(0, h, w, 0)
	end

	closeButton.DoClick = function()
		questPanel:Remove()
	end

	local questSectionWidth = imgSizeX / 5 * 3 - (mainPadding * 2)

	local spacing = 5 * aura_scaleY
	local questPadding = spacing + (6 * aura_scaleX)
	local yPos = 0
	local yPosStory = 0
	local ySize = 100 * aura_scaleY

	local selectQuestButtonHeight = 60 * aura_scaleY

	local selectedQuest = nil
	local selectedQuestCategory = nil
	local randomQuests = {}
	local storyQuests = {}

	local detailsSection = vgui.Create( "DPanel", questPanel )
	detailsSection:SetSize( imgSizeX / 5 * 2 - mainPadding - questPadding, imgSizeY - titlePadding - mainPadding * 2 - sectionsPadding - questPadding)
	detailsSection:SetPos(mainPadding + questSectionWidth + 5 * aura_scaleX, mainPadding + titlePadding + sectionsPadding + 10 * aura_scaleY)

	function detailsSection:Paint(w,h)
		surface.SetDrawColor(borderColor)
		surface.DrawOutlinedRect(0, 0, w, h, 1 * aura_scaleX)
	end

	local detailsScroller = vgui.Create("DScrollPanel", detailsSection)
	detailsScroller:Dock( FILL )
	detailsScroller:DockMargin(questPadding,questPadding,questPadding,questPadding * 2 + selectQuestButtonHeight)
	local sbar = detailsScroller:GetVBar()
	sbar:SetWide(0)

	local function SetQuestDetails(quest, text, font, col)
		local detail = vgui.Create("QuestWrappingDLabel",quest.details)
		detail:SetPos(0, quest.detailsYPos)
		detail:SetWide(detailsSection:GetWide() - (10 * aura_scaleX))
		detail:SetFont(font)
		detail:SetTextColor(col)
		detail:SetText(text)

		quest.detailsYPos = quest.detailsYPos + detail:GetTall() + (10 * aura_scaleY)
	end

	local randomQuestsButton = vgui.Create("DButton", questPanel)
	randomQuestsButton:SetSize(questSectionWidth / 2 - spacing / 2 - questPadding, sectionsPadding - (spacing))
	randomQuestsButton:SetPos(mainPadding + questPadding, mainPadding + titlePadding)
	randomQuestsButton:SetText("#Aura_Quest_NonStoryQuests")
	randomQuestsButton:SetFont("QuestFontQuestMedium")
	randomQuestsButton:SetTextColor(mainTextColor)

	function randomQuestsButton:Paint(w,h)
		if (selectedQuestCategory == self) then
			draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_blue)
		end
		surface.SetDrawColor(borderColor)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	function randomQuestsButton:DoClick()
		for k,v in pairs(randomQuests) do
			v:Show()
		end

		for k,v in pairs(storyQuests) do
			v:Hide()
		end

		if (selectedQuest and selectedQuest.details) then
			selectedQuest.details:Hide()
		end

		selectedQuest = randomQuests[1] or nil
		if (selectedQuest != nil and selectedQuest.details) then
			selectedQuest.details:Show()
		end

		selectedQuestCategory = self
	end

	local storyQuestsButton = vgui.Create("DButton", questPanel)
	storyQuestsButton:SetSize(questSectionWidth / 2 - spacing / 2 - questPadding, sectionsPadding - (spacing))
	storyQuestsButton:SetPos(mainPadding + questSectionWidth /2 + (spacing / 2), mainPadding + titlePadding)
	storyQuestsButton:SetText("#Aura_Quest_StoryQuests")
	storyQuestsButton:SetFont("QuestFontQuestMedium")
	storyQuestsButton:SetTextColor(mainTextColor)

	function storyQuestsButton:Paint(w,h)
		if (selectedQuestCategory == self) then
			draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_blue)
		end
		surface.SetDrawColor(borderColor)
		surface.DrawOutlinedRect(0,0,w,h)
	end

	function storyQuestsButton:DoClick()
		for k,v in pairs(randomQuests) do
			v:Hide()
		end

		for k,v in pairs(storyQuests) do
			v:Show()
		end

		if (selectedQuest and selectedQuest.details) then
			selectedQuest.details:Hide()
		end
		selectedQuest = storyQuests[1] or nil
		if (selectedQuest and selectedQuest.details) then
			selectedQuest.details:Show()
		end

		selectedQuestCategory = self
	end

	selectedQuestCategory = randomQuestsButton

	local acceptQuestButton = vgui.Create("DButton", detailsSection)
	acceptQuestButton:SetSize(detailsSection:GetWide() / 3 - 5 * aura_scaleX, selectQuestButtonHeight)
	acceptQuestButton:SetPos(detailsSection:GetWide() / 3 * 2 - 5 * aura_scaleX, detailsSection:GetTall() - selectQuestButtonHeight - questPadding)
	acceptQuestButton:SetText("#Aura_Quest_AcceptQuest")
	acceptQuestButton:SetFont("QuestFontQuestSmall")
	acceptQuestButton:SetTextColor(mainTextColor)

	function acceptQuestButton:Paint(w,h)
		blurpanel(self, 10)
		draw.RoundedBox(0,0,0,w,h,aura_quest_color_dark_green2)
		surface.SetDrawColor(borderColor)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local hasHitAccept = false
	function acceptQuestButton:DoClick()
		if (hasHitAccept) then return end
		hasHitAccept = true
		selectedQuest.questData.player = LocalPlayer():SteamID64()
		selectedQuest.questData.npc = LocalPlayer().currentQuestNPC:GetNodeID()

		if (LocalPlayer().questData == nil) then
			LocalPlayer().questData = {}
		end

		if (selectedQuest.questData.story) then

			local hasRequiredQuests = AuraPlayerHasQuestRequirements(selectedQuest.questData, LocalPlayer())
			if (istable(hasRequiredQuests)) then
				LocalPlayer():ChatPrint("#Aura_Quest_NeedsOtherQuests")
				for k,v in pairs(hasRequiredQuests) do
					LocalPlayer():ChatPrint(v)
				end
				hasHitAccept = false
				return
			end

			if (table.HasValue(selectedQuest.questData.playersCompleted,LocalPlayer():SteamID64())) then
				LocalPlayer():ChatPrint("#Aura_Quest_QuestAlreadyCompleted")
				hasHitAccept = false
				return
			end

			if (LocalPlayer().questData["Story"]) then
				LocalPlayer():ChatPrint("#Aura_Quest_StoryQuestAlreadyAccepted")
				hasHitAccept = false
				return
			end

			LocalPlayer().questData["Story"] = selectedQuest.questData
			LocalPlayer():ChatPrint("#Aura_Quest_AcceptStoryQuest")
			LocalPlayer():ChatPrint(selectedQuest.questData.title)
		else
			if (LocalPlayer().questData["NonStory"]) then
				LocalPlayer():ChatPrint("#Aura_Quest_NonStoryQuestAlreadyAccepted")
				hasHitAccept = false
				return
			end

			-- For the HUD integration clientside
			timer.Create(LocalPlayer():SteamID64() .. "QuestTimer",selectedQuest.questData.time,1, function()
			end)

			if (selectedQuest.questData.editableValues and selectedQuest.questData.editableValues.protectTime) then
				timer.Create(LocalPlayer():SteamID64().."QuestProtectTimer" .. tostring(selectedQuest.questData.story),selectedQuest.questData.editableValues.protectTime,1, function()
				end)
			end

			LocalPlayer().questData["NonStory"] = selectedQuest.questData
			LocalPlayer():ChatPrint("#Aura_Quest_AcceptNonStoryQuest")
			LocalPlayer():ChatPrint(selectedQuest.questData.type .. ", " .. language.GetPhrase("Aura_Quest_Quest_DifficultyWord") .. " " .. selectedQuest.questData.difficulty)
		end

		Aura_SendQuestDataToServer(selectedQuest.questData)

		questPanel:Remove()
	end

	local questSection = vgui.Create( "DPanel", questPanel )
	questSection:SetSize( questSectionWidth, imgSizeY - titlePadding - mainPadding * 2 - sectionsPadding - 10 * aura_scaleY)
	questSection:SetPos(mainPadding, mainPadding + titlePadding + sectionsPadding + 10 * aura_scaleY)

	function questSection:Paint(w,h)
		--surface.SetDrawColor(borderColor)
		--surface.DrawOutlinedRect(0, 0, w, h, 1 * aura_scaleX)
	end

	local questScroller = vgui.Create("DScrollPanel", questSection)
	questScroller:Dock( FILL )
	questScroller:DockMargin(questPadding,0,questPadding,0)
	local sbar = questScroller:GetVBar()
	sbar:SetWide(0)
	function sbar:Paint(w, h)
	end
	function sbar.btnUp:Paint(w, h)
	end
	function sbar.btnDown:Paint(w, h)
	end
	function sbar.btnGrip:Paint(w, h)
	end

	local function Aura_Quest_InsertQuestsIntoTable(v, tbl)
		local quest = vgui.Create("DButton", questScroller)
		quest:SetSize(questSection:GetWide() - questPadding * 2, ySize)
		quest:SetPos(0, yPos)
		quest:SetText(v.type)
		if (v.story) then
			quest:SetText(v.title)
		end
		quest:SetTextColor(mainTextColor)
		quest:SetFont("QuestFontQuestTitles")
		v.number = k

		local difficultyStarSize = 10 * aura_scaleX
		for i=1,v.difficulty do
			local star = vgui.Create("DImage",quest)
			star:SetPos(quest:GetWide() - (5 * aura_scaleX) - (difficultyStarSize * i), 5 * aura_scaleY)
			star:SetSize(difficultyStarSize,difficultyStarSize)
			star:SetImage(Aura_Quest.DifficultyGraphic)
			star:SetImageColor(Aura_Quest.DifficultyColor)
		end

		quest.details = vgui.Create("DPanel", detailsScroller)
		quest.details:SetPos(5 * aura_scaleX,0)
		quest.details:SetWide(detailsSection:GetWide() - (10 * aura_scaleX))

		quest.details:Hide()

		quest.questData = v
		table.insert(tbl,quest)
		yPos = yPos + quest:GetTall() + spacing

		quest.detailsYPos = 10 * aura_scaleY
		local details = Aura_QuestGetDescription(v)
		for k,v in ipairs(details) do
			SetQuestDetails(quest, v.text, v.font, v.col)
		end

		quest.details:SizeToChildren(false,true)
		quest.details:SetTall(quest.details:GetTall() + 10 * aura_scaleY)

		function quest.details:Paint(w,h)

		end

		if (v.story) then
			quest:Hide()
		end

		function quest:Paint(w,h)
			if (selectedQuest == self) then
				draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_blue)
			end
			surface.SetDrawColor(borderColor)
			surface.DrawOutlinedRect(0,0,w,h)
		end

		function quest:DoClick()
			if (selectedQuest and selectedQuest.details) then
				selectedQuest.details:Hide()
			end
			selectedQuest = self
			selectedQuest.details:Show()
		end
	end

	for k,v in pairs(LocalPlayer().currentQuestNPC.QuestTable) do
		Aura_Quest_InsertQuestsIntoTable(v, randomQuests)
	end

	yPos = 0
	
	for k,v in pairs(Aura_Quest.Quests) do
		Aura_Quest_InsertQuestsIntoTable(v, storyQuests)
	end

	selectedQuest = randomQuests[1] or nil
	if (selectedQuest != nil and selectedQuest.details) then
		selectedQuest.details:Show()
	end

	local descriptionTitle = vgui.Create("DLabel", questPanel)
	descriptionTitle:SetText("#Aura_Quest_Details")
	descriptionTitle:SetFont("QuestFontMain")
	descriptionTitle:SetTextColor(mainTextColor)
	descriptionTitle:SizeToContents()
	descriptionTitle:SetPos(0, mainPadding + titlePadding - (7 * aura_scaleY))
	descriptionTitle:CenterHorizontal(.8)

	return questPanel
end

if (Aura_Quest.Convars and Aura_Quest.Convars["quest_npc_layout"] and Aura_Quest.Convars["quest_npc_layout"].options) then
	Aura_Quest.Convars["quest_npc_layout"].options["Original"] = Aura_DrawQuestListMenuFLAT
end