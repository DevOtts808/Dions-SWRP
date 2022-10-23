if (!CLIENT) then return end

PANEL = {}

aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)
local defaultSizeX, defaultSizeY = 1350 * aura_scaleX, 300 * aura_scaleY
local sidePadding = 15 * aura_scaleX
local modelSize = defaultSizeY - sidePadding
local settingsSize = 15 * aura_scaleX

function PANEL:Init()
    aura_scaleX = (ScrW() / 2560)
    aura_scaleY = (ScrH() / 1440)
    defaultSizeX, defaultSizeY = 1350 * aura_scaleX, 300 * aura_scaleY
    sidePadding = 15 * aura_scaleX
    modelSize = defaultSizeY - sidePadding
    settingsSize = 15 * aura_scaleX

    self:SetSize( defaultSizeX, defaultSizeY )
    self:Center()
    self:CenterVertical(.75)
    self:SetSize( defaultSizeX, 0 )
    self:MakePopup()

    self.choiceY = 0
    self.font = "QuestFontQuestSmall"
    self.choices = {}

    self:SizeTo(defaultSizeX,defaultSizeY,.5,0,5, function() end)
    self:MakePopup()

    self.darkColor = string.ToColor(GetConVarString("quest_main_color_dark"))
    self.borderColor = string.ToColor(GetConVarString("quest_border_color"))
    self.mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))

    function self:Paint(w,h)
        blurpanel(self, 5)
        draw.RoundedBox(0,0,0,w,h,self.darkColor)
        surface.SetDrawColor(self.borderColor)

        surface.DrawOutlinedRect(0,0,w,h, 3 * aura_scaleX)
    end

    self.scrollerWidth = self:GetWide() - (modelSize + sidePadding) - sidePadding - settingsSize
    self.optionsScroller = vgui.Create("DScrollPanel", self)
    self.optionsScroller:Dock( FILL )
    self.optionsScroller:DockMargin(modelSize + sidePadding,sidePadding,sidePadding * 2 + settingsSize,sidePadding)
    local sbar = self.optionsScroller:GetVBar()
    sbar:SetWide(0)

    function self.optionsScroller:Paint(w,h)
        --draw.RoundedBox(0,0,0,w,h,Color(255,0,0,255))
    end


    self:DrawTitleText()
    self:DrawSettingsButton()
end

function PANEL:PopulateDialogueBox(title, choices, timeTitle, timeOptions, closeTextDisabled)
    aura_scaleX = (ScrW() / 2560)
    aura_scaleY = (ScrH() / 1440)

    if (timer.Exists(LocalPlayer():SteamID64() .. "Timer")) then
        timer.Stop(LocalPlayer():SteamID64() .. "Timer")
    end
    
    timeTitle = timeTitle or 2
    timeOptions = timeOptions or .5
    self:ClearDialogueBox()
    local finalHeight = 0
    self.titleText:SetText(title)
    finalHeight = self.titleText:GetTall()
    self.titleText:SetText("")
    Aura_TypeToFillTextBox(self.titleText, title, timeTitle, function()
        self.titlePadding = finalHeight
        self.choiceY = self.titlePadding + 15 * aura_scaleY
        if (!closeTextDisabled) then
            table.insert(choices,{text = Aura_Quest.CloseText, func = function() end, closeMenu = true })
        end
        local i = 1
        local delay = timeOptions
        timer.Create(LocalPlayer():SteamID64() .. "Timer",delay,#choices, function()
            if (IsValid(self)) then
                self:DrawDialogueOption(choices[i])
                i = i + 1
            else
                return
            end
        end)
    end)
end

function PANEL:ClearDialogueBox()
    self.titleText:SetText("")
    self.titleText:SizeToContentsY()
    for k,v in pairs(self.choices) do
        v:Remove()
    end
    self.choiceY = 0
end

function PANEL:SetNPC(npc)
    self.npc = npc

    self.npcFace = vgui.Create("QuestNPCFaceBox",self)
    self.npcFace:SetSize(modelSize , modelSize )

    local space = defaultSizeY / 2 - self.npcFace:GetTall() / 2
    self.npcFace:SetPos(space, space)

    self.npcFace:SetNPC(npc)
end

function PANEL:DrawTitleText()

    self.titleText = vgui.Create("QuestWrappingDLabel", self.optionsScroller)
    self.titleText:SetWide(self.scrollerWidth - 5 * aura_scaleX)
    self.titleText:SetText("")
    self.titleText:SetFont("QuestFontQuestMedium")
    self.titleText:SetTextColor(self.mainTextColor)
    self.titleText:SetTextInset(5 * aura_scaleX,-5 * aura_scaleY)

    self.titlePadding = self.titleText:GetTall() + 5 * aura_scaleX

    function self.titleText:Think()
    end

    self.titleText.Paint = function (text, w,h)
        surface.SetDrawColor(self.borderColor)
        surface.DrawLine(10 * aura_scaleX,h-1,self.scrollerWidth,h-1)
    end
end

function PANEL:DrawSettingsButton()
    self.settingsButton = vgui.Create("DImageButton",self)
    self.settingsButton:SetSize(settingsSize, settingsSize)
    self.settingsButton:SetImage("icon16/cog.png")
    self.settingsButton:SetPos(self:GetWide() - settingsSize - sidePadding, sidePadding)

    self.settingsButton.DoClick = function(icon)
        Aura_OpenQuestConfigMenu()
        self:Remove()
    end
end

function PANEL:DrawDialogueOption(data)
    local optionSpacing = 10 * aura_scaleY
    local text = data.text or ""
    if (istable(text)) then
        text = table.Random(text)
    end
    text = "- " .. text

    local option = vgui.Create("DButton", self.optionsScroller)
    option:SetWide(self.scrollerWidth)
    option:SetPos(0, self.choiceY)
    option:SetText(text)
    option:SetTextColor(self.mainTextColor)
    option:SetFont(self.font)
    option:SetTextInset(10 * aura_scaleX,0)
    option:SetWrap(true)
    option:SetAutoStretchVertical(true)
    option:SizeToContentsY()
    option:SetTall(option:GetTall() + (5 * aura_scaleY))

    function option:Think()

    end

    surface.SetFont(self.font)
    local textX = math.Clamp(surface.GetTextSize(text) + (10 * aura_scaleX), 0, option:GetWide())

    option.DoClick = function(option)
        if (data.closeMenu) then
            self:SizeTo(defaultSizeX,0,.5,0,5, function() self:Remove() end)
        else
            self:ClearDialogueBox()
        end
        if (data.func) then
            data.func(self)
        else
            LocalPlayer():ChatPrint("#Aura_Quest_FunctionDoesNotExist")
        end
    end

    function option:Paint(w,h)
        if (self:IsHovered()) then
            surface.SetDrawColor(color_white)
            surface.DrawOutlinedRect(0,0,textX,h)
        end
        draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_blue4)
    end

    table.insert(self.choices,option)

    self.choiceY = self.choiceY + option:GetTall() + optionSpacing
end

derma.DefineControl("QuestDialogueBox", "", PANEL, "DPanel")