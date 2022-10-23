Aura_Quest = Aura_Quest or {}

Aura_Quest.Nodes = -- Do not change or put anything here
{
	
}

Aura_Quest.QuestNPCs = -- Do not change or put anything here
{
	
}

Aura_Quest.Quests = {} -- Where we will store all our quests (post per-NPC update this will only be story quests)

Aura_Quest.QuestCount = 0 -- How many quests do we have (do not change this value)

Aura_Quest.QuestTypesWeighted = {} -- To make our quest chances weighted, I will need to populate a table to store roughly 100 values, each value a percent chance to be chosen

Aura_Quest.DefaultQuestMenuIcon = "aura_quest_unknown_quest_icon.png" -- The default image to use if a quest type does not have an icon image path

Aura_Quest.DifficultyGraphic = "aura_quest_difficulty_symbol.png"
Aura_Quest.DifficultyColor = Color(217, 213, 0, 255)

function Aura_Populate_Node_Table()
	Aura_Quest.Nodes = {}

	for k,v in pairs(Aura_Quest.QuestTypes) do
		Aura_Quest.Nodes[k] = {}
		if (v.dropOff) then
			Aura_Quest.Nodes[k].dropOff = true
			Aura_Quest.Nodes[k].nodes = {}
		end
	end

	for k,v in pairs(ents.FindByClass("aura_quest_location_marker")) do
		Aura_Add_Node_To_Table(v)
	end
end

function Aura_Add_Node_To_Table(node)
	local questType = node:GetQuestType()
	if (Aura_Quest.Nodes[questType] and node.GetNodeID and node:GetNodeID() != nil and node:GetNodeID() != "") then
		if (Aura_Quest.Nodes[questType].dropOff) then
			Aura_Quest.Nodes[questType].nodes[node:GetNodeID()] = node
		else
			Aura_Quest.Nodes[questType][node:GetNodeID()] = node
		end
	end
end

function Aura_Remove_Node_From_Table(node, questType, id)
	questType = questType or node:GetQuestType()
	if (Aura_Quest.Nodes[questType] and node.GetNodeID) then
		id = id or node:GetNodeID()
		if (Aura_Quest.Nodes[questType].dropOff) then
			if (Aura_Quest.Nodes[questType].nodes[id]) then
				Aura_Quest.Nodes[questType].nodes[id] = nil
			end
		else
			if (Aura_Quest.Nodes[questType][id]) then
				Aura_Quest.Nodes[questType][id] = nil
			end
		end
	end
end

function Aura_Populate_NPC_Table()
	Aura_Quest.QuestNPCs = {}
	for k,v in pairs(ents.FindByClass("aura_quest_npc")) do
		Aura_Quest.QuestNPCs[v:GetNodeID()] = v
	end
end

function Aura_Sync_Story_Quests()
	if (GetStoryQuestData) then
		local quests = GetStoryQuestData()
		Aura_Quest.Quests = quests
	end
end

Aura_Populate_Node_Table()
Aura_Populate_NPC_Table()

if (SERVER) then

	--[[-------------------------------------------------------------------------
	This allows us to add "weighted" quest types, essentially it just totals the amount of chances for all types
	Then fills a table with each types chances, allowing us to have a semi-weighted system of random quest types
	---------------------------------------------------------------------------]]
	local total = 0
	for k,v in pairs(Aura_Quest.QuestTypes) do
		total = total + v.chance
		for i=1,v.chance do
			table.insert(Aura_Quest.QuestTypesWeighted,k)
		end
	end
	--[[-------------------------------------------------------------------------
	This is mainly for when I am working on this and saving it so my current
	nodes are not overriden and deleted from the table
	---------------------------------------------------------------------------]]

	Aura_Sync_Story_Quests()

	--[[-------------------------------------------------------------------------
	---------------------------------------------------------------------------]]

	function AuraGenerateQuest(npc, rewards, difficulty, story, title)
		local t = Aura_Quest.QuestTypesWeighted[math.random(1,total)]
		local r = table.Copy(rewards) or table.Copy(Aura_Quest.QuestTypes[t].rewards)

		story = story or false
		title = title or ""

		local diffs = {}
		for i=1,Aura_Quest.MaxRandomDifficulty do
			for k=1,Aura_Quest.MaxRandomDifficulty - (i - 1) do
				table.insert(diffs,i)
			end
		end

		difficulty = difficulty or table.Random(diffs) or 1

		local quest = Quest(npc, t, r, difficulty, story, title)
		--table.insert(Aura_Quest.Quests,quest)

		return quest
	end

	--[[-------------------------------------------------------------------------
	mmmmmmmmm net messaging......
	---------------------------------------------------------------------------]]
	util.AddNetworkString("Aura_Quest_Open_Story_Menu")
	util.AddNetworkString("Aura_Set_Player_Quest")
	util.AddNetworkString("Aura_Sync_Quests")
	util.AddNetworkString("Aura_Abandon_Quest")
	util.AddNetworkString("Aura_Open_Quest_Location_Menu")
	util.AddNetworkString("Aura_Change_Quest_Location_Details")
	util.AddNetworkString("Aura_Change_Node_ID")
	util.AddNetworkString("Aura_Set_Node_Children")
	util.AddNetworkString("Aura_Toggle_Quest_Debug_Mode")
	util.AddNetworkString("Aura_Turn_In_Quest")
	util.AddNetworkString("Aura_Sync_Player_Quest_Data")
	util.AddNetworkString("Aura_Update_Quest_Progress")
	util.AddNetworkString("Aura_Send_Story_Quest_Data")
	util.AddNetworkString("Aura_Quest_Open_NPC_Dialogue_Box")
	util.AddNetworkString("Aura_Start_ClientSide_Quest_Timer")
	util.AddNetworkString("Aura_Quest_Send_Client_Langauge_Message")

	function AuraSyncQuestsToClient(ply, npc)
		local data
		if (npc) then
			data = Aura_CompressQuestData(npc.QuestTable)
			net.Start("Aura_Sync_Quests")
			net.WriteBool(true)
			net.WriteEntity(npc)
			net.WriteData(data)
			net.Send(ply)
		end

		data = Aura_CompressQuestData(Aura_Quest.Quests)
		net.Start("Aura_Sync_Quests")
		net.WriteBool(false)
		net.WriteData(data)
		net.Send(ply)
	end

	function AuraSyncPlayerQuestToClient(ply)
		local data = Aura_CompressQuestData(ply.questData)
		net.Start("Aura_Sync_Player_Quest_Data")
		net.WriteData(data)
		net.Send(ply)
	end

	function AuraUpdateQuestProgression(quest, ply, percent)
		local stages = quest.stages
		if (quest.editableValues and quest.editableValues["Spawn Number"]) then
			stages = quest.editableValues["Spawn Number"]
		end
		if (stages) then
			local prog = quest.progress or 0
			prog = prog + (1/stages * percent)
			quest.progress = prog
			return prog
		end
		return 0
	end

	net.Receive("Aura_Set_Player_Quest", function(len, ply)
		local quest = Aura_DecompressQuestData(net.ReadData(len))
			
		if (!quest) then
			return
		end
		local copy = table.Copy(quest)

		if (copy.story) then
			ply.questData["Story"] = copy
		else
			if (!copy.waitForQuestTrigger) then
				timer.Create(ply:SteamID64() .. "QuestTimer",copy.time,1, function()
					if (IsValid(ply) and ply.questData["NonStory"] == copy) then
						AuraAbandonQuest(ply, ply.questData["NonStory"], true)
					end
				end)
				net.Start("Aura_Start_ClientSide_Quest_Timer")
				net.WriteInt(copy.time,32)
				net.WriteBool(copy.story)
				net.Send(ply)
			end
			ply.questData["NonStory"] = copy
		end

		copy.progress = 0
		net.Start("Aura_Update_Quest_Progress")
		net.WriteBool(copy.story)
		net.WriteInt(0,32)
		net.Send(ply)

		Aura_OnTakenQuest(copy, ply)
	end)

	net.Receive("Aura_Abandon_Quest", function(len, ply)
		local quest = net.ReadTable()

		AuraAbandonQuest(ply, quest, false)
	end)

	net.Receive("Aura_Quest_Open_NPC_Dialogue_Box", function(len, ply)
		local ent = net.ReadEntity()
		local func = net.ReadString()
		local story = net.ReadBool()
		local questData = ply.questData["NonStory"]
		if (story) then
			questData = ply.questData["Story"]
		end
		Aura_Run_Quest_Function(questData, func, ply, ent)
	end) 

	net.Receive("Aura_Turn_In_Quest", function(len, ply)
		local one = net.ReadBool()
		local questData = ply.questData["Rewards"]

		if (one) then
			local questNum = net.ReadInt(32)
			local quest = questData[questNum]
			Aura_OnTurnInQuest(quest, ply)
			table.remove(ply.questData["Rewards"],questNum)
		else
			for k,v in pairs(questData) do
				Aura_OnTurnInQuest(v, ply)
			end
			ply.questData["Rewards"] = {}
		end
		UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
		AuraSyncPlayerQuestToClient(ply)
	end)

	net.Receive("Aura_Send_Story_Quest_Data", function(len, ply)
		if (Aura_Quest.StoryQuestPrivilages[ply:GetUserGroup()]) then
			-- Essentially all this does is delete all story quest related data, then re-write it, because when trying to edit it, a ton of bugs came up that just make things infinitely harder to figure out >:(

			local questData = Aura_DecompressQuestData(net.ReadData(len))
			local currentStoryData = GetStoryQuestData()

			for k,v in pairs(currentStoryData) do
				DeleteStoryQuestData(v.title)
			end

			-- I have to clear out the quest table, otherwise for some reason, duplicates appear in it even when I removed all story quests before adding them again
			Aura_Quest.Quests = {}

			for k,v in pairs(questData) do
				UpdateStoryQuestData(v, ply)
				table.insert(Aura_Quest.Quests,v)
			end

		else
			ply:ChatPrint("Nice try bucko.")
		end
	end)

	function Aura_Send_Language_Message_To_Client(ply, msg)
		net.Start("Aura_Quest_Send_Client_Langauge_Message")
		net.WriteString(msg)
		net.Send(ply)
	end

	function Aura_Run_Quest_Function(quest, func, ply, ...)
		local args = { ... }
		func = [[
			local args = { ... }
			local self = args[1]
			local ply = args[2]
		]] .. func
		local funcString = CompileString(func,"Quest function running")
		funcString(quest, ply, args)
	end

	function AuraAbandonQuest(ply, quest, timeOut)
		if (!quest) then
			ply:ChatPrint("#Aura_Quest_Something_Went_Wrong")
			return
		end
		if (timeOut) then
			AuraPrintQuestMessage(ply, "#Aura_Quest_Out_Of_Time")
		end

		local ents = quest.questEntities
		if (ents) then
			for k,v in pairs(ents) do
				local ent = Entity(v)
				if (ent and IsValid(ent)) then
					ent.quest = nil
					ent:Remove()
				end
			end
		end

		Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Given_Up " .. quest.title)

		AuraDropQuest(ply, quest.story)
		quest = nil
	end

	function AuraDropQuest(ply, story)
		if (story) then
			ply.questData["Story"] = false
		else
			ply.questData["NonStory"] = false
		end
		if (timer.Exists(ply:SteamID64() .. "QuestTimer")) then
			timer.Destroy(ply:SteamID64() .. "QuestTimer")
		end

		AuraSyncPlayerQuestToClient(ply)
		UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
	end

	function AuraReceiveQuestRewards(ply, quest)

		if (DarkRP and quest.rewards.money) then
			Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Reward_Gotten #Aura_Quest_Money_Symbol  " .. quest.rewards.money)
			ply:addMoney(quest.rewards.money)
		end
		if (wOS and quest.rewards.wiltosXP) then
			if (ply.AddSkillXP) then
				Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Reward_Gotten " .. quest.rewards.wiltosXP .. " #Aura_Quest_wOS_XP")
				ply:AddSkillXP(quest.rewards.wiltosXP)
			end
		end
		local typeData = Aura_Quest.QuestTypes[quest.type]
		if (typeData.customRewardFunction) then
			typeData.customRewardFunction(quest, ply)
		end
	end

	function AuraGetPlayerQuestEntityTable(ply)
		if (ply.questData and ply.questData["Story"]) then
			local entTable = {}
			local questData = ply.questData["Story"]
			local ent = questData.entity
			if (ent and isnumber(ent)) then
				ent = Entity(ent)
				if (ent and IsValid(ent)) then
					local entDataTable = AuraGetQuestEntityTable(ent)

					entTable.primaryEnt = entDataTable
					entDataTable = nil
				end
			end
			local ent2 = questData.secondaryObj
			if (ent2 and isnumber(ent2)) then
				ent2 = Entity(ent2)
				if (ent2 and IsValid(ent2)) then
					local entDataTable = AuraGetQuestEntityTable(ent2)

					entTable.secondaryEnt = entDataTable
					entDataTable = nil
				end
			end

			if (questData.enemyEntities) then
				local entDataTable = {}
				for k,v in pairs(questData.enemyEntities) do
					local ent = AuraGetQuestEntityTable(ply)
					if (ent) then
						table.insert(entDataTable,ent)
					end
				end

				entTable.enemyEntities = entDataTable
				questData.enemyEntities = nil
				entDataTable = nil
			end
			return entTable
		end
	end

	function AuraReplacePlayerQuestEntityTable(ply, data)
		local questData = ply.questData["Story"]
		if (data and data.primaryEnt) then
			local newData = data.primaryEnt
			local ent = AuraCreateEntityFromTable(newData)

			questData.entity = ent:EntIndex()
			questData.entPos = ent:GetPos()
			ent.quest = questData
			ent.questPly = ply:SteamID64()
			if (questData.questDialogue) then
				if (Aura_Quest.QuestTypes[questData.type].protect) then
					ent.questDialogue = questData.questDialogue
					ent.willTriggerDialogue = true
				end
			end
		end
		if (data and data.secondaryEnt) then
			local newData = data.secondaryEnt
			local ent = AuraCreateEntityFromTable(newData)

			questData.secondaryObj = ent:EntIndex()
			ent.deliveryDropOff = true
			ent.quest = questData
		end
		if ( data and data.enemyEntities) then
			questData.enemyEntities = {}
			for n,m in pairs(data.enemyEntities) do
				local ent = AuraCreateEntityFromTable(m)
				ent.quest = questData
				ent.questPly = ply:SteamID64()
				ent.secondaryEntity = true
				table.insert(questData.enemyEntities,ent)
			end
			timer.Simple(1, function()
				if (IsValid(ply) and questData) then
					Aura_CreateSecondaryQuestEntities(questData, ply, questData.wave)
				end
			end)
		end
	end
end

if (CLIENT) then
	local blur = Material'pp/blurscreen'

	function blurpanel(panel, amount)
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


	Aura_Quest.QuestLocations = ents.FindByClass("aura_quest_location_marker")

	net.Receive("Aura_Quest_Send_Client_Langauge_Message", function()
		local msg = string.PatternSafe(net.ReadString())
		local newString = ""
		local phraseStart = 0
		local phraseEnd = 0
		local phrase
		local lang = ""

		for i=1,#msg do
			if (msg[i] == "") then break end
			if (msg[i] == "#") then
				phraseStart = i
				phraseEnd = #msg
				for k=i + 1,#msg do	
					if (msg[k] == " ") then
						phraseEnd = k - 1
						break
					end
				end

				phrase = string.sub(msg,phraseStart + 1,phraseEnd)
				lang = language.GetPhrase(phrase)
				msg = string.sub(msg,phraseEnd)
				newString = newString .. lang
			else
				newString = newString .. msg[i]
			end
		end

		AuraPrintQuestMessage(LocalPlayer(), newString)
	end)
	net.Receive("Aura_Start_ClientSide_Quest_Timer", function()
		local time = net.ReadInt(32)
		local ply = LocalPlayer()
		local story = net.ReadBool()
		if (time != 0) then
			timer.Create(ply:SteamID64() .. "QuestTimer",time,1, function()
			end)
		end
	end)

	net.Receive("Aura_Sync_Quests", function(len)
		local npcData = net.ReadBool()
		local data
		if (npcData) then
			local npc = net.ReadEntity()
			data = net.ReadData(len)
			npc.QuestTable = Aura_DecompressQuestData(data)
		else
			data = net.ReadData(len)
			Aura_Quest.Quests = Aura_DecompressQuestData(data)
		end
	end)

	net.Receive("Aura_Sync_Player_Quest_Data", function(len)
		local data = net.ReadData(len)
		LocalPlayer().questData = Aura_DecompressQuestData(data)
	end)

	net.Receive("Aura_Toggle_Quest_Debug_Mode", function()
		LocalPlayer().Aura_Quest_Debug_Mode = net.ReadBool()
	end)

	net.Receive("Aura_Update_Quest_Progress", function()
		local questData = LocalPlayer().questData
		local story = net.ReadBool()
		local amount = net.ReadInt(32)
		if (story) then
			questData = questData["Story"]
		else
			questData = questData["NonStory"]
		end
		if (questData) then
			questData.progress = amount
		end
	end)

	net.Receive("Aura_Quest_Open_NPC_Dialogue_Box", function(len)
		local ent = net.ReadEntity()
		local story = net.ReadBool()
		local dialogue = Aura_DecompressQuestData(net.ReadData(len))

		if (table.IsEmpty(dialogue) or (dialogue.title and istable(dialogue.title) and table.IsEmpty(dialogue.title))) then return end

		local newDialogue = table.Copy(dialogue)
		local dialogueBox, titleText, optionsScroller = Aura_DrawNPCDialogueBase(ent)

		Aura_PopulateDialogueChildBranches(dialogueBox, ent, newDialogue.options, story)
		

		local title = newDialogue.title
		if (istable(title)) then
			title = table.Random(title)
		end

		dialogueBox:PopulateDialogueBox(title, newDialogue.options, 1, .2, false)

	end)

	function Aura_PopulateDialogueChildBranches(dialogueBox, ent, options, story)
		for k,v in pairs(options) do
			local runFunc = function()
				net.Start("Aura_Quest_Open_NPC_Dialogue_Box")
				net.WriteEntity(ent)
				net.WriteString(v.serverFunc)
				net.WriteBool(story)
				net.SendToServer()
			end
			v.func = runFunc
			if (v.subOptions and istable(v.subOptions) and !table.IsEmpty(v.subOptions)) then
				Aura_PopulateDialogueChildBranches(dialogueBox, ent, v.subOptions.options)
				v.func = function()
					runFunc()
					if (dialogueBox and v.subOptions.title and v.subOptions.options) then
						local title = v.subOptions.title
						if (istable(title)) then
							title = table.Random(title)
						end
						dialogueBox:PopulateDialogueBox(title, v.subOptions.options, 1, .2, false)
					end
				end
			end
			if (istable(v.text)) then
				v.text = table.Random(v.text)
			end
		end
	end

	function Aura_DrawNPCDialogueBase(ent)
		local dialogueBox = vgui.Create( "QuestDialogueBox" )
		dialogueBox:SetNPC(ent)

		return dialogueBox, dialogueBox.titleText, dialogueBox.optionsScroller
	end

	local difficultyTable = {}
	for i=1,Aura_Quest.MaxRandomDifficulty do
		for k=1,Aura_Quest.MaxRandomDifficulty - (i - 1) do
			table.insert(difficultyTable,i)
		end
	end

	function AuraGenerateStoryQuest(t, rewards, difficulty, story, title)
		local r = rewards or table.Copy(Aura_Quest.QuestTypes[t].rewards)
		title = title or ""

		if (!difficultyTable) then
			difficultyTable = {}
			for i=1,Aura_Quest.MaxRandomDifficulty do
				for k=1,Aura_Quest.MaxRandomDifficulty - (i - 1) do
					table.insert(difficultyTable,i)
				end
			end
		end

		difficulty = difficulty or table.Random(difficultyTable) or 1

		local quest = Quest(nil, t, r, difficulty, true, title)
		quest.playersCompleted = {}
		-- We don't put this in the quest table yet because we haven't applied changes

		return quest
	end
end

--[[-------------------------------------------------------------------------
Saving all quest data (Creates folder in garrysmod/data)
---------------------------------------------------------------------------]]
function CreateQuestDataFile()
	if (!file.Exists(Aura_Quest.FolderName,"DATA")) then
		file.CreateDir(Aura_Quest.FolderName)
	end
	if (!file.Exists(Aura_Quest.FolderName .. "/" .. Aura_Quest.StoryFolderName,"DATA")) then
		file.CreateDir(Aura_Quest.FolderName .. "/" .. Aura_Quest.StoryFolderName)
	end
end
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Mmmmmmmm compression time!
---------------------------------------------------------------------------]]

function Aura_CompressQuestData(data)
	return util.Compress(util.TableToJSON(data))
end

function Aura_DecompressQuestData(data)
	return util.JSONToTable(util.Decompress(data))
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Saving each players quests data
---------------------------------------------------------------------------]]
function CreatePlayerQuestData(steamID64)
	CreateQuestDataFile()

	if (!file.Exists(Aura_Quest.FolderName .. "/" .. steamID64 .. ".txt","DATA")) then
		file.Write(Aura_Quest.FolderName .. "/" .. steamID64 .. ".txt","")
	end
end

function UpdatePlayerQuestData(steamID64, data)
	CreatePlayerQuestData(steamID64)

	data = util.TableToJSON(data, true)
	file.Write(Aura_Quest.FolderName .. "/" .. steamID64 .. ".txt",data)
end

function GetPlayerQuestData(steamID64)
	CreatePlayerQuestData(steamID64)

	local data = file.Read(Aura_Quest.FolderName .. "/" .. steamID64 .. ".txt",data) or ""
	data = util.JSONToTable(data)
	if (data == nil or data == "") then
		data = {}
	end

	return data
end
--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]


--[[-------------------------------------------------------------------------
Saving story quest data specifically
---------------------------------------------------------------------------]]
function UpdateStoryQuestData(data, ply, titleChange, oldTitle)
	CreateQuestDataFile()

	if (istable(data) and !table.IsEmpty(data)) then
		-- Gotta make sure we know who made edits to this for security reasons
		if (ply) then
			data.lastEditor = ply:SteamID64()
			local timestamp = os.time()
			local timeString = os.date( "%H:%M:%S - %d/%m/%Y" , timestamp )
			data.lastEditTime = timeString
		end

		local fileName = GetStoryQuestFileName(data.title)
		if (titleChange and oldTitle != "") then
			local fileNameOld = GetStoryQuestFileName(oldTitle)
			DeleteStoryQuestData(fileNameOld)
		end

		--print("Writing file for " .. data.title)
		data = util.TableToJSON(data, true)

		file.Write(fileName,data)
	end
end

function GetStoryQuestFileName(title)
	return Aura_Quest.FolderName .. "/" .. Aura_Quest.StoryFolderName .. "/" .. string.lower(string.Replace(title," ","_")) .. ".txt"
end

function GetStoryQuestData()
	CreateQuestDataFile()
	local storyQuests = {}

	local files, directories = file.Find( Aura_Quest.FolderName .. "/" .. Aura_Quest.StoryFolderName .. "/" .. "*", "DATA" )

	for k,v in pairs(files) do
		local data = file.Read(Aura_Quest.FolderName .. "/" .. Aura_Quest.StoryFolderName .. "/" .. v,data) or ""
		data = util.JSONToTable(data)
		table.insert(storyQuests,data)
	end

	return storyQuests or {}
end

function AuraPlayerHasQuestRequirements(quest, ply)
	local requiredQuests = quest.requiredQuests or {}
	local doesNotHaveComplete = {}
	for k,v in pairs(requiredQuests) do
		local hasQuest = AuraGetPlayerCompletedQuestByTitle(v, ply)
		if (!hasQuest) then
			table.insert(doesNotHaveComplete,v)
		end
	end
	if (table.IsEmpty(doesNotHaveComplete)) then
		return true
	end
	
	return doesNotHaveComplete
end

function AuraGetPlayerCompletedQuestByTitle(title, ply)
	local storyQuests = GetStoryQuestData()
	for k,v in pairs(storyQuests) do
		if (v.title == title) then
			return table.HasValue(v.playersCompleted,ply:SteamID64())
		end
	end
	return false
end

function DeleteStoryQuestData(title)
	local fileName = GetStoryQuestFileName(title)
	if (file.Exists(fileName,"DATA")) then
		file.Delete(fileName)
	end
end

function GetNodeFromID(t,id)
	if (!Aura_Quest.Nodes or !Aura_Quest.Nodes[t]) then return nil end
	return Aura_Quest.Nodes[t][id]
end

function GetSecondNodeFromID(self,id)
	if (!self.node2Type) then return nil end
	return Aura_Quest.Nodes[self.node2Type].nodes[id]
end

function GetNPCFromID(id)
	return Aura_Quest.QuestNPCs[id]
end

function AuraGetQuestEntityTable(ent)
	local entDataTable = {}
	if (!IsValid(ent) or !IsEntity(ent) or !ent) then return nil end
	entDataTable.model = ent:GetModel()
	entDataTable.hp = ent:Health()
	entDataTable.maxHP = ent:GetMaxHealth()
	entDataTable.position = ent:GetPos()
	local wep = ""
	if (ent:IsNPC()) then
		wep = ent:GetActiveWeapon() or nil
		if (IsValid(wep) and wep) then
			wep = wep:GetClass()
		end
	end
	entDataTable.wep = wep
	entDataTable.scale = ent:GetModelScale()
	entDataTable.class = ent:GetClass()

	return entDataTable
end

function AuraCreateEntityFromTable(data)
	local ent = ents.Create(data.class)
	ent:SetModel(data.model)
	ent:SetPos(data.position)
	ent:Spawn()
	ent:Activate()
	ent:SetHealth(data.hp)
	ent:SetMaxHealth(data.maxHP)
	if (isstring(data.wep) and data.wep != "") then
		ent:Give(data.wep)
	end

	return ent
end

function AuraPrintQuestMessage(ply, message)
	ply:ChatPrint(message)
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]
