Aura_Quest = Aura_Quest or {}
--[[-------------------------------------------------------------------------
This is our official "QuestClass", an object class, but made in GLua!
---------------------------------------------------------------------------]]
local QuestClass 		= {}

-- Some basic vars for our quest "objects"
QuestClass.player 		= nil             -- The player object assigned to this quest
QuestClass.rewards 		= {}               -- How much the player should be paid for the quest
QuestClass.difficulty 	= 1               -- How difficult the quest is (higher is harder)
QuestClass.description 	= ""              -- What you have to do for the quest
QuestClass.type 		= "none"          -- Our actual "type" of quest
QuestClass.node 		= nil             -- The "node" (location) entity of this quest
QuestClass.story 		= false			  -- Is this quest part of a "story" (is it permanent)
QuestClass.time 		= 180 			  -- Time in seconds to complete quest (for non-story quests only)
QuestClass.title 		= ""			  -- The title to show up for quests (story only)
QuestClass.entity 		= nil 		 	  -- The entity to spawn when the quest is activated
QuestClass.npc 			= nil 			  -- The NPC this quest was taken from
QuestClass.secondaryObj = nil 			  -- If the quest has a secondary objective (besides the NPC) we need to store it

QuestClass.OnTakenCustom = [[
	-- OnTakenCustom function


]]

function Aura_OnTakenQuest(self, ply, nodeRetry)
	if (!istable(self)) then return end
	if (nodeRetry == nil) then
		nodeRetry = true
	end
	if (!Aura_GetQuestNode(self)) then
		if (nodeRetry) then
			Aura_Populate_Node_Table()
			Aura_SetRandomNode(self)
			Aura_OnTakenQuest(self, ply, false)
			return
		end

		Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Missing_Node")
		Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Choose_Another_Quest")


		AuraDropQuest(ply, self.story)
		return
	end

	local typeData = Aura_Quest.QuestTypes[self.type]

	local node = GetNodeFromID(self.type, self.node)
	local secondaryNodeType = typeData.secondaryNodeType
	if (node and node.childNodes and secondaryNodeType) then
		local secondaryNodes = node.childNodes
		local newNodes = {}
		for k,v in pairs(secondaryNodes) do
			if (isstring(v)) then
				if (GetNodeFromID(secondaryNodeType, v)) then
					table.insert(newNodes,v)
				end
			end
		end
		node.childNodes = newNodes
		newNodes = nil
	end

	Aura_Run_Quest_Function(self, self.OnTakenCustom, ply)

	Aura_CreatePrimaryQuestEntity(self, ply)
	if (!self.waitForQuestTrigger) then
		Aura_CreateSecondaryQuestEntities(self, ply)
	end

	if (typeData.returnItem) then
		self.taggedQuestStarted = true
	end

	if (self.story) then
		ply.questData["Story"] = self
	else
		ply.questData["NonStory"] = self
	end

	AuraSyncPlayerQuestToClient(ply)
	UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
end

-- What to do when the quest is complete (for custom quests mostly)
QuestClass.OnCompleteCustom = [[
	-- OnCompleteCustom function


]]

-- What to do when the quest is complete
function Aura_OnCompleteQuest(self, ply)
	if (!istable(self)) then return end
	if (self.story and table.HasValue(self.playersCompleted,ply:SteamID64())) then
		ply:ChatPrint("#Aura_Quest_Already_Done")
		return
	end

	local name = self.title

	Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Quest_Complete " .. name)

	Aura_Run_Quest_Function(self, self.OnCompleteCustom, ply)
	if (self.story) then
		table.insert(self.playersCompleted,ply:SteamID64())
		UpdateStoryQuestData(self)
	end

	local typeData = Aura_Quest.QuestTypes[self.type]
	if (typeData.pickup) then
		ply.hasQuestEntity = false
	end

	if (IsValid(ply) and ply != nil) then
		if (!ply.questData["Rewards"]) then
			ply.questData["Rewards"] = {}
		end
		local rewardTable = {}
		rewardTable.rewards = self.rewards
		rewardTable.type = self.type
		rewardTable.story = self.story
		rewardTable.title = self.title
		rewardTable.difficulty = self.difficulty
		rewardTable.OnTurnIn = self.OnTurnIn
		rewardTable.OnTurnInCustom = self.OnTurnInCustom
		table.insert(ply.questData["Rewards"],rewardTable)
		if (self.story) then
			AuraDropQuest(ply, true)
		else
			AuraDropQuest(ply, false)
		end
	end

end

-- What to do when we turn the quest in

function Aura_OnTurnInQuest(self, ply)
	if (!istable(self)) then return end
	Aura_Run_Quest_Function(self, self.OnTurnInCustom, ply)

	Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Turned_In " .. self.title)

	if (IsValid(ply) and ply != nil) then
		AuraReceiveQuestRewards(ply, self)
	end
end

-- What to do when we turn the quest in (for custom quests)
-- Only fill this in the story quest menu if you really know what you are doing
QuestClass.OnTurnInCustom = [[
	-- OnTurnInCustom function


]]

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]

function Quest(npc, t, r, difficulty, story, title)
	local quest = table.Copy(QuestClass)
	setmetatable(quest, QuestClass)
	difficulty = difficulty or 1
	local typeData = Aura_Quest.QuestTypes[t]

	if (npc) then
		quest.npc = npc:GetNodeID()
	end

	quest.rewards = table.Copy(r)
	if (Aura_Quest.RewardMult != 0) then
		quest.rewards.money = quest.rewards.money * (difficulty * Aura_Quest.RewardMult)
	end
	quest.type = t
	quest.description = Aura_Quest.QuestTypes[t].desc
	quest.difficulty = difficulty
	quest.story = story or false
	quest.time = (story and 0) or (quest.difficulty * Aura_Quest.DifficultyToTime)


	if (!quest.story) then
		local entChoices = typeData.editables
		if (typeData.primaryEntType) then
			quest.primaryEntData = table.Random(entChoices[typeData.primaryEntType])
		else
			quest.primaryEntData = table.Random(entChoices["Entities"])
		end
	end

	if (typeData.editableValues) then
		quest.editableValues = table.Copy(typeData.editableValues)
		if (quest.editableValues["Spawn Number"]) then
			if (Aura_Quest.DifficultySpawnNumberMult != 0) then
				quest.editableValues["Spawn Number"] = (quest.editableValues["Spawn Number"] * Aura_Quest.DifficultySpawnNumberMult * quest.difficulty)
			end
		end
	end

	if (typeData.deliver) then
		local deliveryNode, deliveryType = Aura_GetRandomDeliveryNode()
		if (deliveryNode != nil) then
			Aura_SetSecondQuestNode(quest, deliveryNode, deliveryType)
		end
	end

	if (quest.story) then
		quest.typeEditables = typeData.editables or {}
		quest.playersCompleted = {}
		quest.requiredQuests = {}
	end
	if (typeData.questDialogue) then
		quest.questDialogue = table.Copy(typeData.questDialogue)
	end

	if (typeData.multiStage) then
		quest.stages = typeData.multiStage
		quest.stage = 1
		if (typeData.stageDifficultyScaling) then
			quest.stages = (quest.stages + (quest.difficulty * typeData.stageDifficultyScaling))
		end
	end

	if (typeData.waitForQuestTrigger) then
		quest.waitForQuestTrigger = true
	end

	-- This doesn't work for story quests since you set the entities and they are determined after quest creation, rather than at creation time
	quest.title = title
	if (title == "") then
		quest.title = Aura_GenerateQuestTitle(quest, typeData)
	end

	Aura_SetRandomNode(quest)
	if ((!quest.node or !Aura_GetQuestNode(quest)) and quest) then
		Aura_Populate_Node_Table()
		Aura_SetRandomNode(quest)
	end

	return quest
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]

--[[-------------------------------------------------------------------------
Set/get functions
---------------------------------------------------------------------------]]
function Aura_SetRandomNode(quest)
	local node = Aura_Quest.Nodes[quest.type]
	if (istable(node) and !table.IsEmpty(node)) then
		local n = table.Random(node)
		Aura_SetQuestNode(quest, n)
	end
end

function Aura_SetQuestNode(quest, node)
	if (!node.GetNodeID) then return nil end
	quest.node = node:GetNodeID()
end

function Aura_GetQuestNode(quest)
	return GetNodeFromID(quest.type, quest.node)
end

function Aura_SetSecondQuestNode(quest, node, deliveryType)
	if (!node.GetNodeID) then
		timer.Simple(.2, function()
			if (IsValid(quest) and IsValid(node)) then
				quest.node2 = node:GetNodeID()
				quest.node2Type = deliveryType
			end
		end)
	else
		quest.node2 = node:GetNodeID()
		quest.node2Type = deliveryType
	end
end

function Aura_GetSecondQuestNode(quest)
	if (!quest.node2) then
		return nil 
	end
	return GetSecondNodeFromID(quest, quest.node2)
end

function Aura_SetQuestNPC(quest, npc)
	quest.npc = npc:GetNodeID()
end

function Aura_GetQuestNPC(quest)
	return GetNPCFromID(quest.npc)
end

function Aura_GetRandomDeliveryNode()
	local deliveryNode = nil
	local deliveryType = ""
	for k,v in pairs(Aura_Quest.Nodes) do
		if (v.dropOff and !table.IsEmpty(v.nodes)) then
			deliveryNode = table.Random(v.nodes)
			deliveryType = k
		end
	end
	return deliveryNode, deliveryType
end

function Aura_GenerateQuestTitle(quest, typeData)
	local title = quest.type
	local titlePreset = table.Random(typeData.titlePresets)
	if (quest.primaryEntData and quest.primaryEntData["Name"]) then
		local name = quest.primaryEntData["Name"]
		if (istable(name)) then
			name = table.Random(name)
		end
		title = titlePreset.prefix .. " the " .. name .. " " .. titlePreset.suffix
	end
	return title
end

--[[-------------------------------------------------------------------------
---------------------------------------------------------------------------]]