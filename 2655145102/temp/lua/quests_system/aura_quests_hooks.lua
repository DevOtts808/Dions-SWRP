-- Hooks for quests
Aura_Quest = Aura_Quest or {}

if (SERVER) then
	
	
	hook.Add( "InitPostEntity", "Aura_Quest_Setup_Story_Quests", function()
		local storyQuests = GetStoryQuestData()
		Aura_Quest.Quests = storyQuests
	end)

	hook.Add("PlayerSay","Aura_Quest_Debug_Command", function(ply, text, team)
		if (string.lower(text) == string.lower(Aura_Quest.DebugCommand)) then
			if (Aura_Quest.AdminPrivilages[ply:GetUserGroup()]) then
				if (!ply.Aura_Quest_Debug_Mode) then
					ply.Aura_Quest_Debug_Mode = true
					net.Start("Aura_Toggle_Quest_Debug_Mode")
					net.WriteBool(true)
					net.Send(ply)
					ply:ChatPrint("#Aura_Quest_Debug_On")
				else
					ply.Aura_Quest_Debug_Mode = false
					net.Start("Aura_Toggle_Quest_Debug_Mode")
					net.WriteBool(false)
					net.Send(ply)
					ply:ChatPrint("#Aura_Quest_Debug_Off")
				end
			else
				ply:ChatPrint("#Aura_Quest_No_Permission")
			end
		end
		if (string.lower(text) == string.lower(Aura_Quest.StoryQuestCommand)) then
			if (Aura_Quest.StoryQuestPrivilages[ply:GetUserGroup()]) then
				AuraSyncQuestsToClient(ply)

				net.Start("Aura_Quest_Open_Story_Menu")
				net.WriteBool(true)
				net.Send(ply)
			else
				ply:ChatPrint("#Aura_Quest_No_Permission")
			end
		end
	end)

	-- For kill quests with one entity, sets progress equal to how close the NPC is to being dead
	hook.Add("PostEntityTakeDamage","Aura_Quest_Entity_Damage_Hook", function(ent, dmginfo, took)
		if (took and ent.quest) then
			local quest = ent.quest
			local questTypeData = Aura_Quest.QuestTypes[quest.type]
			local ply = player.GetBySteamID64(ent.questPly)
			if (questTypeData and IsValid(ply)) then
				if (!questTypeData.multiStage and questTypeData.kill) then
					local maxHP = ent:GetMaxHealth()
					local prog = math.Remap(maxHP - ent:Health(),0,maxHP,0,100)
					net.Start("Aura_Update_Quest_Progress")
					net.WriteBool(quest.story)
					net.WriteInt(prog,32)
					net.Send(ply)
				end
			end
		end
	end)

	hook.Add("OnNPCKilled","Aura_Quest_Entity_Death_Hook", function(ent, attacker, inflictor)
		if (ent.quest) then
			local quest = ent.quest
			local questTypeData = Aura_Quest.QuestTypes[quest.type]
			local ply = player.GetBySteamID64(ent.questPly)
			if (IsValid(ply)) then
				if (questTypeData.kill) then
					if (ent.questPly) then
						Aura_OnCompleteQuest(quest, ply)
					end
				end
				if (questTypeData.protect and ent == Entity(quest.entity)) then
					if (ent.questPly) then
						if (quest.story) then
							local title = quest.title
							Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Target_Died" .. title)
						else
							Aura_Send_Language_Message_To_Client(ply, "#Aura_Quest_Target_Died" .. quest.type)
						end
						
						AuraDropQuest(ply, quest.story)
					end
				end
				if (ent.secondaryEntity or questTypeData.protect) then
					local prog = AuraUpdateQuestProgression(quest, ply, 100)
					net.Start("Aura_Update_Quest_Progress")
					net.WriteBool(quest.story)
					net.WriteInt(prog,32)
					net.Send(ply)
					if (quest and quest.allEntitiesSpawned and quest.enemyEntities and quest.entity) then
						for k,v in pairs(quest.enemyEntities) do
							if (IsValid(v) and v:Health() > 0) then
								return
							end
						end
						local questEntity = Entity(quest.entity)
						if (quest.entity and IsValid(Entity(quest.entity))) then
							AuraPrintQuestMessage(ply, "#Aura_Quest_Target_Safe")
							quest.taggedForCompletion = true
						end
					end
				end
			end
		end
	end)

	hook.Add("PropBreak", "Aura_Quest_Destroy_Quest_Object", function(ply, ent)
		if (ent.questEntity) then
			if (ent.quest) then
				local quest = ent.quest
				local realPly = player.GetBySteamID64(quest.player)
				if (realPly and IsValid(realPly)) then
					AuraPrintQuestMessage(realPly, "#Aura_Quest_Objective_Destroyed")
					AuraAbandonQuest(realPly, quest, false)
				end
			end
		end
	end)

	hook.Add("PlayerUse","Aura_Quest_Entity_Use_Hook", function(ply, ent)
		if (ent.questEntity) then
			if (ent.quest) then
				if (!ent.questTouchCooldown) then
					ent.questTouchCooldown = true
					timer.Simple(1, function()
						if (IsValid(ent)) then
							ent.questTouchCooldown = false
						end
					end)
					local quest = ent.quest
					local plyQuest = ply.questData
					if (quest.player != ply:SteamID64()) then
						ply:ChatPrint("#Aura_Quest_Not_Yours")
						return
					end
					local questTypeData = Aura_Quest.QuestTypes[quest.type]

					--[[-------------------------------------------------------------------------
					DELIVERY AND FETCH QUESTS
					---------------------------------------------------------------------------]]
					if (questTypeData.pickup and !ent.deliveryDropOff) then
						ent:Remove()
						--[[-------------------------------------------------------------------------
						DELIVERY QUESTS
						---------------------------------------------------------------------------]]
						if (questTypeData.deliver) then
							local prog = AuraUpdateQuestProgression(quest, ply, 50)
							net.Start("Aura_Update_Quest_Progress")
							net.WriteBool(quest.story)
							net.WriteInt(prog,32)
							net.Send(ply)

							quest.objective = quest.secondaryObj

							if (quest.story) then
								ply.hasStoryEntity = true
							else
								ply.hasQuestEntity = true
							end
							quest.entity = nil
							AuraSyncPlayerQuestToClient(ply)
							UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
						end
						--[[-------------------------------------------------------------------------
						---------------------------------------------------------------------------]]

 
						--[[-------------------------------------------------------------------------
						FETCH QUESTS
						---------------------------------------------------------------------------]]
						if (questTypeData.returnItem) then
							if (quest.stage < quest.stages) then
								Aura_CreatePrimaryQuestEntity(quest, ply)
							else
								if (quest.story) then
									ply.hasStoryEntity = true
								else
									ply.hasQuestEntity = true
								end
								quest.objective = Aura_GetQuestNPC(quest):EntIndex()
								quest.entity = nil
								quest.taggedQuestStarted = false
								quest.taggedForCompletion = true
							end
							quest.stage = quest.stage + 1
							local prog = AuraUpdateQuestProgression(quest, ply, 100)
							net.Start("Aura_Update_Quest_Progress")
							net.WriteBool(quest.story)
							net.WriteInt(prog,32)
							net.Send(ply)

							AuraSyncPlayerQuestToClient(ply)
							UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
						end
						--[[-------------------------------------------------------------------------
						---------------------------------------------------------------------------]]
					end
					--[[-------------------------------------------------------------------------
					---------------------------------------------------------------------------]]

					--[[-------------------------------------------------------------------------
					DELIVERY QUEST DROPOFF
					---------------------------------------------------------------------------]]
					if (ent.deliveryDropOff) then
						if ((ply.hasQuestEntity and !quest.story) or (ply.hasStoryEntity and quest.story)) then
							local name = ent.primaryObjectName or "Item"
							if (quest.stages) then
								Aura_Send_Language_Message_To_Client(ply, name .. " " .. quest.stage .. "/" .. quest.stages .. " #Aura_Quest_Objective_Deposited")
								if (quest.stage < quest.stages) then
									local prog = 100
									if (quest.stages) then
										quest.stage = quest.stage + 1
										local prog = AuraUpdateQuestProgression(quest, ply, 50)
										net.Start("Aura_Update_Quest_Progress")
										net.WriteBool(quest.story)
										net.WriteInt(prog,32)
										net.Send(ply)
									end
									if (quest.story) then
										ply.hasStoryEntity = false
									else
										ply.hasQuestEntity = false
									end
									Aura_CreatePrimaryQuestEntity(quest, ply)
									AuraSyncPlayerQuestToClient(ply)
									UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
								else
									ent:Remove()
									quest.secondaryObj = nil
									quest.taggedForCompletion = true
									Aura_OnCompleteQuest(quest, ply)
								end
								return
							end
						else
							ply:ChatPrint("#Aura_Quest_Not_Time")
							return
						end
					end
					--[[-------------------------------------------------------------------------
					---------------------------------------------------------------------------]]
				end
			end
		end
	end)

	hook.Add("AcceptInput","Aura_Quest_Dialogue_Ents", function(ent, input, ply, caller, val)
		 --[[-------------------------------------------------------------------------
		DIALOGUE QUEST ENTITIES
		---------------------------------------------------------------------------]]
		if (ent.willTriggerDialogue and ent.questDialogue) then
			if (ent.questPly and player.GetBySteamID64(ent.questPly) == ply) then
				Aura_Quest_DoDialogueEvent(ent, ent.quest, ent.questDialogue, ply)
			end
		end
		--[[-------------------------------------------------------------------------
		---------------------------------------------------------------------------]]
	end)

	function Aura_Quest_DoDialogueEvent(ent, quest, dialogue, ply)
		if (!quest) then return end
		if (quest.taggedForCompletion) then
			net.Start("Aura_Quest_Open_NPC_Dialogue_Box")
			net.WriteEntity(ent)
			net.WriteBool(quest.story)
			net.WriteData(Aura_CompressQuestData(dialogue["Quest Complete"]))
			net.Send(ply)
		elseif (quest.taggedForStart) then
			net.Start("Aura_Quest_Open_NPC_Dialogue_Box")
			net.WriteEntity(ent)
			net.WriteBool(quest.story)
			net.WriteData(Aura_CompressQuestData(dialogue["Quest Start"]))
			net.Send(ply)
		elseif (quest.taggedQuestStarted) then
			net.Start("Aura_Quest_Open_NPC_Dialogue_Box")
			net.WriteEntity(ent)
			net.WriteBool(quest.story)
			net.WriteData(Aura_CompressQuestData(dialogue["Quest During"]))
			net.Send(ply)
		end
	end
	
	hook.Add("PreCleanupMap","Aura_Save_Cleanup_Data", function()
		if (Aura_Quest.SaveEntDataOnRemoved) then
			Aura_Quest.TemporaryCleanupTable = {}

			for k,v in pairs(player.GetAll()) do
				Aura_Quest.TemporaryCleanupTable[v:SteamID64()] = AuraGetPlayerQuestEntityTable(v)

				if (!v.questData) then
					v.questData = GetPlayerQuestData(ply:SteamID64())
				end
				v.questData["NonStory"] = false
				if (timer.Exists(v:SteamID64() .. "QuestTimer")) then
					timer.Destroy(v:SteamID64() .. "QuestTimer")
				end
				UpdatePlayerQuestData(v:SteamID64(), v.questData)
			end
		end
	end)

	hook.Add( "AllowPlayerPickup", "Aura_Quest_Override_Pickup_Quest_Objects", function( ply, ent )
	    if (ent.quest) then
	    	return false
	    end
	end )
 	
	hook.Add("PostCleanupMap","Aura_Populate_Tables", function()
		timer.Simple(.1, function()
			for k,v in pairs(player.GetAll()) do
				if (v.questData and v.questData["Story"]) then
					local questData = v.questData["Story"]
					if (!Aura_Quest.SaveEntDataOnRemoved) then
						Aura_OnTakenQuest(questData, v)
					else
						if (Aura_Quest.TemporaryCleanupTable and Aura_Quest.TemporaryCleanupTable[v:SteamID64()]) then
							AuraReplacePlayerQuestEntityTable(v, Aura_Quest.TemporaryCleanupTable[v:SteamID64()])
						end
					end
					AuraSyncPlayerQuestToClient(v)
					UpdatePlayerQuestData(v:SteamID64(), v.questData)
				end
			end
			Aura_Quest.TemporaryCleanupTable = nil
		end)
	end)
end

if (CLIENT) then


	Aura_Quest.QuestNPCs = Aura_Quest.QuestNPCs or {}

	local namePaddingX = 10
	local namePaddingY = 5
	local noQuestTypeText = language.GetPhrase("Aura_Quest_Node_No_Type")

	hook.Add("PreDrawEffects","Aura_Quest_NPC_Overheads", function(bDrawingDepth, bDrawingSkybox)
		local ply = LocalPlayer()
		if (!Aura_Quest.QuestLocations or table.IsEmpty(Aura_Quest.QuestLocations)) then
			Aura_Quest.QuestLocations = ents.FindByClass("aura_quest_location_marker")
		end
		local darkColor = string.ToColor(GetConVarString("quest_main_color_dark"))
		local borderColor = string.ToColor(GetConVarString("quest_border_color"))
		local mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))
		surface.SetFont("QuestFontQuestTitlesHUD")
		local textWidth, textHeight = surface.GetTextSize(Aura_Quest.NPCOverheadName)
		for k,v in pairs(Aura_Quest.QuestNPCs) do
			if (IsValid(v)) then
				local mins,maxs = v.modelBoundsMin, v.modelBoundsMax
				local entPos = v:GetPos() + Vector(0,0,maxs.z + 10)
				local ang2 = (v:GetPos() - ply:GetPos()):Angle()
				ang2.z = 90
				ang2.x = 0
				ang2.y = ang2.y - 90

				cam.Start3D2D(entPos, ang2, .1)
					local w,h = textWidth + namePaddingX * 2, textHeight + namePaddingY * 2
					local x,y = -textWidth / 2 -namePaddingX, -namePaddingY / 2
					draw.RoundedBox(0,x,y,w,h,darkColor)

					surface.SetDrawColor(borderColor)

					surface.DrawOutlinedRect(x,y,w,h, 2)

		            draw.DrawText(Aura_Quest.NPCOverheadName, "QuestFontQuestTitlesHUD", 0, 0, mainTextColor, TEXT_ALIGN_CENTER )
		        cam.End3D2D()
			end
		end

		local questData = ply.questData
		if (questData) then
			if (questData["Story"] and questData["Story"].objective) then
				local ent = Entity(questData["Story"].objective)
				if (ent and IsValid(ent)) then
					local mins,maxs = ent:GetModelBounds()
					local entPos = ent:GetPos() + Vector(0,0,maxs.z + 15)
					local ang2 = (ent:GetPos() - ply:GetPos()):Angle()
					ang2.z = 90
					ang2.x = 0
					ang2.y = ang2.y - 90

					cam.Start3D2D(entPos, ang2, .1)
			            draw.DrawText("v", "QuestFontQuestTitlesHUD", 0, 0, mainTextColor, TEXT_ALIGN_CENTER )
			        cam.End3D2D()
				end
			end
			if (questData["NonStory"] and questData["NonStory"].objective) then
				local ent = Entity(questData["NonStory"].objective)
				if (ent and IsValid(ent)) then
					local mins,maxs = ent:GetModelBounds()
					local entPos = ent:GetPos() + Vector(0,0,maxs.z + 15)
					local ang2 = (ent:GetPos() - ply:GetPos()):Angle()
					ang2.z = 90
					ang2.x = 0
					ang2.y = ang2.y - 90

					cam.Start3D2D(entPos, ang2, .1)
			            draw.DrawText("v", "QuestFontQuestTitlesHUD", 0, 0, mainTextColor, TEXT_ALIGN_CENTER )
			        cam.End3D2D()
				end
			end
		end

		if (ply.Aura_Quest_Debug_Mode) then
			local textWidth2, textHeight2
			for k,v in pairs(Aura_Quest.QuestLocations) do
				if (IsValid(v)) then
					local mins,maxs = v.modelBoundsMin, v.modelBoundsMax
					local entPos = v:GetPos() + Vector(0,0,maxs.z + 10)
					local ang2 = (v:GetPos() - ply:GetPos()):Angle()
					ang2.z = 90
					ang2.x = 0
					ang2.y = ang2.y - 90

					local nodeQuestType = v:GetQuestType()
					if (nodeQuestType == "" or !nodeQuestType) then
						nodeQuestType = noQuestTypeText
					end
					local text = nodeQuestType .. " (" .. v:GetNodeID() .. ")"
					surface.SetFont("QuestFontQuestTitlesHUD")
					textWidth2, textHeight2 = surface.GetTextSize(text)

					local nodeDist = Aura_Quest.DefaultEntitySpawnRange
					if (v.GetSpawnDistance) then
						nodeDist = v:GetSpawnDistance()
					end
					nodeDist = nodeDist * 10

					local ang1 = Angle(0,0,0)
	                ang1 = ang1 + Angle(0,180,0)

	                cam.Start3D2D(entPos - Vector(0,0,20), ang1, .1)
	                    draw.NoTexture()
	                    surface.SetDrawColor(aura_quest_color_dark_green3)
	                    Aura_Quest_drawCircle(0,0,nodeDist, 20)

	                cam.End3D2D()

					cam.Start3D2D(entPos, ang2, .1)
						local w,h = textWidth2 + namePaddingX * 2, textHeight2 + namePaddingY * 2
						local x,y = -textWidth2 / 2 -namePaddingX, -namePaddingY / 2
						draw.RoundedBox(0,x,y,w,h,darkColor)

						surface.SetDrawColor(borderColor)
						surface.DrawOutlinedRect(x,y,w,h, 2)

			            draw.DrawText(text, "QuestFontQuestTitlesHUD", 0, 0, mainTextColor, TEXT_ALIGN_CENTER )
			        cam.End3D2D()

			        if (v.GetParentNode and v:GetParentNode() != nil and Aura_Quest.QuestTypes[nodeQuestType]) then
			        	if (Aura_Quest.QuestTypes[nodeQuestType].questType) then
				        	local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[nodeQuestType].questType, v:GetParentNode())
							if (nodeEnt and IsValid(nodeEnt)) then
								render.DrawLine(v:GetPos(),nodeEnt:GetPos(),aura_quest_color_red,false)
							end
						end
			        end
				end
			end
		end
	end)

	hook.Add("PreDrawHalos","Aura_Quest_Draw_Debug_Halos", function()
		if (LocalPlayer().Aura_Quest_Debug_Mode) then
			halo.Add(Aura_Quest.QuestLocations,aura_quest_color_yellow,0,0,30,true,true)
		end
	end)

	hook.Add("PreCleanupMap","Aura_Clear_Quests", function()
		local ply = LocalPlayer()
		if (!ply.questData) then
			ply.questData = GetPlayerQuestData(ply:SteamID64())
		end
		ply.questData["NonStory"] = false
		if (timer.Exists(ply:SteamID64() .. "QuestTimer")) then
			timer.Destroy(ply:SteamID64() .. "QuestTimer")
		end
		UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
	end)

end
