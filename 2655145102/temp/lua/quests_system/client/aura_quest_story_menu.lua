-- All the code for the story quest menu (gonna be a big one)
aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)

net.Receive("Aura_Quest_Open_Story_Menu", function()
	aura_scaleX = (ScrW() / 2560)
	aura_scaleY = (ScrH() / 1440)
	Aura_Populate_Node_Table()

	Aura_Draw_Story_Quest_Menu()
end)

local blur = Material'pp/blurscreen'

local function blurpanel(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(blur)

	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end

local categoryColor = Color(0,150,250,255)
local categoryColor2 = Color(0, 37, 60, 200)

local tab = {25, 50, 75, 100}

function Aura_Draw_Story_Quest_Menu()
	--[[-------------------------------------------------------------------------
	We need some way to actually store the story quests, so we can just call them directly from file.Read
	---------------------------------------------------------------------------]]
	local quests = GetStoryQuestData()


	local boxSizeX = 1500 * aura_scaleX -- Main panel size X
	local boxSizeY = 1200 * aura_scaleY -- Main panel size Y
	local paddingX = 10 * aura_scaleX -- Padding for all elements that lay on the left or right side from the edge
	local paddingY = 80 * aura_scaleY -- Padding for the bottom buttons (add/remove/apply story quests)
	local titlePadding = 130 * aura_scaleY
	local fontMain = "QuestFontQuestSmall"

	local storyQuestMenu = vgui.Create( "DPanel" )
	storyQuestMenu:SetSize( boxSizeX, boxSizeY )
	storyQuestMenu:Center()
	storyQuestMenu:SetSize( boxSizeX, 0 )
	storyQuestMenu:MakePopup()

	storyQuestMenu:SizeTo(boxSizeX,boxSizeY,.5,0,5, function() end)

	function storyQuestMenu:Paint(w,h)
		blurpanel(self, 5)
		draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_blue2)
		surface.SetDrawColor(color_white)

		surface.DrawOutlinedRect(0,0,w,h, 4 * aura_scaleX)
		storyQuestMenu:MoveToBack()
	end

	local closeButton = vgui.Create("DButton", storyQuestMenu)
	closeButton:SetSize(30 * aura_scaleX, 30 * aura_scaleY)
	closeButton:SetPos(storyQuestMenu:GetWide() - closeButton:GetWide() - 13 * aura_scaleX, 10 * aura_scaleY)
	closeButton:SetText("")

	closeButton.Paint = function(pan, w, h)
		surface.SetDrawColor(aura_quest_color_red)
		surface.DrawLine(0, 0, w, h)
		surface.DrawLine(0, h, w, 0)
	end

	closeButton.DoClick = function()
		storyQuestMenu:Remove()
	end

	local data = {}
	local storyQuestButtons = {}
	local selectedQuest = nil

	local title = vgui.Create("DLabel", storyQuestMenu)
	title:SetText("Story Quest Edit Menu")
	title:SetFont("QuestFontQuestTitles")
	title:SetTextColor(color_white)
	title:SizeToContents()
	title:SetPos(0, mainPadding)
	title:CenterHorizontal()

	function title:Paint(w,h)
		surface.SetDrawColor(color_white)
		surface.DrawLine(0,h-1,w,h-1)
	end

	local storyQuestsWarning = vgui.Create("DLabel", storyQuestMenu)
	storyQuestsWarning:SetText("Warning, closing without applying changes will revert all edits")
	storyQuestsWarning:SetFont("QuestFontQuestSmall")
	storyQuestsWarning:SetTextColor(aura_quest_color_red)
	storyQuestsWarning:SizeToContents()
	storyQuestsWarning:SetPos(0, title:GetTall() + 5 * aura_scaleY)
	storyQuestsWarning:CenterHorizontal()

	local storyQuestsWarning2 = vgui.Create("DLabel", storyQuestMenu)
	storyQuestsWarning2:SetText("All titles MUST be unique to save properly")
	storyQuestsWarning2:SetFont("QuestFontQuestSmall")
	storyQuestsWarning2:SetTextColor(aura_quest_color_red)
	storyQuestsWarning2:SizeToContents()
	storyQuestsWarning2:SetPos(0, title:GetTall() + 35 * aura_scaleY)
	storyQuestsWarning2:CenterHorizontal()


	--[[-------------------------------------------------------------------------
	Lots of vars ahoy!
	---------------------------------------------------------------------------]]

	local yPos = 0
	local questPadding = 10 * aura_scaleX
	local spacing = 10 * aura_scaleY
	local ySize = 100 * aura_scaleX
	local yChange = ySize + spacing
	local storyQuestTitlePadding = 45 * aura_scaleY

	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	--[[-------------------------------------------------------------------------
	Here we will display data related to the quest and allow the user to edit it
	---------------------------------------------------------------------------]]
	local storyQuestEdit = vgui.Create("EditablePanel",storyQuestMenu)
	storyQuestEdit:SetPos(boxSizeX / 2 + paddingX / 2, titlePadding)
	storyQuestEdit:SetSize(boxSizeX / 2 - (paddingX * 1.5), boxSizeY - titlePadding - paddingY - paddingX * 2)
	storyQuestEdit:MakePopup()
	local panelX1, panelY1 = storyQuestMenu:GetPos()
	local realPosX, realPosY = storyQuestEdit:GetPos()
	realPosX = realPosX + panelX1
	realPosY = realPosY + panelY1
	storyQuestEdit:SetPos(realPosX, realPosY)

	function storyQuestEdit:Paint(w,h)
		surface.SetDrawColor(aura_quest_color_off_blue5)
		surface.DrawRect(0,0,w,45 * aura_scaleY)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,storyQuestTitlePadding)
		surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
		draw.SimpleText("Details / Edit","QuestFontQuestMedium",w/2,0,color_white,TEXT_ALIGN_CENTER)
	end


	function SetQuestDetails(quest)
		tab = {25, 50, 75, 100}
		local questDetails = vgui.Create("EditablePanel", storyQuestEdit)
		questDetails:Dock(FILL)

		local questEditCategoryList = vgui.Create("DCategoryList", questDetails)
		questEditCategoryList:SetWide(storyQuestEdit:GetWide() - questPadding * 2)
		questEditCategoryList:Dock( FILL )
		questEditCategoryList:DockMargin(questPadding,questPadding + storyQuestTitlePadding,questPadding,questPadding)
		local sbar2 = questEditCategoryList:GetVBar()
		sbar2:SetWide(10 * aura_scaleX)	
		function questEditCategoryList:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,aura_quest_color_light_white)
		end
		questDetails:SetSize(storyQuestEdit:GetWide() - questPadding * 2 - sbar2:GetWide(),1500 * aura_scaleY)


		quest.details = questDetails

		local questData = quest.questData
		local typeData = Aura_Quest.QuestTypes[questData.type]

		function questDetails:Paint(w,h)
		end

		--[[-------------------------------------------------------------------------
		GENERAL INFO
		---------------------------------------------------------------------------]]
		local questInfoGeneral = AddQuestDetail("DCollapsibleCategory", questEditCategoryList, "General:", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)


		local originalTitle = questData.title
		local questTitleText = AddQuestDetail("QuestWrappingDLabel", questInfoGeneral, "Quest Title: " .. originalTitle .. "   (Before changes)", "QuestFontQuestStoryEdit")
		local questTitleEdit = AddQuestDetail("DTextEntry", questInfoGeneral, questData.title, "QuestFontQuestStoryEdit", nil, function(val)
			questData.title = val
			quest:SetText(val)
	 	end)


		local originalType = questData.type
		local questTypeText = AddQuestDetail("QuestWrappingDLabel", questInfoGeneral, "Quest Type: " .. originalType .. "   (Before changes)\nCHANGING THIS WILL REVERT ALL CHANGES TO THIS CURRENT QUEST", "QuestFontQuestStoryEdit")
		local questTypeEdit = AddQuestDetail("DComboBox", questInfoGeneral, questData.type, "QuestFontQuestStoryEdit", nil, function(val)
			RemoveStoryQuestFromList()
			local newQuest = AuraGenerateStoryQuest(val, nil, 1, true, "Story Quest " .. (#data + 1))
			Aura_AddStoryQuestToScroller(newQuest, true)
	 	end)


		local originalDescription = questData.description or ""
		local questDescText = AddQuestDetail("QuestWrappingDLabel", questInfoGeneral, "Quest Description: " .. originalDescription .. "   (Before changes)", "QuestFontQuestStoryEdit")
		local questDescEdit = AddQuestDetail("DTextEntry", questInfoGeneral, questData.description, "QuestFontQuestStoryEdit", nil, function(val)
			questData.description = val
	 	end)

		local originalDifficulty = questData.difficulty or ""
		local questDifficultyText = AddQuestDetail("QuestWrappingDLabel", questInfoGeneral, "Quest Difficulty: " .. originalDifficulty .. "   (Before changes)", "QuestFontQuestStoryEdit")
		local questDifficultyEdit = AddQuestDetail("DTextEntry", questInfoGeneral, questData.difficulty, "QuestFontQuestStoryEdit", nil, function(val)
			if (isnumber(tonumber(val))) then
				questData.difficulty = val
			end
	 	end)
		questDifficultyEdit:SetNumeric(true)

		--[[-------------------------------------------------------------------------
		---------------------------------------------------------------------------]]

		--[[-------------------------------------------------------------------------
		NODE INFO
		---------------------------------------------------------------------------]]
		local questNodeGeneral = AddQuestDetail("DCollapsibleCategory", questEditCategoryList, "Nodes:", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)


		local originalNode = questData.node or ""
		local nodeEnt = Aura_GetQuestNode(questData)
		local questNodeText = AddQuestDetail("QuestWrappingDLabel", questNodeGeneral, "Quest Node: " .. originalNode .. "   (Before changes)", "QuestFontQuestStoryEdit")
		local questNodeEdit
		if (!IsValid(nodeEnt) or (IsValid(nodeEnt) and nodeEnt:GetClass() != "aura_quest_location_marker")) then
			originalNode = "The original node used is not a valid quest node!"
		end
		questNodeEdit = AddQuestDetail("DTextEntry", questNodeGeneral, originalNode, "QuestFontQuestStoryEdit", nil, function(val)
			local node = Aura_Quest.Nodes[questData.type][val]
			if (IsValid(node) and node != nil and node:GetClass() == "aura_quest_location_marker") then
				questData.node = val
			else
				if (questNodeEdit != nil) then
					questNodeEdit:SetText("That is not a valid node number!")
				end
			end
	 	end)

		local chooseRandomNodeButton = AddQuestDetail("DButton", questNodeGeneral, "Choose random node", "QuestFontQuestStoryEdit", nil, function()
			local nodes = Aura_Quest.Nodes
			if (nodes and nodes[questData.type]) then
				questNodeEdit:SetValue(table.Random(nodes[questData.type]):GetNodeID())
			end
	 	end)

		if (typeData.deliver) then
			local secondNodeTitle = AddQuestDetail("QuestWrappingDLabel", questNodeGeneral, "The destination node is the node the player will deliver the item to!", "QuestFontQuestStoryEdit")


			local originalSecondNode = questData.node2 or ""
			local nodeSecondEnt = Aura_GetSecondQuestNode(questData)

			local questNodeSecondText = AddQuestDetail("QuestWrappingDLabel", questNodeGeneral, "Destination Node: " .. originalSecondNode .. "   (Before changes)", "QuestFontQuestStoryEdit")
			local questNodeSecondEdit
			if (!IsValid(nodeSecondEnt) or (IsValid(nodeSecondEnt) and nodeSecondEnt:GetClass() != "aura_quest_location_marker")) then
				originalSecondNode = "The original node used is not a valid quest node!"
			end
			questNodeSecondEdit = AddQuestDetail("DTextEntry", questNodeGeneral, originalSecondNode, "QuestFontQuestStoryEdit", nil, function(val)
				local deliveryNode, deliveryType = Aura_GetRandomDeliveryNode()
				if (IsValid(deliveryNode) and deliveryNode != nil and deliveryNode:GetClass() == "aura_quest_location_marker") then
					Aura_SetSecondQuestNode(questData, deliveryNode, deliveryType)
				else
					if (questNodeSecondEdit != nil) then
						questNodeSecondEdit:SetText("That is not a valid node number!")
					end
				end
		 	end)

			local chooseRandomSecondNodeButton = AddQuestDetail("DButton", questNodeGeneral, "Choose random destination node", "QuestFontQuestStoryEdit", nil, function()
				local deliveryNode, deliveryType = Aura_GetRandomDeliveryNode()
				questNodeSecondEdit:SetValue(deliveryNode:GetNodeID())
		 	end)
		end

		--[[-------------------------------------------------------------------------
		---------------------------------------------------------------------------]]


		--[[-------------------------------------------------------------------------
		ENTITY INFO
		---------------------------------------------------------------------------]]
		local questEntityGeneral = AddQuestDetail("DCollapsibleCategory", questEditCategoryList, "Entity Data (a list from which one is randomly chosen to spawn at the node):", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)

		for k,v in pairs(questData.typeEditables) do
			local questEntityInfoGeneral = AddQuestDetail("QuestWrappingDLabel", questEntityGeneral, k .. " (" .. #v .. "):", "QuestFontQuestStoryEdit")
			for n,m in pairs(v) do
				local questEntityTitleGeneral = AddQuestDetail("QuestWrappingDLabel", questEntityGeneral, n, "QuestFontQuestStoryEdit", aura_quest_color_red, nil, true, aura_quest_color_light_gray, tab[1])
				for i,o in pairs(m) do
					local curData = o
					local dataEditText = AddQuestDetail("QuestWrappingDLabel", questEntityGeneral, i .. ": " .. curData .. "   (Before changes)", "QuestFontQuestStoryEdit", color_black, nil , true, color_transparent, tab[2])
					local dataEdit = AddQuestDetail("DTextEntry", questEntityGeneral, curData, "QuestFontQuestStoryEdit", nil, function(val)
						if (type(o) == "number") then
							if (isnumber(tonumber(val))) then
								questData.typeEditables[k][n][i] = val
							end
						else
							questData.typeEditables[k][n][i] = val
						end
				 	end, true, aura_quest_color_light_gray, tab[2])
					if (type(o) == "number") then
						dataEdit:SetNumeric(true)
					end
				end
			end
			local addEntityButton = AddQuestDetail("DButton", questEntityGeneral, "Add to " .. k, "QuestFontQuestStoryEdit", aura_quest_color_off_blue3, function()
				local tbl = {}
				if (!table.IsEmpty(v)) then
					tbl = table.Copy(v[1])
				else
					tbl = table.Copy(Aura_Quest.QuestTypes[questData.type].editables[k][1]) -- Bruh
				end
				table.insert(questData.typeEditables[k], tbl)
				RefreshQuestDetails(quest)
		 	end)
		 	if (!table.IsEmpty(v)) then
		 		local removeEntityButton = AddQuestDetail("DButton", questEntityGeneral, "Remove from " .. k, "QuestFontQuestStoryEdit", aura_quest_color_off_red, function()
					
					local entList = DermaMenu()
					for num,ent in pairs(v) do
						if (!ent) then continue end
						entList:AddOption(num, function() 
							table.remove(questData.typeEditables[k],num)
							RefreshQuestDetails(quest)
						end)
					end
					entList:Open()
			 	end)
			end
		end

		if (questData.editableValues) then

			--[[-------------------------------------------------------------------------
			SECONDARY EDITABLES INFO
			---------------------------------------------------------------------------]]

			local secondaryEditablesCategory = AddQuestDetail("QuestWrappingDLabel", questEntityGeneral, "Secondary Configurations:", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)

			for k,v in pairs(questData.editableValues) do
				local questDetailTable = AddQuestDetail("QuestWrappingDLabel", questEntityGeneral, k .. ": " .. v .. "   (Before changes)", "QuestFontQuestStoryEdit")
				local questDifficultyEdit = AddQuestDetail("DTextEntry", questEntityGeneral, v, "QuestFontQuestStoryEdit", nil, function(val)
					if (isnumber(tonumber(val))) then
						questData.editableValues[k] = val
					end
			 	end)
				questDifficultyEdit:SetNumeric(true)
			end

			--[[-------------------------------------------------------------------------
			---------------------------------------------------------------------------]]
		end

		--[[-------------------------------------------------------------------------
		REWARDS INFO
		---------------------------------------------------------------------------]]

		local questRewardsCategory = AddQuestDetail("DCollapsibleCategory", questEditCategoryList, "Quest Rewards:", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)

		for k,v in pairs(questData.rewards) do
			local questNodeGeneral = AddQuestDetail("QuestWrappingDLabel", questRewardsCategory, string.upper(string.GetChar(k,1)) .. string.sub(k,2) .. ": " .. v .. " (Before changes)", "QuestFontQuestStoryEdit")
			local numeric = (type(v) == "number")
			local questDifficultyEdit = AddQuestDetail("DTextEntry", questRewardsCategory, v, "QuestFontQuestStoryEdit", nil, function(val)
				if ((isnumber(tonumber(val)) and numeric) or !numeric ) then
					questData.rewards[k] = val
				end
		 	end)
			questDifficultyEdit:SetNumeric(numeric)
		end


		--[[-------------------------------------------------------------------------
		---------------------------------------------------------------------------]]

		local questDialogue = questData.questDialogue
		if (questDialogue) then

			--[[-------------------------------------------------------------------------
			DIALOGUE EDITING!!!!
			---------------------------------------------------------------------------]]

			local dialogueEditingCategory = AddQuestDetail("DCollapsibleCategory", questEditCategoryList, "Custom Dialogue Settings:", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)
			local dialogueSideNote = AddQuestDetail("QuestWrappingDLabel", dialogueEditingCategory, "These are the dialogue options that will pop up when interacting with the main quest entity during specific times in the quest, as of now, it is cut into three sections:\n\nQuest Start, which is when the quest has been taken, but the main objective is not happening yet (think before enemies spawn for protect quest\n\nQuest During, which is WHILE the main quest objective is going on\n\nQuest Complete, which is after the main quest objective has been complete, but the quest has not been turned in yet", "QuestFontQuestStoryEdit", aura_quest_color_blue)

			local dialogueCategoryDropdown = AddQuestDetail("DCategoryList", dialogueEditingCategory, "Custom Dialogue Settings:", "QuestFontQuestSmall", categoryColor, nil, false, categoryColor2)
			local catW = dialogueCategoryDropdown:GetWide()
			local catH = 0
			

			for k,v in SortedPairs(questDialogue) do
				local dialogueTimeTitle = AddQuestDetail("DCollapsibleCategory", dialogueCategoryDropdown, k, "QuestFontQuestSmall", aura_quest_color_red, nil, true, aura_quest_color_light_gray)
				function dialogueTimeTitle:OnToggle(on)
					if (on) then
						dialogueCategoryDropdown:SizeTo(catW,dialogueTimeTitle.detailsY,dialogueTimeTitle:GetAnimTime(),0,-1, function() end)
					else
						dialogueCategoryDropdown:SizeTo(catW,catH,dialogueTimeTitle:GetAnimTime(),0,-1, function() end)
					end
				end
				AuraDrawDialogueOptionEdit(quest, dialogueTimeTitle, questData, k, v)
			end
			dialogueCategoryDropdown:SetTall(dialogueCategoryDropdown.detailsY / 2)
			catH = dialogueCategoryDropdown:GetTall()

			--[[-------------------------------------------------------------------------
			---------------------------------------------------------------------------]]
		end

		--[[-------------------------------------------------------------------------
		REQUIRED QUESTS INFO YEAHHHHH BOYYYYY
		---------------------------------------------------------------------------]]

		local questRequiredQuestCategory = AddQuestDetail("DCollapsibleCategory", questEditCategoryList, "Required Quests:", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)
		local questsRequiredSideNote = AddQuestDetail("QuestWrappingDLabel", questRequiredQuestCategory, "Side note: only quests that have been \"applied\" will be here, so you need to apply changes if you add a new quest before you can add it to the list of required quests", "QuestFontQuestStoryEdit")

		for k,v in pairs(questData.requiredQuests) do
			local requiredQuest = AddQuestDetail("QuestWrappingDLabel", questRequiredQuestCategory, k .. ": " .. v, "QuestFontQuestStoryEdit", color_black, nil , true, aura_quest_color_dark_gray, tab[1])
		end

		local addRequiredQuestButton = AddQuestDetail("DButton", questRequiredQuestCategory, "Add Required Quest", "QuestFontQuestStoryEdit", aura_quest_color_off_blue3, function()
			local questList = DermaMenu()
				for k,v in pairs(quests) do
				if (v == questData or table.HasValue(questData.requiredQuests,v.title)) then continue end
				questList:AddOption(v.title, function()
					table.insert(questData.requiredQuests,v.title)
					RefreshQuestDetails(quest)
				end)
			end
			questList:Open()
	 	end)
	 	if (!table.IsEmpty(questData.requiredQuests)) then
	 		local removeEntityButton = AddQuestDetail("DButton", questRequiredQuestCategory, "Remove Required Quest", "QuestFontQuestStoryEdit", aura_quest_color_off_red, function()
				local questList = DermaMenu()
				for k,v in pairs(questData.requiredQuests) do
					questList:AddOption(v, function()
						table.remove(questData.requiredQuests, k)
						RefreshQuestDetails(quest)
					end)
				end
				questList:Open()
		 	end)
		end

		--[[-------------------------------------------------------------------------
		---------------------------------------------------------------------------]]


		--[[-------------------------------------------------------------------------
		CUSTOM EDITS TIME, OH BOY!
		---------------------------------------------------------------------------]]
		local questCustomStuffGeneral = AddQuestDetail("DCollapsibleCategory", questEditCategoryList, "Custom Functions (PLEASE READ INSTRUCTIONS BELOW):", "QuestFontQuestSmall", categoryColor, nil, true, categoryColor2)
		local customFunctionHelpText = AddQuestDetail("QuestWrappingDLabel", questCustomStuffGeneral, [[Here is a small explaination for the custom functions: They allow you to define custom actions that occur on top of the default actions performed for their purpose the variables you have access to are "self" and "ply" self is the quest itself, its variables can be found in the save ile for the story quest in the data folder, ply is the player that is performing the function, so turning the quest in, taking it, ect
		
		No headers are needed for the functions, and please, know LUA before touching these at all]],
		"QuestFontQuestStoryEditSmall", aura_quest_color_blue_2)


		local customOnTurnInFunction = questData.OnTurnInCustom or ""
		local customOnTurnInText = AddQuestDetail("QuestWrappingDLabel", questCustomStuffGeneral, "Custom \"OnTurnIn\" function (Runs when player turns quest in)", "QuestFontQuestStoryEdit")
		local onTurnInCustomEdit = AddQuestDetail("DTextEntry", questCustomStuffGeneral, customOnTurnInFunction, "QuestFontQuestStoryEditSmall", nil, function(val)
			local willCompile = AuraTestCustomString(val, "Custom OnTurnIn Function", false)
			if (isfunction(willCompile)) then
				--willCompile(questData, LocalPlayer())
				questData.OnTurnInCustom = val
			else
				AuraDrawErrorPopup("-- Your code will not compile, error below --", willCompile)
			end
	 	end, nil, nil, nil, true)
	 	onTurnInCustomEdit:SetContentAlignment(7)

	 	local customOnTakenFunction = questData.OnTakenCustom or ""
		local customOnTakenText = AddQuestDetail("QuestWrappingDLabel", questCustomStuffGeneral, "Custom \"OnTakenCustom\" function (Runs when player accepts quest)", "QuestFontQuestStoryEdit")
		local onTakenCustomEdit = AddQuestDetail("DTextEntry", questCustomStuffGeneral, customOnTakenFunction, "QuestFontQuestStoryEditSmall", nil, function(val)
			local willCompile = AuraTestCustomString(val, "Custom OnTaken Function", false)
			if (isfunction(willCompile)) then
				--willCompile(questData, LocalPlayer())
				questData.OnTakenCustom = val
			else
				AuraDrawErrorPopup("-- Your code will not compile, error below --", willCompile)
			end
	 	end, nil, nil, nil, true)
	 	onTakenCustomEdit:SetContentAlignment(7)

	 	local customOnCompleteFunction = questData.OnCompleteCustom or ""
		local customOnCompleteText = AddQuestDetail("QuestWrappingDLabel", questCustomStuffGeneral, "Custom \"OnCompleteCustom\" function (Runs when player complete quest objective)", "QuestFontQuestStoryEdit")
		local onCompleteCustomEdit = AddQuestDetail("DTextEntry", questCustomStuffGeneral, customOnCompleteFunction, "QuestFontQuestStoryEditSmall", nil, function(val)
			local willCompile = AuraTestCustomString(val, "Custom OnComplete Function", false)
			if (isfunction(willCompile)) then
				--willCompile(questData, LocalPlayer())
				questData.OnCompleteCustom = val
			else
				AuraDrawErrorPopup("-- Your code will not compile, error below --", willCompile)
			end
	 	end, nil, nil, nil, true)
	 	onCompleteCustomEdit:SetContentAlignment(7)



		--[[-------------------------------------------------------------------------
		---------------------------------------------------------------------------]]

		questEditCategoryList:SetTall(math.max(storyQuestEdit:GetTall() - storyQuestTitlePadding - questPadding * 2 + 1 * aura_scaleY, questEditCategoryList.detailsY))

		questDetails:SetTall(math.max(storyQuestEdit:GetTall() - storyQuestTitlePadding - questPadding * 2 + 1 * aura_scaleY, questEditCategoryList:GetTall()))
		questDetails:SizeToChildren(false,true)

	end

	function AuraDrawDialogueOptionEdit(quest, questDetails, questData, k, v, sub, layer)
		layer = layer or 0
		tab = {25, 50, 75, 100}
		local newTabs = tab
		if (sub) then
			for k,v in pairs(newTabs) do
				newTabs[k] = v + 75 * layer
			end
		end
		local buttonTab = tab[1]
		if (sub) then
			buttonTab = newTabs[2]
		end
		---------- TITLES
		local dialogueTimeTitles = AddQuestDetail("QuestWrappingDLabel", questDetails, "Titles: (one is randomly chosen from the list, or can just be one)", "QuestFontQuestStoryEdit", color_black, nil , true, aura_quest_color_dark_gray, newTabs[1])

		local titles = v.title
		if (istable(titles)) then
			for n,m in pairs(titles) do
				local dialogueTitleText = AddQuestDetail("DTextEntry", questDetails, m, "QuestFontQuestStoryEdit", color_black, function(val)
					v.title[n] = val
				end, true, aura_quest_color_dark_gray, newTabs[2])
			end

			local addTitleButton = AddQuestDetail("DButton", questDetails, "Add to titles", "QuestFontQuestStoryEdit", aura_quest_color_off_blue3, function()
				table.insert(v.title, "New Title")
				RefreshQuestDetails(quest)
		 	end, false, nil, buttonTab)
		 	if (!table.IsEmpty(titles)) then
		 		local removeTitleButton = AddQuestDetail("DButton", questDetails, "Remove from titles", "QuestFontQuestStoryEdit", aura_quest_color_off_red, function()
					
					local entList = DermaMenu()
					for num,ent in pairs(titles) do
						if (!ent) then continue end
						entList:AddOption(num, function() 
							table.remove(v.title,num)
							RefreshQuestDetails(quest)
						end)
					end
					entList:Open()
			 	end, false, nil, buttonTab)
			end
		end
		------------------

		---------- OPTIONS
		local dialogueOptionsTitles = AddQuestDetail("QuestWrappingDLabel", questDetails, "Options:", "QuestFontQuestStoryEdit", color_black, nil , true, aura_quest_color_dark_gray, newTabs[1])
		local options = v.options

		if (!istable(options)) then return end
		for n,m in pairs(options) do
			if (!m or !istable(m) or (istable(m) and table.IsEmpty(m))) then continue end
			local dialogueOptionNumber = AddQuestDetail("QuestWrappingDLabel", questDetails, "Option " .. n .. " (One text is randomly chosen from the list to display)", "QuestFontQuestStoryEdit", color_black, nil , true, aura_quest_color_off_green, newTabs[2])
			if (istable(m.text)) then
				for optionIndex,optionText in pairs(m.text) do
					local dialogueTextNumber = AddQuestDetail("QuestWrappingDLabel", questDetails, "Text " .. optionIndex, "QuestFontQuestStoryEdit", color_black, nil , true, aura_quest_color_gray, newTabs[3])
					local dialogueTitleText = AddQuestDetail("DTextEntry", questDetails, optionText, "QuestFontQuestStoryEdit", color_black, function(val)
						m.text[optionIndex] = val
					end, true, aura_quest_color_dark_gray, newTabs[3])
				end

				local addToTextButton = AddQuestDetail("DButton", questDetails, "Add to text", "QuestFontQuestStoryEdit", aura_quest_color_off_blue3, function()
					table.insert(m.text, "New option text")
					RefreshQuestDetails(quest)
			 	end, false,nil, newTabs[3])
			 	if (!table.IsEmpty(options[n].text)) then
			 		local removeTextButton = AddQuestDetail("DButton", questDetails, "Remove from text", "QuestFontQuestStoryEdit", aura_quest_color_off_red, function()
						local entList = DermaMenu()
						for num,ent in pairs(m.text) do
							entList:AddOption(num, function()
								table.remove(m.text,num)
								RefreshQuestDetails(quest)
							end)
						end
						entList:Open()
				 	end, false,nil, newTabs[3])
				end
			end
			if (m.serverFunc) then
				local serverFuncText = AddQuestDetail("QuestWrappingDLabel", questDetails, "Custom option function (Runs when player clicks option, leave empty for nothing special to happen)", "QuestFontQuestStoryEdit", nil , nil, true, aura_quest_color_gray, newTabs[3])
				local serverFuncEdit = AddQuestDetail("DTextEntry", questDetails, m.serverFunc, "QuestFontQuestStoryEditSmall", nil, function(val)
					local willCompile = AuraTestCustomString(val, "Custom dialogue option Function", false)
					if (isfunction(willCompile)) then
						--willCompile(questData, LocalPlayer())
						m.serverFunc = val
					else
						AuraDrawErrorPopup("-- Your code will not compile, error below --", willCompile)
					end
			 	end, nil, nil, newTabs[3], true)
			 	serverFuncEdit:SetContentAlignment(7)
			end

			if (m.closeMenu != nil) then
				local closeMenuText = AddQuestDetail("QuestWrappingDLabel", questDetails, "Close Menu: (Check box to close the dialogue menu when this option is chosen)", "QuestFontQuestStoryEdit", nil , nil, true, aura_quest_color_gray, newTabs[3])
				local closeMenuEdit = AddQuestDetail("DCheckBox", questDetails, m.closeMenu, "QuestFontQuestStoryEditSmall", nil, function(val)
					m.closeMenu = val
			 	end, nil, nil, newTabs[3])
			 	closeMenuEdit:SetContentAlignment(7)
			end

			if (m and m.subOptions and istable(m.subOptions) and !table.IsEmpty(m.subOptions) and (m.subOptions.title and istable(m.subOptions.title) and !table.IsEmpty(m.subOptions.title))) then
				local dialogueSubOptionsTitles = AddQuestDetail("QuestWrappingDLabel", questDetails, "Sub Option: (These allow you to open more dialogue options by clicking the option", "QuestFontQuestStoryEdit", color_black, nil , true, aura_quest_color_blue_3, newTabs[3])
				AuraDrawDialogueOptionEdit(quest, questDetails, questData, k, m.subOptions, true, layer + 1)
			else
				m.subOptions = {}
			end


			local buttonTab = newTabs[3]
			if (m.subOptions and istable(m.subOptions) and m.subOptions.options and istable(m.subOptions.options)) then
				local addSubOptionButton = AddQuestDetail("DButton", questDetails, "Add option to sub-options (layer " .. layer+1 .. ")" , "QuestFontQuestStoryEdit", aura_quest_color_dark_cyan, function()
					table.insert(m.subOptions.options, {text = {"New sub-option"}, serverFunc = [[]], closeMenu = true, subOptions = {{title = {}, options = {}}}})
					RefreshQuestDetails(quest)
			 	end, false, nil, buttonTab)
			 	if (!table.IsEmpty(m.subOptions.options)) then
			 		local removeSubOptionButton = AddQuestDetail("DButton", questDetails, "Remove option from sub-options (layer " .. layer+1 .. ")", "QuestFontQuestStoryEdit", aura_quest_color_dark_purple, function()
						local entList = DermaMenu()
						for num,ent in pairs(m.subOptions.options) do
							entList:AddOption(num, function()
								table.remove(m.subOptions.options,num)
								RefreshQuestDetails(quest)
							end)
						end
						entList:Open()
				 	end, false, nil, buttonTab)
				end
			else
				local addSubOptions = AddQuestDetail("DButton", questDetails, "Add sub-options (layer " .. layer+1 .. ")" , "QuestFontQuestStoryEdit", aura_quest_color_off_blue6, function()
					m.subOptions = {title = {"New sub-options title"}, options = {{text = {"New sub-option"}, serverFunc = [[]], closeMenu = true}}}
					RefreshQuestDetails(quest)
			 	end, false, nil, buttonTab)
			end
			local removeSubOptions = AddQuestDetail("DButton", questDetails, "Remove sub-options (layer " .. layer+1 .. ")", "QuestFontQuestStoryEdit", aura_quest_color_off_purple, function()
				m.subOptions = nil
				RefreshQuestDetails(quest)
		 	end, false, nil, buttonTab)
		end

		if (!sub) then
			local buttonTab = 25
			if (sub) then
				buttonTab = newTabs[3]
			end

			local addText = "Add to options"
			local removeText = "Remove from options"
			local addOptionButton = AddQuestDetail("DButton", questDetails, addText, "QuestFontQuestStoryEdit", aura_quest_color_off_blue3, function()
				table.insert(v.options, {text = {"New option"}, serverFunc = [[]], closeMenu = true})
				RefreshQuestDetails(quest)
		 	end, false, nil, buttonTab)
		 	if (!table.IsEmpty(options)) then
		 		local removeOptionButton = AddQuestDetail("DButton", questDetails, removeText, "QuestFontQuestStoryEdit", aura_quest_color_off_red, function()
					local entList = DermaMenu()
					for num,ent in pairs(options) do
						entList:AddOption(num, function()
							table.remove(v.options,num)
							RefreshQuestDetails(quest)
						end)
					end
					entList:Open()
			 	end, false, nil, buttonTab)
			end
		end
	end

	function AuraDrawErrorPopup(message, err)
		local frame = vgui.Create("DFrame")
		frame:SetSize(400 * aura_scaleX,100 * aura_scaleY)
		frame:Center()
		frame:MakePopup()
		frame:SetTitle("Uh oh, error!")

		local messageText = vgui.Create("DLabel",frame)
		messageText:SetText(message)
		messageText:SizeToContents()
		messageText:Center()

		local errorText = vgui.Create("DLabel",frame)
		errorText:SetText(err)
		errorText:SizeToContents()
		local x,y = messageText:GetPos()
		y = y + messageText:GetTall() + (10 * aura_scaleY)
		errorText:SetPos(x,y)
		errorText:CenterHorizontal()


		frame:SizeToChildren(true,true)
		messageText:Center()
		x,y = messageText:GetPos()
		y = y + messageText:GetTall() + (10 * aura_scaleY)
		errorText:SetPos(x,y)
		errorText:CenterHorizontal()
	end

	function AuraTestCustomString(val, identifier, errorString)
		val = [[
			local args = { ... }
			local self = args[1]
			local ply = args[2]
		]] .. val
		return CompileString(val,identifier,errorString)
	end

	function RefreshQuestDetails(quest)
		if (IsValid(quest.details)) then
			quest.details:Remove()
			SetQuestDetails(quest)
		end
	end

	function AddQuestDetail(t, parent, title, font, color, edit, category, color2, tab, updateOnTypeTextEntry)
		color2 = color2 or aura_quest_color_gray
		local element = vgui.Create(t,parent)
		local x = 5 * aura_scaleX
		if (tab) then
			x = tab * aura_scaleX
		end
		if (!parent.detailsY) then
			parent.detailsY = 20 * aura_scaleY
			if (parent.newHeader) then
				IncrementDetailsY(parent, parent.newHeader, false)
				parent.detailsY = parent.detailsY - 20 * aura_scaleY
			end
		end
		element:SetPos(x, parent.detailsY)
		element:SetSize(0,40 * aura_scaleY)

		if (t == "DTextEntry") then
			element:SetFont(font)
			element:SetText(title)
			element:SetTextColor(color_black)
			element:SetSkin("Default")
			local lastValue = element:GetValue()


			if (updateOnTypeTextEntry) then
				element:SetVerticalScrollbarEnabled(true)
				element:SetEnterAllowed(false)
				element:SetMultiline(true)
				surface.SetFont(font)
				local x,y = surface.GetTextSize(title)
				element:SetTall(y + 10 * aura_scaleY)

				function element:OnChange()
					surface.SetFont(font)
					local x,y = surface.GetTextSize(title)
					self:SetTall(y + 10 * aura_scaleY)
				end
			end

			function element:OnLoseFocus()
				self:SetFocusTopLevel(false)
				local val = self:GetValue()
				if (self:GetNumeric()) then
					if (!isnumber(tonumber(val))) then
						val = tonumber(lastValue)
						self:SetText(val)
					else
						lastValue = tonumber(self:GetValue())
					end
				end
				edit(val)
			end
			function element:OnValueChange(val)
				if (self:GetNumeric()) then
					if (!isnumber(tonumber(val))) then
						val = tonumber(lastValue)
						self:SetText(val)
					else
						lastValue = tonumber(self:GetValue())
					end
				end
				edit(val)
			end

			element:SetSize(parent:GetWide() - x - (10 * aura_scaleX),element:GetTall())
			IncrementDetailsY(parent, element, false)

			return element
		end

		if (t == "DButton") then
			element:SetFont(font)
			element:SetText(title)
			element:SetTextColor(color_white)
			element:SetSkin("Default")

			function element:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,color or aura_quest_color_off_blue5)
				surface.SetDrawColor(color_white)
				surface.DrawOutlinedRect(0,0,w,h, 2*aura_scaleX)
			end

			function element:DoClick()
				edit()
			end

			element:SetSize(parent:GetWide() - x - 10 * aura_scaleY,element:GetTall())
			IncrementDetailsY(parent, element, false)

			return element
		end

		if (t == "DComboBox") then
			element:SetFont(font)
			element:SetValue(title)
			element:SetTextColor(color_black)
			element:SetTextInset(5 * aura_scaleX, 0)
			element:SizeToContentsX(20 * aura_scaleX)
			element:SetSkin("Default")

			for k,v in pairs(Aura_Quest.QuestTypes) do
				if (v.nonRealQuest) then continue end
				element:AddChoice(k)
			end

			function element:OnSelect(index, value)
				element:SizeToContentsX(20 * aura_scaleX)
				edit(value)
			end

			IncrementDetailsY(parent, element, false)
			return element
		end

		if (t == "DCollapsibleCategory") then
			element:SetSize(parent:GetWide() - x - 10 * aura_scaleY,element:GetTall())
			element:SetLabel("")
			element:SetExpanded( false )
			element:SetSkin("AuraQuestSkins")

			element.newHeader = vgui.Create("QuestWrappingDLabel",element.Header)
			element.newHeader:SetFont(font)
			element.newHeader:SetTextColor(color or color_black)
			element.newHeader:SetWide(parent:GetWide() - 5 * aura_scaleX)
			element.newHeader:SetTextInset(5 * aura_scaleX,0)
			element.newHeader:SetText(title)
			local titleHeight = element.newHeader:GetTall()

			if (category) then
				element:SetTall(60 * aura_scaleY)
				function element:Paint(w,h)
					draw.RoundedBox(0,0,0,w,titleHeight,color2 or aura_quest_color_light_gray)
					draw.RoundedBox(0,0,titleHeight,w,h-titleHeight,aura_quest_color_off_blue7)

					derma.SkinHook( "Paint", "CollapsibleCategory", self, w, titleHeight)
					return false
				end
			end

			element.Header:SizeToChildren(false,true)

			function element:GetHeaderHeight()
				return self.newHeader:GetTall()
			end
			function element:SetHeaderHeight( height )
				self.newHeader:SetTall( height )
			end

			IncrementDetailsY(parent, element, false)

			return element
		end

		if (t == "DCategoryList") then
			element:SetSize(parent:GetWide() - x - 10 * aura_scaleY,300 * aura_scaleY)
			element:SetPos(0, parent.detailsY)

			function element:Paint(w,h)
			end

			IncrementDetailsY(parent, element, false)

			return element
		end

		if (t == "QuestWrappingDLabel") then
			element:SetFont(font)
			element:SetTextColor(color or color_black)
			element:SetWide(parent:GetWide() - x - 10 * aura_scaleX)
			element:SetSkin("Default")

			if (category) then
				element:SetTextInset(5 * aura_scaleX,0)
				function element:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,color2 or aura_quest_color_light_gray)
				end
			end

			element:SetText(title)

			IncrementDetailsY(parent, element, false)

			return element
		end

		if (t == "DCheckBox") then
			element:SetWide(element:GetTall())
			element:SetSkin("Default")

			if (category) then
				function element:Paint(w,h)
					draw.RoundedBox(0,0,0,w,h,color2 or aura_quest_color_light_gray)
				end
			end

			function element:OnChange(val)
				edit(val)
			end

			element:SetValue(title)

			IncrementDetailsY(parent, element, false)

			return element
		end

		return element
	end

	function IncrementDetailsY(parent, element, decrement)
		local mult = 1
		if (decrement) then
			mult = -1
		end
		parent.detailsY = (parent.detailsY or 0) + ((element:GetTall() + spacing) * mult)
	end
	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	--[[-------------------------------------------------------------------------
	This is where we store the list of story quests
	---------------------------------------------------------------------------]]

	local storyQuestList = vgui.Create("DPanel",storyQuestMenu)
	storyQuestList:SetPos(paddingX, titlePadding)
	storyQuestList:SetSize(boxSizeX / 2 - (paddingX * 1.5), boxSizeY - titlePadding - paddingY - paddingX * 2)

	function storyQuestList:Paint(w,h)
		surface.SetDrawColor(aura_quest_color_off_blue5)
		surface.DrawRect(0,0,w,45 * aura_scaleY)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,storyQuestTitlePadding)
		surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
	end

	local storyQuestsTitle = vgui.Create("DLabel", storyQuestMenu)
	storyQuestsTitle:SetText("Story Quests")
	storyQuestsTitle:SetFont("QuestFontQuestMedium")
	storyQuestsTitle:SetTextColor(color_white)
	storyQuestsTitle:SizeToContents()
	storyQuestsTitle:SetPos(0, titlePadding)
	storyQuestsTitle:CenterHorizontal(.25)

	local questScroller = vgui.Create("DScrollPanel", storyQuestList)
	questScroller:Dock( FILL )
	questScroller:DockMargin(questPadding,questPadding + storyQuestTitlePadding,questPadding,questPadding)
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

	local index = 0
	function Aura_AddStoryQuestToScroller(v, autoSelect)
		index = index + 1

		local quest = vgui.Create("DButton", questScroller)
		quest:SetSize(storyQuestList:GetWide() - questPadding * 2, ySize)
		quest:SetPos(0, yPos)
		quest:SetText(v.title)
		quest:SetTextInset(10 * aura_scaleX,0)
		quest:SetTextColor(color_white)
		quest:SetFont("QuestFontQuestTitles")

		quest.questData = v
		quest.index = index
		table.insert(data,quest.questData)
		table.insert(storyQuestButtons,quest)

		SetQuestDetails(quest)
		if (quest.details != nil) then
			quest.details:Hide()
			quest.details:MoveToFront()
		end

		function quest:Paint(w,h)
			if (selectedQuest == self) then
				draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_blue)
			end
			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
		end

		function quest:DoClick()
			if (selectedQuest != nil) then
				if (selectedQuest.details) then
					selectedQuest.details:Hide()
				end
			end
			selectedQuest = self
			if (selectedQuest.details) then
				selectedQuest.details:Show()
				selectedQuest.details:MoveToFront()
				selectedQuest.details:RequestFocus()
			end
		end

		yPos = yPos + yChange

		if (autoSelect) then
			if (selectedQuest and selectedQuest.details) then
				selectedQuest.details:Hide()
			end
			selectedQuest = quest
			if (selectedQuest.details) then
				selectedQuest.details:Show()
			end
		end
	end

	function RemoveStoryQuestFromList()
		table.RemoveByValue(data,selectedQuest.questData)
		local i = selectedQuest.index
		table.remove(storyQuestButtons,i)
		if (selectedQuest.details) then
			selectedQuest.details:Remove()
		end
		selectedQuest:Remove()

		for k,v in pairs(storyQuestButtons) do
			if (v.index > i) then
				v.index = v.index - 1
				local x,y = v:GetPos()
				v:SetPos(x, y - yChange)
			end
		end

		yPos = yPos - yChange
		index = index - 1

		selectedQuest = storyQuestButtons[1] or nil
	end

	for k,v in pairs(quests) do
		Aura_AddStoryQuestToScroller(v)
	end

	selectedQuest = storyQuestButtons[1] or nil

	if (selectedQuest and selectedQuest.details) then
		selectedQuest.details:Show()
		selectedQuest.details:MoveToFront()
	end

	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	--[[-------------------------------------------------------------------------
	Buttons to add / remove a story quest
	---------------------------------------------------------------------------]]
	local addQuestButton = vgui.Create("DButton", storyQuestMenu)
	addQuestButton:SetSize(storyQuestList:GetWide() / 2 - paddingX * .5, paddingY)
	addQuestButton:SetPos(paddingX, boxSizeY - paddingY - paddingX)
	addQuestButton:SetFont("QuestFontQuestMedium")
	addQuestButton:SetText("Add Quest")
	addQuestButton:SetTextColor(color_white)

	addQuestButton.Paint = function(pan, w, h)
		surface.SetDrawColor(aura_quest_color_off_blue3)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
	end

	addQuestButton.DoClick = function()
		local questTypeMenu = DermaMenu()
		for k,v in pairs(Aura_Quest.QuestTypes) do
			if (v.nonRealQuest) then continue end
			questTypeMenu:AddOption(k, function() 
				local quest = AuraGenerateStoryQuest(k, nil, 1, true, "Story Quest " .. (#data + 1))
				Aura_AddStoryQuestToScroller(quest, true)
			end)
		end
		questTypeMenu:Open()
	end

	local removeQuestButton = vgui.Create("DButton", storyQuestMenu)
	removeQuestButton:SetSize(storyQuestList:GetWide() / 2 - paddingX * .5, paddingY)
	removeQuestButton:SetPos(paddingX * 2 + addQuestButton:GetWide(), boxSizeY - paddingY - paddingX)
	removeQuestButton:SetFont("QuestFontQuestMedium")
	removeQuestButton:SetText("Remove Quest")
	removeQuestButton:SetTextColor(color_white)

	removeQuestButton.Paint = function(pan, w, h)
		surface.SetDrawColor(aura_quest_color_off_red)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
	end

	removeQuestButton.DoClick = function()
		if (IsValid(selectedQuest) and selectedQuest) then
			RemoveStoryQuestFromList()
		end
	end

	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	--[[-------------------------------------------------------------------------
	Button to apply changes
	---------------------------------------------------------------------------]]
	local applyChangesButton = vgui.Create("DButton", storyQuestMenu)
	applyChangesButton:SetSize(storyQuestList:GetWide() / 2 - paddingX * .5, paddingY)
	applyChangesButton:SetPos(boxSizeX - applyChangesButton:GetWide() - paddingX, boxSizeY - paddingY - paddingX)
	applyChangesButton:SetFont("QuestFontQuestMedium")
	applyChangesButton:SetText("Apply Changes")
	applyChangesButton:SetTextColor(color_white)

	applyChangesButton.Paint = function(pan, w, h)
		surface.SetDrawColor(aura_quest_color_off_blue3)
		surface.DrawRect(0,0,w,h)
		surface.SetDrawColor(color_white)
		surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
	end

	applyChangesButton.DoClick = function()
		local newData = Aura_CompressQuestData(data)
		local len = string.len(newData)
		net.Start("Aura_Send_Story_Quest_Data")
		net.WriteData(newData,len)
		net.SendToServer()

		storyQuestMenu:Remove()
	end
	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	net.Receive("Aura_Request_Story_Quest_Data", function()
		
	end)
end