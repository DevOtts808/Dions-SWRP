if (!CLIENT) then return end

PANEL = {}

function PANEL:Init()
    self.oldSetText = self.SetText
    self.SetText = self.NewSetText

    self:SetWrap(true)
    self:SetTextInset(0,0)
    self:SetAutoStretchVertical(true)

    function self:Think()
    end
end

function PANEL:NewSetText(text)
    if (istable(text)) then
        text = table.Random(text)
    end
    if (isfunction(self.oldSetText)) then
        self.oldSetText(self, text)
    end
    
    local insetX, insetY = self:GetTextInset()
    self:SetTextInset(insetX,insetY)
    self:SizeToContentsY()
end

derma.DefineControl("QuestWrappingDLabel", "", PANEL, "DLabel")