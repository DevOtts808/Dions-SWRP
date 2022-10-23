ENT.Type = "ai"
ENT.Base = "base_ai"

ENT.PrintName = "Quest NPC"
ENT.Instructions = ""
ENT.Category = "Aura's Quest System"

ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Editable = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

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
	self:NetworkVar( "String", 1, "NodeID" )
	self:NetworkVar( "String", 2, "NPCModel", { KeyName = "NPCModel",	Edit = { type = "String",	order = 1 } } )

	if (SERVER) then
		self:NetworkVarNotify( "NodeID", self.ChangeNodeID )
		self:NetworkVarNotify( "NPCModel", self.ChangeModel )

		local uid = Aura_Quest_UID()
		if (self:GetNodeID() == "") then
	        self:SetNodeID(uid)
	    end
	end
end


function ENT:ChangeNodeID(name, old, new)
	Aura_Quest.QuestNPCs[old] = nil
	Aura_Quest.QuestNPCs[new] = self
end

function ENT:ChangeModel(name, old, new)
	self:SetModel(new)
end