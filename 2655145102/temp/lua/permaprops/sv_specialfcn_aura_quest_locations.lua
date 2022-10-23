--[[
   ____          _          _   ____          __  __       _ _                     
  / ___|___   __| | ___  __| | | __ ) _   _  |  \/  | __ _| | |__   ___  _ __ ___  
 | |   / _ \ / _` |/ _ \/ _` | |  _ \| | | | | |\/| |/ _` | | '_ \ / _ \| '__/ _ \ 
 | |__| (_) | (_| |  __/ (_| | | |_) | |_| | | |  | | (_| | | |_) | (_) | | | (_) |
  \____\___/ \__,_|\___|\__,_| |____/ \__, | |_|  |_|\__,_|_|_.__/ \___/|_|  \___/ 
                                      |___/                                        
]]-- Also Aura config, yay! Thanks Malboro and Alydus on Discord for telling me this existed!

if not PermaProps then PermaProps = {} end
if not PermaProps.SpecialENTSSpawn then PermaProps.SpecialENTSSpawn = {} end
if not PermaProps.SpecialENTSSave then PermaProps.SpecialENTSSave = {} end

PermaProps.SpecialENTSSpawn["aura_quest_location_marker"] = function( ent, data )
	
	if !data or !istable( data ) then return end

	ent:Spawn()
	ent:Activate()
	
	-- Just in case it doesn't exist yet, which sometimes happens
	if (data["QuestType"] and ent.SetQuestType) then
		ent:SetQuestType(data["QuestType"])
	end

	if (data["NodeID"] and ent.SetNodeID) then
		ent:SetNodeID(data["NodeID"])
	end

	if (data["ParentNode"] and ent.SetParentNode) then
		ent:SetParentNode(data["ParentNode"])
	end

	if (data["ChildNodes"]) then
		ent.childNodes = data["ChildNodes"]
	end

	if (data["SpawnDistance"]) then
		ent:SetSpawnDistance(data["SpawnDistance"])
	end

	return true

end

PermaProps.SpecialENTSSave["aura_quest_location_marker"] = function( ent )
	
	local content = {}
	content.Other = {}
	content.Other["QuestType"] = ent:GetQuestType()
	content.Other["NodeID"] = ent:GetNodeID()
	content.Other["ParentNode"] = ent:GetParentNode()
	if (ent.childNodes) then
		content.Other["ChildNodes"] = ent.childNodes
	end
	if (ent.GetSpawnDistance) then
		content.Other["SpawnDistance"] = ent:GetSpawnDistance()
	end

	if (ent.SetPermaPropRemoval) then
		ent:SetPermaPropRemoval(true)
	end
	
	return content

end

PermaProps.SpecialENTSSpawn["aura_quest_npc"] = function( ent, data )
	
	if !data or !istable( data ) then return end
	ent:Spawn()
	ent:Activate()
	
	-- Just in case it doesn't exist yet, which sometimes happens
	if (data["Model"] and ent.SetNPCModel) then
		ent:SetNPCModel(data["Model"])
	end
	if (data["NodeID"] and ent.SetNodeID) then
		ent:SetNodeID(data["NodeID"])
	end

	return true

end

PermaProps.SpecialENTSSave["aura_quest_npc"] = function( ent )
	
	local content = {}
	content.Other = {}
	if (ent.GetNodeID) then
		content.Other["NodeID"] = ent:GetNodeID()
	end
	if (ent.GetNPCModel) then
		content.Other["Model"] = ent:GetNPCModel()
	end

	if (ent.SetPermaPropRemoval) then
		ent:SetPermaPropRemoval(true)
	end
	
	return content

end