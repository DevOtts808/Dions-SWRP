-- Serverside funtions and player related hooks

Aura_Quest = Aura_Quest or {}
Aura_Quest.TemporaryEntities = Aura_Quest.TemporaryEntities or {}

hook.Add( "PlayerInitialSpawn", "AuraQuestLoadPlayerData", function( ply )
	timer.Simple(5, function()
		if (IsValid(ply)) then
			ply.questData = GetPlayerQuestData(ply:SteamID64())
			ply.questData["NonStory"] = false

			local questData = ply.questData
			if (!Aura_Quest.SaveEntDataOnRemoved) then
				Aura_OnTakenQuest(questData, v)
			else
				if (Aura_Quest.TemporaryEntityTable and Aura_Quest.TemporaryEntityTable[v:SteamID64()]) then
					AuraReplacePlayerQuestEntityTable(v, Aura_Quest.TemporaryEntityTable[v:SteamID64()])
				end
			end

			AuraSyncPlayerQuestToClient(ply)
			UpdatePlayerQuestData(ply:SteamID64(), ply.questData)
		end
	end)
end )

hook.Add("PlayerDisconnected","Aura_Quest_DisconnectHook", function(ply)
	local questData = ply.questData
	if (Aura_Quest.SaveEntDataOnRemoved and questData and questData["Story"]) then
		questData = questData["Story"]
		if (!Aura_Quest.TemporaryEntityTable) then
			Aura_Quest.TemporaryEntityTable = {}
		end

		Aura_Quest.TemporaryEntityTable[ply:SteamID64()] = AuraGetPlayerQuestEntityTable(ply)

		if (questData.questEntities) then
			local tempEntTable = questData.questEntities
			questData.questEntities = nil
			for k,v in pairs(tempEntTable) do
				local ent = Entity(v)
				if (ent and IsValid(ent)) then
					ent:Remove()
				end
			end
		end
	end
	if (questData and questData["NonStory"]) then
		questData = questData["NonStory"]

		if (questData.questEntities) then
			local tempEntTable = questData.questEntities
			questData.questEntities = nil
			for k,v in pairs(tempEntTable) do
				local ent = Entity(v)
				if (ent and IsValid(ent)) then
					ent:Remove()
				end
			end
		end
	end
end)