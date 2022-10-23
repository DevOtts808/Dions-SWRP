ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Quest Location Marker"
ENT.Category = "Aura's Quest System"

ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Editable = true

local random = math.random
local function Aura_Quest_UID()
    local template ='xxxxx-xxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "PermaPropRemoval" )
	self:NetworkVar( "String", 0, "QuestType" )
	self:NetworkVar( "String", 1, "NodeID" )
	self:NetworkVar( "String", 2, "ParentNode", { KeyName = "ParentNode",	Edit = { type = "String",	order = 1} } )
	self:NetworkVar( "Int", 2, "SpawnDistance", { KeyName = "SpawnDistance",	Edit = { type = "Int",	order = 1, min = 1, max = 500} } )

	if (SERVER) then
	    self:NetworkVarNotify( "QuestType", self.ChangeQuestType )
		self:NetworkVarNotify( "NodeID", self.ChangeNodeID )
		self:NetworkVarNotify( "ParentNode", self.ChangeParentNode )
		self:SetSpawnDistance(Aura_Quest.DefaultEntitySpawnRange)

		local uid = Aura_Quest_UID()
		if (self:GetNodeID() == "") then
	        self:SetNodeID(uid)
	    end
	end
end

function ENT:ChangeQuestType(name, old, new)
	if (self.GetQuestType) then
 		Aura_Remove_Node_From_Table(self, old)
		Aura_Add_Node_To_Table(self)
	end
end

function ENT:ChangeNodeID(name, old, new)
	if (self.GetQuestType) then
		Aura_Remove_Node_From_Table(self, nil, old)
		Aura_Add_Node_To_Table(self)
	end
end

function ENT:ChangeParentNode(name, old, new)
	local qt = nil
	if (self.GetQuestType) then
		qt = self:GetQuestType()
	end
	if (Aura_Quest.QuestTypes[qt]) then
		local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[qt].questType,new)
		if (nodeEnt and IsValid(nodeEnt) and self.GetNodeID) then
			if (nodeEnt.childNodes == nil) then
				nodeEnt.childNodes = {}
			end
			if (!table.HasValue(nodeEnt.childNodes,self:GetNodeID())) then
				table.insert(nodeEnt.childNodes,self:GetNodeID())
			end
		end
	end
end