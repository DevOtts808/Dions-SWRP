if (!CLIENT) then return end

PANEL = {}

aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)
local defaultSizeX, defaultSizeY = 1350 * aura_scaleX, 300 * aura_scaleY
local sidePadding = 15 * aura_scaleX
local modelSize = defaultSizeY - sidePadding
local settingsSize = 15 * aura_scaleX

function PANEL:Init()
    self.npc = nil
end

function PANEL:SetNPC(npc)
    self.npc = npc
    local model = ""
    if (npc) then
        model = npc:GetModel()
    end
    if (npc) then
        model = npc:GetModel()
    end
    self:SetModel( model )

    local paintFunc = self.Paint

    local borderColor = string.ToColor(GetConVarString("quest_border_color"))
    function self:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,aura_quest_color_gray)

        paintFunc(self, w,h)

        surface.SetDrawColor(borderColor)
        surface.DrawOutlinedRect(0,0,w,h)
    end

    function self:LayoutEntity( Entity ) 
        self:RunAnimation()
    end

    local headpos = Vector(0,0,0)
    local bone = self.Entity:LookupBone("ValveBiped.Bip01_Head1")
    if (bone) then
        headpos = self.Entity:GetBonePosition(bone)
    end

    local mins,maxs = self.Entity:GetModelBounds()

    self:GetEntity():SetSequence(npc:GetSequence())
    if (!bone and npc:EyePos()) then
        headpos = npc:EyePos() - npc:GetPos() + Vector(maxs.x,0,-maxs.z / 5)
    end

    if (headpos != Vector(0,0,0)) then
        self:SetLookAt(headpos)
        self:SetFOV(90,0)

        self:SetAnimated(true)

        self:SetCamPos(headpos + Vector(15, 0, 0))
        self.Entity:SetEyeTarget(headpos + Vector(15, 0, 0))
    end
end

derma.DefineControl("QuestNPCFaceBox", "", PANEL, "DModelPanel")