local spawnOffset = Aura_Quest.DefaultEntitySpawnRange
function Aura_CreatePrimaryQuestEntity(self, ply)
	local typeData = Aura_Quest.QuestTypes[self.type]
	local entChoices = self.typeEditables or typeData.editables
	local entData = {}
	spawnOffset = Aura_Quest.DefaultEntitySpawnRange

	if (istable(entChoices)) then
		-- Main entity
		if (self.primaryEntData) then
			entData = self.primaryEntData
		else
			entData = table.Random(entChoices[typeData.primaryEntType or "Entities"])
		end
		if (typeData.multiNode) then
			Aura_SetRandomNode(self)
		end
		local primaryNode = GetNodeFromID(self.type, self.node)
		if (primaryNode.GetSpawnDistance) then
			spawnOffset = primaryNode:GetSpawnDistance()
		end
		local ent = Aura_CreateSingleQuestEntity(self, primaryNode, self.type, entData, ply)

		if (!ent or !IsValid(ent)) then
			ply:ChatPrint("#Aura_Quest_Error_Spawning")
			AuraDropQuest(ply, self.story)
			return
		end
		self.entity = ent:EntIndex()
		self.objective = ent:EntIndex()
		ent.quest = self
		ent.questPly = ply:SteamID64()

		if (typeData.protect) then
			if (typeData.questDialogue) then
				ent.questDialogue = typeData.questDialogue
				ent.willTriggerDialogue = true
			end
			if (self.questDialogue) then
				ent.questDialogue = self.questDialogue
				ent.willTriggerDialogue = true
			end

			if (ent.questDialogue and !table.IsEmpty(ent.questDialogue["Quest Start"])) then
				self.taggedForStart = true
			end
		end
	end
end

function Aura_CreateSecondaryQuestEntities(self, ply, waves)
	-- Secondary entities
	local typeData = Aura_Quest.QuestTypes[self.type]
	local entChoices = self.typeEditables or typeData.editables
	local ent = self.entity
	if (ent and IsValid(Entity(ent)) and istable(entChoices) and typeData.secondaryEntType) then
		if (typeData.editableValues) then
			self.editableValues = table.Copy(typeData.editableValues)
			if (Aura_Quest.DifficultySpawnNumberMult != 0 and self.editableValues["Spawn Number"]) then
				self.editableValues["Spawn Number"] = (typeData.editableValues["Spawn Number"] * Aura_Quest.DifficultySpawnNumberMult * self.difficulty)
			end
		end

		ent = Entity(ent)
		local entData = {}
		local secondaryType = typeData.secondaryEntType
		local primaryNode = GetNodeFromID(self.type, self.node)
		if (primaryNode.GetSpawnDistance) then
			spawnOffset = primaryNode:GetSpawnDistance()
		end
		entData = table.Random(entChoices[secondaryType])
		
		if (self.waitForQuestTrigger) then
			if (!self.story and self.time != 0) then
				timer.Create(ply:SteamID64() .. "QuestTimer",self.time,1, function()
					if (IsValid(ply) and ply.questData["NonStory"] == self) then
						AuraAbandonQuest(ply, ply.questData["NonStory"], true)
					end
				end)
			end
		end

		if (self.editableValues and self.editableValues["Spawn Number"] and self.editableValues["Waves"]) then
			local waves = waves or self.editableValues["Waves"]
			local protectTime = self.editableValues["Protection Time"]
			local delay = protectTime / waves / 2
			local timerName = ply:SteamID64() .. "ProtectEntitySpawnTimer" .. tostring(self.story)
			local spawnNumber = math.floor(self.editableValues["Spawn Number"]/waves)
			local spawnExtra = self.editableValues["Spawn Number"] % 2 == 1
			local secondaryNodes = primaryNode.childNodes
			if (!self.enemyEntities) then
				self.enemyEntities = {}
			end
			self.wave = self.wave or 0
			timer.Create(timerName,delay,waves, function()
				self.wave = self.wave + 1
				if (spawnExtra and self.wave == waves) then
					spawnNumber = spawnNumber + 1
				end
				timer.Create(timerName .. "SubTimer",.1,spawnNumber, function()
					if (IsValid(ent) and ent:Health() > 0) then
						-- Spawn multiple entities
						entData = table.Random(entChoices[secondaryType])
						local ent3 = Aura_CreateSingleQuestEntity(self, secondaryNodes, typeData.secondaryNodeType, entData, ply)
						if (ent3 and IsValid(ent3)) then
							ent3.quest = self
							ent3.questPly = ply:SteamID64()
							ent3.secondaryEntity = true
							if (ent3) then
								table.insert(self.enemyEntities,ent3)
							end
						else
							--local class = entData.class or "NULL"
							--ply:ChatPrint("ERROR: Entity of class: " .. class .. " could not be created!")
						end
					end
				end)
				if (timer.RepsLeft(timerName) == 0) then
					if (self) then
						self.allEntitiesSpawned = true
					end
				end
			end)
		else
			local secondNode = Aura_GetSecondQuestNode(self)
			if (secondNode == nil) then
				ply:ChatPrint("#Aura_Quest_Error_NoSecondaryNodes")
				Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Error_NoSecondaryNodesQuestType " .. self.type)
				AuraDropQuest(ply, self.story)
				return
			end

			local ent2 = Aura_CreateSingleQuestEntity(self, secondNode, nil, entData, ply)
			if (ent.objectName) then
				ent2.primaryObjectName = ent.objectName
			end

			if (!ent2 or !IsValid(ent2)) then
				ply:ChatPrint("#Aura_Quest_Error_SpawningSecondary")
				AuraDropQuest(ply, self.story)
				return
			end

			if (typeData.deliver) then
				self.secondaryObj = ent2:EntIndex()
				ent2.deliveryDropOff = true
				ent2.quest = self
			end
		end
	end
end

function Aura_CreateSingleQuestEntity(self, node, nodeType, data, ply)
	local ent = ents.Create(data["Class"])
	if (!ent or !IsValid(ent)) then return nil end
	if (data["Model"]) then
		ent:SetModel(data["Model"])
	end
	if (data["Scale"]) then
		ent:SetModelScale(data["Scale"])
	end
	local questType = nil
	if (istable(node)) then
		node = table.Random(node)
	end
	if (isstring(node) and nodeType) then
		node = GetNodeFromID(nodeType, node)
	end
	if (node) then
		if (node.GetQuestType) then
			questType = node:GetQuestType()
		else
			ply:ChatPrint("#Aura_Quest_Error_NoValidNodeType")
			return nil
		end
	else
		ply:ChatPrint("#Aura_Quest_Error_NodeDoesNotExist")
		return nil
	end

	if (node.GetSpawnDistance) then
		spawnOffset = node:GetSpawnDistance()
	end

	local mins,maxs = ent:GetModelBounds()
	local offset = Vector(math.random(-spawnOffset,spawnOffset),math.random(-spawnOffset,spawnOffset),10)
	if (maxs) then
		offset = offset + Vector(0,0,maxs.z)
	end
	ent:SetPos(node:GetPos() + offset)
	ent:Spawn()
	ent:Activate()
	if (data["Health"]) then
		local hp = data["Health"]
		if (Aura_Quest.DifficultyHealthMult != 0) then
			hp = (hp * Aura_Quest.DifficultyHealthMult * self.difficulty)
		end
		ent:SetMaxHealth(hp)
		ent:SetHealth(hp)
	end
	if (data["Weapon"]) then
		ent:Give(data["Weapon"])
	end

	if (!self.questEntities) then
		self.questEntities = {}
	end
	table.insert(self.questEntities,ent:EntIndex())
	ent.questEntity = true
	if (data["Name"]) then
		ent.objectName = data["Name"]
	end

	return ent
end