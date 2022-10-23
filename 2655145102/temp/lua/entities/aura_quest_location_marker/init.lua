AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self:SetColor(Color(255,255,255, 0))
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	if (self:GetCreator() and !self:GetCreator().Aura_Quest_Debug_Mode) then
		if (self:GetCreator().ChatPrint) then
			self:GetCreator():ChatPrint("Make sure to use " .. Aura_Quest.DebugCommand .. " to see the quest locations!")
		end
	end
end

function ENT:AcceptInput(input, activator, ply)
    if (input == "Use" and ply and IsValid(ply)) then
    	if (!Aura_Quest.AdminPrivilages[ply:GetUserGroup()]) then
    		ply:ChatPrint("You do not have permission to edit this quest location!")
    		return
    	end
        net.Start("Aura_Open_Quest_Location_Menu")
        net.WriteEntity(self)
        net.Send(ply)
    end
end

function ENT:OnTakeDamage(dmginfo)
	return
end

function ENT:OnRemove()
	-- Possibly implement some perma prop "mark for removal" stuff here to prevent it from deleting when perma propped since there is a delay
	if (self.GetPermaPropRemoval and self:GetPermaPropRemoval()) then return end
	Aura_Remove_Node_From_Table(self)
	if (self.GetQuestType and self.GetNodeID and self:GetQuestType() != "" and self:GetQuestType() != nil and Aura_Quest.QuestTypes[self:GetQuestType()].questType) then
		local nodeEnt = GetNodeFromID(Aura_Quest.QuestTypes[self:GetQuestType()].questType,self:GetParentNode())
		if (nodeEnt and IsValid(nodeEnt) and self.GetNodeID) then
			if (nodeEnt.childNodes == nil) then
				nodeEnt.childNodes = {}
			end
			table.RemoveByValue(nodeEnt.childNodes,self)
		end
	end 
end

net.Receive("Aura_Change_Quest_Location_Details", function()
	local ent = net.ReadEntity()
	local data = net.ReadTable()

	if (data.ParentNode) then
		ent:SetParentNode(data.ParentNode)
	end
	ent:SetQuestType(data.QuestType)
end)