AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("Aura_Open_Quest_Menu")

local random = math.random
local function uuid()
    local template ='xxxxx-xxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end


function ENT:Initialize()
    self:SetNPCModel(Aura_Quest.NPCModel or "models/odessa.mdl")
    self:SetHullType( HULL_HUMAN )
    self:SetHullSizeNormal()
    self:SetSolid( SOLID_BBOX )
    self:AddFlags(65536) 
    self:CapabilitiesAdd(CAP_TURN_HEAD + CAP_ANIMATEDFACE)
    self:SetUseType( SIMPLE_USE )
    self:SetMaxYawSpeed( 5000 )
    self:ResetSequence(ACT_IDLE)
    if (!Aura_Quest.NPCDeath) then
        self:AddFlags(32768)
    end

    self:SetHealth(100)
    
    self.QuestTable = {}
    if (self.PopulateQuestTable) then
        self:PopulateQuestTable()
    end

    local uid = uuid()
    if (self:GetNodeID() == "") then
        self:SetNodeID(uid)
    end
    
    timer.Create(self:EntIndex() .. "QuestRefreshTimer",Aura_Quest.QuestRefreshTime,0, function()
        if (self.QuestTable and self.PopulateQuestTable) then
            self:PopulateQuestTable()
        end
    end)
    if (self.GetNodeID) then
        Aura_Quest.QuestNPCs[self:GetNodeID()] = self
    end
end

function ENT:PopulateQuestTable()
    self.QuestTable = {}
    self.generatingQuests = true
    local amount = math.random(Aura_Quest.QuestsAvailableMin,Aura_Quest.QuestsAvailableMax)
    timer.Create(self:EntIndex() .. "QuestNPCPopulaterDelay",.025,amount, function()
        table.insert(self.QuestTable, AuraGenerateQuest(self))
        if (timer.RepsLeft(self:EntIndex() .. "QuestNPCPopulaterDelay") == 0) then
            self.generatingQuests = false
        end
    end)
    --print("NPC quests refreshed!")
end

function ENT:AcceptInput(input, activator, ply)
    if input == "Use" then
        if (self.generatingQuests) then
            ply:ChatPrint("NPC quests refreshing, please wait till generation is complete")
            return
        end
        if (table.IsEmpty(self.QuestTable)) then
            self:PopulateQuestTable()
        end
        
        AuraSyncQuestsToClient(ply, self)

        local quest = ply.questData["NonStory"]
        if (quest and istable(quest) and !table.IsEmpty(quest)) then
            local questTypeData = Aura_Quest.QuestTypes[quest.type]
            if (questTypeData.returnItem and quest.questDialogue) then
                Aura_Quest_DoDialogueEvent(self, quest, quest.questDialogue, ply)
                return
            end
        end

        local storyQuest = ply.questData["Story"]
        if (storyQuest and istable(storyQuest) and !table.IsEmpty(storyQuest)) then
            local questTypeData = Aura_Quest.QuestTypes[storyQuest.type]
            if (questTypeData.returnItem and storyQuest.questDialogue) then
                Aura_Quest_DoDialogueEvent(self, storyQuest, storyQuest.questDialogue, ply)
                return
            end
        end

        local data = GetPlayerQuestData(ply:SteamID64())

        net.Start("Aura_Open_Quest_Menu")
        net.WriteTable(data)
        net.WriteEntity(self)
        net.Send(ply)
    end
end

function ENT:OnTakeDamage(dmginfo)
    if (!Aura_Quest.NPCDeath) then dmginfo:SetDamage(0) return end

    if ( not self.m_bApplyingDamage ) then
        self.m_bApplyingDamage = true
        self:SetHealth(self:Health() - dmginfo:GetDamage())

        if (self:Health() <= 0) then
            self:Die()
        end
        self.m_bApplyingDamage = false
    end
end

function ENT:Die()
    self:Remove()
end

function ENT:OnRemove()
    if (self.GetPermaPropRemoval and self:GetPermaPropRemoval()) then return end
    Aura_Quest.QuestNPCs[self:GetNodeID()] = nil
    if (timer.Exists(self:EntIndex() .. "QuestNPCPopulaterDelay")) then
        timer.Destroy(self:EntIndex() .. "QuestNPCPopulaterDelay")
    end
end