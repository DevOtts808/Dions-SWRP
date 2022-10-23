function Aura_DrawQuestListMenuICONS()
	Aura_Populate_NPC_Table()


	local darkColor = string.ToColor(GetConVarString("quest_main_color_dark"))
	local darkColor2 = Color(darkColor.r,darkColor.g,darkColor.b,150)
    local borderColor = string.ToColor(GetConVarString("quest_border_color"))
    local mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))

	local imgSizeX = 900 * aura_scaleX * 1.5
	local imgSizeY = 664 * aura_scaleY * 1.5
	local questPanel = vgui.Create( "EditablePanel" )

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

	local questSectionWidth = imgSizeX - (mainPadding * 2)

	local spacing = 5 * aura_scaleY
	local questPadding = spacing + (6 * aura_scaleX)
	local questNumberPerRow = 8
	local questScrollerWidth = questSectionWidth - questPadding * 2 - (spacing * (questNumberPerRow - 1))
	local yPos = 0
	local yPosStory = 0
	local ySize = (questScrollerWidth / questNumberPerRow)

	local selectQuestButtonHeight = 60 * aura_scaleY

	local selectedQuest = nil
	local selectedQuestCategory = nil
	local randomQuests = {}
	local storyQuests = {}

	local function SetQuestDetails(quest, text, font, col)
		local detail = vgui.Create("QuestWrappingDLabel",quest.details)
		detail:SetPos(5 * aura_scaleX, quest.detailsYPos)
		detail:SetWide(quest.details:GetWide() - (10 * aura_scaleX))
		detail:SetFont(font)
		detail:SetTextColor(col)
		detail:SetText(text)

		quest.detailsYPos = quest.detailsYPos + detail:GetTall() + (5 * aura_scaleY)
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

		selectedQuest = randomQuests[1] or nil

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

		selectedQuest = storyQuests[1] or nil

		selectedQuestCategory = self
	end

	selectedQuestCategory = randomQuestsButton

	local acceptButtonSizeX = 250 * aura_scaleX
	local acceptQuestButton = vgui.Create("DButton", questPanel)
	acceptQuestButton:SetSize(acceptButtonSizeX, selectQuestButtonHeight)
	acceptQuestButton:SetPos(imgSizeX - acceptButtonSizeX - questPadding, imgSizeY - selectQuestButtonHeight - questPadding)
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
	end

	local questScroller = vgui.Create("DScrollPanel", questSection)
	questScroller:Dock( FILL )
	questScroller:DockMargin(questPadding,0,questPadding,selectQuestButtonHeight + questPadding)
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

	local questXPos = 0

	local function Aura_Quest_InsertQuestsIntoTable(v, tbl)
		local story = v.story

		local quest = vgui.Create("DImageButton", questScroller)
		quest:SetSize(ySize, ySize)
		local pos = yPos

		local typeData = Aura_Quest.QuestTypes[v.type]
		local img = Aura_Quest.DefaultQuestMenuIcon
		if (typeData and typeData.menuIcon) then
			img = typeData.menuIcon
		end
		quest:SetImage(img)

		quest:SetPos(questXPos, pos)
		--quest:SetText(v.type)
		--quest:SetTextColor(mainTextColor)
		--quest:SetFont("QuestFontQuestTitles")
		v.number = k

		local difficultyStarSize = 15 * aura_scaleX
		for i=1,v.difficulty do
			local star = vgui.Create("DImage",quest)
			star:SetPos(quest:GetWide() - (5 * aura_scaleX) - (difficultyStarSize * i), 5 * aura_scaleY)
			star:SetSize(difficultyStarSize,difficultyStarSize)
			star:SetImage(Aura_Quest.DifficultyGraphic)
			star:SetImageColor(Aura_Quest.DifficultyColor)
		end

		quest.details = vgui.Create("EditablePanel")
		quest.details:SetSize(quest:GetWide() * 4, 200)
		quest.details:SetPos(-quest.details:GetWide(),0)
		quest.details:MakePopup()
		quest.details:Hide()
		quest.details:SetMouseInputEnabled(false)
		function quest.details:Paint(w,h)
			draw.RoundedBox(4,0,0,w,h,aura_quest_color_gray2)
			surface.SetDrawColor(borderColor)
			surface.DrawOutlinedRect(0,0,w,h)
		end

		if (v.story) then
			quest:Hide()
		end

		quest.questData = v
		table.insert(tbl,quest)
		questXPos = questXPos + quest:GetWide() + spacing
		if (questXPos >= questSection:GetWide() - questPadding) then
			yPos = yPos + quest:GetTall() + spacing
			questXPos = 0
		end

		quest.detailsYPos = 10 * aura_scaleY
		local details = Aura_QuestGetDescription(v)
		for k,v in ipairs(details) do
			SetQuestDetails(quest, v.text, v.font, v.col)
		end

		quest.details:SizeToChildren(false,true)
		quest.details:SetTall(quest.details:GetTall() + 10 * aura_scaleY)

		function quest:OnCursorEntered()
			if (IsValid(self.details)) then
				self.details:Show()
				self.details:MoveToFront()
			end
		end
		function quest:OnCursorExited()
			if (IsValid(self.details)) then
				self.details:Hide()
			end
		end
		function quest:OnCursorMoved(x,y)
			if (IsValid(self.details)) then
				x,y = input.GetCursorPos()
				y = y + ( 20 * aura_scaleY)
				if (y + self.details:GetTall() > ScrH()) then
					y = y - self.details:GetTall() - ( 20 * aura_scaleY)
				end
				self.details:SetPos(x + (20 * aura_scaleX), y)
			end
		end
		function quest:OnRemove()
			if (IsValid(self.details)) then
				self.details:Remove()
			end
		end

		function quest:PaintOver(w,h)
			if (selectedQuest == self) then
				draw.RoundedBox(0,0,0,w,h, darkColor2)
			end
		end

		function quest:DoClick()
			selectedQuest = self
			quest.details:MoveToFront()
		end
	end

	for k,v in pairs(LocalPlayer().currentQuestNPC.QuestTable) do
		Aura_Quest_InsertQuestsIntoTable(v, randomQuests)
	end
	
	questXPos = 0
	yPos = 0
	for k,v in pairs(Aura_Quest.Quests) do
		Aura_Quest_InsertQuestsIntoTable(v, storyQuests)
	end

	acceptQuestButton:MoveToFront()

	selectedQuest = randomQuests[1] or nil

	return questPanel
end

if (Aura_Quest.Convars and Aura_Quest.Convars["quest_npc_layout"] and Aura_Quest.Convars["quest_npc_layout"].options) then
	Aura_Quest.Convars["quest_npc_layout"].options["Quest Icons"] = Aura_DrawQuestListMenuICONS
end