include("shared.lua")

function ENT:Draw()
  self:DrawModel()
end


function ENT:Initialize()
	self.modelBoundsMin, self.modelBoundsMax = self:GetModelBounds()

	table.insert(Aura_Quest.QuestLocations,self)
	Aura_Add_Node_To_Table(self)
end

function ENT:OnRemove()
	if (self.GetPermaPropRemoval and self:GetPermaPropRemoval()) then return end
	table.RemoveByValue(Aura_Quest.QuestLocations,self)
	Aura_Remove_Node_From_Table(self)
	if (self.GetQuestType and self:GetQuestType() != "" and self:GetQuestType() != nil and self.GetNodeID and Aura_Quest.QuestTypes[self:GetQuestType()].questType) then
		local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[self:GetQuestType()].questType,self:GetParentNode())
		if (nodeEnt and IsValid(nodeEnt) and self.GetNodeID) then
			if (nodeEnt.childNodes == nil) then
				nodeEnt.childNodes = {}
			end
			table.RemoveByValue(nodeEnt.childNodes,self)
		end
	end
end

aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)

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

local imgSizeX = 700 * aura_scaleX
local imgSizeY = 175 * aura_scaleY
local mainPadding = 10 * aura_scaleX
local titlePadding = 65 * aura_scaleY

net.Receive("Aura_Open_Quest_Location_Menu", function()
	local ent = net.ReadEntity()

	aura_scaleX = (ScrW() / 2560)
	aura_scaleY = (ScrH() / 1440)

	imgSizeX = 700 * aura_scaleX
	imgSizeY = 175 * aura_scaleY
	mainPadding = 10 * aura_scaleX
	titlePadding = 65 * aura_scaleY

	local darkColor = string.ToColor(GetConVarString("quest_main_color_dark"))
    local borderColor = string.ToColor(GetConVarString("quest_border_color"))
    local mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))

	local optionsBox = vgui.Create( "EditablePanel" )
	optionsBox:SetSize( imgSizeX, imgSizeY )
	optionsBox:Center()
	optionsBox:MakePopup()
	optionsBox.yPos = titlePadding + mainPadding

	function optionsBox:Paint(w,h)
		blurpanel(self, 5)
		draw.RoundedBox(0,0,0,w,h,darkColor)
		surface.SetDrawColor(borderColor)

		surface.DrawOutlinedRect(0,0,w,h, 3 * aura_scaleX)
	end

	local closeButton = vgui.Create("DButton", optionsBox)
	closeButton:SetSize(30 * aura_scaleX, 30 * aura_scaleY)
	closeButton:SetPos(optionsBox:GetWide() - closeButton:GetWide() - 13 * aura_scaleX, 10 * aura_scaleY)
	closeButton:SetText("")

	closeButton.Paint = function(pan, w, h)
		surface.SetDrawColor(aura_quest_color_red)
		surface.DrawLine(0, 0, w, h)
		surface.DrawLine(0, h, w, 0)
	end

	closeButton.DoClick = function()
		optionsBox:Remove()
	end

	local data = {}

	local title = vgui.Create("DLabel", optionsBox)
	title:SetText("Quest Location Options")
	title:SetFont("QuestFontQuestTitles")
	title:SetTextColor(mainTextColor)
	title:SizeToContents()
	title:SetPos(0, mainPadding)
	title:CenterHorizontal()

	function title:Paint(w,h)
		surface.SetDrawColor(borderColor)
		surface.DrawLine(0,h-1,w,h-1)
	end

	local questType = vgui.Create("DLabel", optionsBox)
	questType:SetText("Quest Type: ")
	questType:SetFont("QuestFontQuestSmall")
	questType:SetTextColor(mainTextColor)
	questType:SizeToContents()
	questType:SetPos(mainPadding, optionsBox.yPos)

	local questTypeX, questTypeY = questType:GetPos()

	local chosenType = ent:GetQuestType()

	local questTypeChooser = vgui.Create( "DComboBox", optionsBox )
	questTypeChooser:SetPos( questTypeX + questType:GetWide() + 5 * aura_scaleX, questTypeY )
	questTypeChooser:SetSize( 100 * aura_scaleX, questType:GetTall() )
	questTypeChooser:SetFont("QuestFontQuestSmall")
	questTypeChooser:SetTextColor(color_black)
	questTypeChooser:SetValue( chosenType )
	questTypeChooser:SizeToContentsX(20 * aura_scaleX)
	for k,v in pairs(Aura_Quest.QuestTypes) do
		questTypeChooser:AddChoice( k )
	end
	local nodeChooser

	data.QuestType = questTypeChooser:GetValue()
	questTypeChooser.OnSelect = function( self, index, value )
		data.QuestType = value
		chosenType = value
		if (Aura_Quest.QuestTypes[value] and Aura_Quest.QuestTypes[value].spawnPoint) then
			if (nodeChooser and IsValid(nodeChooser)) then
				nodeChooser:Remove()
			end
			data.spawnPoint = true
			nodeChooser = Aura_DrawNodeChoosingSection(optionsBox, Aura_Quest.QuestTypes[value].questType, ent)
			nodeChooser.OnValueChange = function(chooser, val)
				local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[value].questType, val)
				if (nodeEnt and IsValid(nodeEnt)) then
					data.ParentNode = val
				else
					nodeChooser:SetText("That is not a valid node of type: " .. Aura_Quest.QuestTypes[value].questType)
				end
			end
		end
		questTypeChooser:SizeToContentsX(20 * aura_scaleX)
	end

	optionsBox.yPos = optionsBox.yPos + questTypeChooser:GetTall() + 10 * aura_scaleY

	optionsBox.acceptButton = vgui.Create("DButton", optionsBox)
	optionsBox.acceptButton:SetSize(100 * aura_scaleX, 50 * aura_scaleY)
	optionsBox.acceptButton:SetText("Apply Changes")
	optionsBox.acceptButton:SetFont("QuestFontQuestSmall")
	optionsBox.acceptButton:SetTextColor(mainTextColor)
	optionsBox.acceptButton:SizeToContents()
	optionsBox.acceptButton:SetPos(optionsBox:GetWide() - optionsBox.acceptButton:GetWide() - mainPadding, imgSizeY - optionsBox.acceptButton:GetTall() - mainPadding)

	function optionsBox.acceptButton:Paint(w,h)
		blurpanel(self, 10)
		draw.RoundedBox(0,0,0,w,h,aura_quest_color_dark_green2)
		surface.SetDrawColor(borderColor)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	function optionsBox.acceptButton:DoClick()
		if (nodeChooser and IsValid(nodeChooser) and nodeChooser.GetValue) then
			data.ParentNode = nodeChooser:GetValue()
			local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[chosenType].questType,nodeChooser:GetValue())
			if (nodeEnt and IsValid(nodeEnt) and ent.GetNodeID) then
				if (nodeEnt.childNodes == nil) then
					nodeEnt.childNodes = {}
				end
				if (!table.HasValue(nodeEnt.childNodes,ent:GetNodeID())) then
					table.insert(nodeEnt.childNodes,ent:GetNodeID())
				end
			end
		end

		net.Start("Aura_Change_Quest_Location_Details")
		net.WriteEntity(ent)
		net.WriteTable(data)
		net.SendToServer()

		Aura_Add_Node_To_Table(ent)

		optionsBox:Remove()
	end

	if (Aura_Quest.QuestTypes[chosenType] and Aura_Quest.QuestTypes[chosenType].spawnPoint) then
		nodeChooser = Aura_DrawNodeChoosingSection(optionsBox, Aura_Quest.QuestTypes[chosenType].questType, ent)
		nodeChooser.OnValueChange = function(chooser, val)
			local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[chosenType].questType, val)
			if (nodeEnt and IsValid(nodeEnt)) then
				data.ParentNode = val
			else
				nodeChooser:SetText("That is not a valid node of type: " .. Aura_Quest.QuestTypes[chosenType].questType)
			end
		end
	end

end)

function Aura_DrawNodeChoosingSection(optionsBox, t, ent)
	local darkColor = string.ToColor(GetConVarString("quest_main_color_dark"))
	local borderColor = string.ToColor(GetConVarString("quest_border_color"))
	local mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))

	local nodeText = vgui.Create("DLabel",optionsBox)
	nodeText:SetPos(mainPadding, optionsBox.yPos)
	nodeText:SetText("Parent Node: ")
	nodeText:SetFont("QuestFontQuestSmall")
	nodeText:SetTextColor(mainTextColor)
	nodeText:SizeToContents()

	local nodeChooser = vgui.Create("DTextEntry",optionsBox)
	nodeChooser:SetPos(mainPadding + nodeText:GetWide(), optionsBox.yPos)
	nodeChooser:SetSize(imgSizeX - nodeText:GetWide() - mainPadding * 2, nodeText:GetTall())
	nodeChooser:SetFont("QuestFontQuestSmall")
	local currentNode = ent:GetParentNode()
	local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[t].questType, currentNode)
	if (!nodeEnt or !IsValid(nodeEnt)) then
		currentNode = nil
	end

	if (currentNode == "" or currentNode == nil) then
		currentNode = Aura_GetRandomNodeOfType(t)
	end
	nodeChooser:SetValue(currentNode)
	nodeChooser:SetTextColor(color_black)

	optionsBox.yPos = optionsBox.yPos + nodeChooser:GetTall() + 10 * aura_scaleY

	local randomNode = vgui.Create("DButton", optionsBox)
	randomNode:SetPos(mainPadding, optionsBox.yPos)
	randomNode:SetSize(imgSizeX - mainPadding * 2, 40 * aura_scaleY)
	randomNode:SetFont("QuestFontQuestSmall")
	randomNode:SetTextColor(mainTextColor)
	randomNode:SetText("Choose random node for type: " .. t)

	function randomNode:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,darkColor)
		surface.SetDrawColor(borderColor)

		surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
	end

	function randomNode:DoClick()
		nodeChooser:SetValue(Aura_GetRandomNodeOfType(t))
	end

	optionsBox:SizeToChildren(false,true)
	optionsBox:SetTall(optionsBox:GetTall() + optionsBox.acceptButton:GetTall() + mainPadding * 2)
	optionsBox.acceptButton:SetPos(optionsBox:GetWide() - optionsBox.acceptButton:GetWide() - mainPadding, optionsBox:GetTall() - optionsBox.acceptButton:GetTall() - mainPadding)

	return nodeChooser
end

function Aura_GetRandomNodeOfType(t)
	local node = nil
	local nodes = Aura_Quest.Nodes
	if (nodes and nodes[t] and !table.IsEmpty(nodes[t])) then
		node = table.Random(nodes[t])
		if (node.GetNodeID) then
			node = node:GetNodeID()
		else
			node = nil
		end
	end
	if (!node) then
		node = "No valid node found for type: " .. t
	end
	return node
end