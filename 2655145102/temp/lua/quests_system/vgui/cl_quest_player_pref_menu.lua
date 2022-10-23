if (!CLIENT) then return end

PANEL = {}

Aura_Quest = Aura_Quest or {}
Aura_Quest.Convars = Aura_Quest.Convars or {}

aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)
local defaultSizeX, defaultSizeY = 600 * aura_scaleX, 700 * aura_scaleY
local sidePadding = 15 * aura_scaleX
local closeButtonSize = 20 * aura_scaleX

function PANEL:Init()
    aura_scaleX = (ScrW() / 2560)
    aura_scaleY = (ScrH() / 1440)
    defaultSizeX, defaultSizeY = 600 * aura_scaleX, 700 * aura_scaleY
    sidePadding = 15 * aura_scaleX
    closeButtonSize = 20 * aura_scaleX

    self:SetSize(defaultSizeX,defaultSizeY)
    self:Center()
    self:SetSize(defaultSizeX,0)
    self:SizeTo(defaultSizeX,defaultSizeY,.5,0,5, function() end)
    self:MakePopup()

    self.darkColor = string.ToColor(GetConVarString("quest_main_color_dark"))
    self.borderColor = string.ToColor(GetConVarString("quest_border_color"))
    self.mainTextColor = string.ToColor(GetConVarString("quest_main_text_color"))

    function self:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h,self.darkColor)
        surface.SetDrawColor(self.borderColor)

        surface.DrawOutlinedRect(0,0,w,h, 3 * aura_scaleX)
    end

    self.title = vgui.Create("DLabel",self)
    self.title:SetPos(sidePadding, sidePadding)
    self.title:SetFont("QuestFontQuestMedium")
    self.title:SetText("Quest Menu Client Settings")
    self.title:SetTextColor(self.mainTextColor)
    self.title:SetTextInset(0,-5 * aura_scaleY)
    self.title:SizeToContents()
    self.title:CenterHorizontal()

    self.title.Paint = function (text, w,h)
        surface.SetDrawColor(self.borderColor)
        surface.DrawLine(0,h-1,w,h-1)
    end

    local titlePadding = self.title:GetTall() + 10 * aura_scaleY

    self.closeButton = vgui.Create("DButton", self)
    self.closeButton:SetSize(closeButtonSize, closeButtonSize)
    self.closeButton:SetPos(self:GetWide() - self.closeButton:GetWide() - sidePadding / 2, sidePadding / 2)
    self.closeButton:SetText("")

    self.closeButton.Paint = function(pan, w, h)
        surface.SetDrawColor(aura_quest_color_red)
        surface.DrawLine(0, 0, w, h)
        surface.DrawLine(0, h, w, 0)
    end

    self.closeButton.DoClick = function()
        self:Remove()
    end

    self.scrollerWidth = self:GetWide() - (sidePadding * 2)

    self.convarScroller = vgui.Create("DScrollPanel",self)
    self.convarScroller:Dock( FILL )
    self.convarScroller:DockMargin(sidePadding, sidePadding + titlePadding, sidePadding, sidePadding)
    local sbar = self.convarScroller:GetVBar()
    sbar:SetWide(0)

    self.convarY = 0
    self.spacing = 15 * aura_scaleY

    self:DisplayConvars() 
end

function PANEL:DisplayConvars()
    for k,v in SortedPairsByMemberValue(Aura_Quest.Convars, "t") do
        local conVarPanel = vgui.Create("DPanel",self.convarScroller)
        conVarPanel:SetPos(0, self.convarY)
        conVarPanel:SetWide(self.scrollerWidth)

        function conVarPanel:Paint(w,h)
        end

        local conVarTitle = vgui.Create("QuestWrappingDLabel",conVarPanel)
        conVarTitle:SetFont("QuestFontQuestTiny")
        conVarTitle:SetWide(self.scrollerWidth)
        conVarTitle:SetPos(0, 0)
        conVarTitle:SetTextColor(self.mainTextColor)
        conVarTitle:SetText("- " .. v.name .. " -\n" .. v.description .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_CurrentValue") .. " " .. GetConVarString(k) .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_DefaultValue") .. " " .. v.default)

        local conVarEditor
        local editorHeight = 0

        if (v.t == "Color") then
            conVarEditor = vgui.Create("DColorMixer",conVarPanel)
            conVarEditor:SetPos(0, conVarTitle:GetTall() + (5 * aura_scaleY))
            conVarEditor:SetSize(defaultSizeX / 2,defaultSizeX / 4)
            conVarEditor:SetColor(string.ToColor(GetConVarString(k)))

            conVarEditor.ValueChanged = function(editor, col)
                if (col.a == 0) then
                    col.a = 255
                end
                local colString = col.r .. " " .. col.g .. " " .. col.b .. " " .. col.a
                if (ConVarExists(k)) then
                    local cvar = GetConVar(k)
                    cvar:SetString(colString)
                end
                conVarTitle:SetText("- " .. v.name .. "-\n" .. v.description .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_CurrentValue") .. " " .. colString .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_DefaultValue") .. " " .. v.default)
                conVarTitle:SetTextColor(col)
            end

            editorHeight = conVarEditor:GetTall()
        end

        if (v.t == "Number") then
            conVarEditor = vgui.Create("DNumSlider",conVarPanel)
            conVarEditor:SetPos(0, conVarTitle:GetTall() + (5 * aura_scaleY))
            conVarEditor:SetSize(defaultSizeX / 2,30 * aura_scaleY)
            conVarEditor:SetDefaultValue( tonumber(v.default) )
            conVarEditor:SetMin(0)
            local max = 0
            if (v.dimension) then
                if (v.dimension == "x") then
                    max = ScrW()
                end
                if (v.dimension == "y") then
                    max = ScrH()
                end
            end
            if (conVarEditor.Label) then
                conVarEditor.Label:SetTextInset(5 * aura_scaleX,0)
            end
            conVarEditor:SetText( k )
            conVarEditor:SetMax(max)
            conVarEditor:SetDecimals( 0 )
            conVarEditor:SetValue(GetConVar(k):GetInt())
            conVarEditor:SetConVar( k )

            conVarEditor.ValueChanged = function(editor, val)
                val = math.Round(val)
                conVarTitle:SetText("- " .. v.name .. "-\n" .. v.description .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_CurrentValue") .. " " .. val .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_DefaultValue") .. " " .. v.default)
            end

            conVarEditor.Paint = function(button, w, h)
                draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_white)
                surface.SetDrawColor(self.borderColor)

                surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
            end

            editorHeight = conVarEditor:GetTall()
        end

        if (v.t == "Dropdown") then
            conVarEditor = vgui.Create("DComboBox",conVarPanel)
            conVarEditor:SetPos(0, conVarTitle:GetTall() + (5 * aura_scaleY))
            conVarEditor:SetSize(defaultSizeX / 2,30 * aura_scaleY)
            conVarEditor:SetFont("QuestFontQuestTiny")
            conVarEditor:SetTextColor(self.mainTextColor)
            conVarEditor:SetValue( GetConVarString(k) )

            for n,m in pairs(v.options) do
                conVarEditor:AddChoice(n)
            end

            conVarEditor.OnSelect = function(editor, index, text, data )
                local cvar = GetConVar(k)
                cvar:SetString(text)
                conVarTitle:SetText("- " .. v.name .. "-\n" .. v.description .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_CurrentValue") .. " " .. text .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_DefaultValue") .. " " .. v.default)
            end

            conVarEditor.Paint = function(button, w, h)
                draw.RoundedBox(0,0,0,w,h,aura_quest_color_off_white)
                surface.SetDrawColor(self.borderColor)

                surface.DrawOutlinedRect(0,0,w,h, 2 * aura_scaleX)
            end

            editorHeight = conVarEditor:GetTall()
        end

        local resetButton = vgui.Create("DButton",conVarPanel)
        resetButton:SetPos(0,conVarTitle:GetTall() + (15 * aura_scaleY) + editorHeight)
        resetButton:SetSize(self.scrollerWidth,40 * aura_scaleY)
        resetButton:SetTextColor(self.mainTextColor)
        resetButton:SetText("#Aura_Quest_Settings_ResetValue")
        resetButton:SetFont("QuestFontQuestTiny")

        resetButton.Paint = function(button, w, h)
            draw.RoundedBox(0,0,0,w,h,self.darkColor)
            surface.SetDrawColor(self.borderColor)

            surface.DrawOutlinedRect(0,0,w,h, 3 * aura_scaleX)
        end

        resetButton.DoClick = function(button)
            if (v.t == "Color") then
                conVarEditor:SetColor(string.ToColor(v.default))
                conVarTitle:SetTextColor(self.mainTextColor)
            end
            if (v.t == "Number") then
                conVarEditor:SetValue(tonumber(v.default))
                if (conVarEditor.Slider and conVarEditor.Scratch) then
                    conVarEditor.Slider:SetSlideX( conVarEditor.Scratch:GetFraction( tonumber(v.default) ) )
                end
            end
            if (v.t == "Dropdown") then
                conVarEditor:SetValue(v.default)
                conVarTitle:SetText("- " .. v.name .. "-\n" .. v.description .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_CurrentValue") .. " " .. v.default .. "\n\n" .. language.GetPhrase("Aura_Quest_Settings_DefaultValue") .. " " .. v.default)
                local cvar = GetConVar(k)
                cvar:SetString(v.default)
            end
        end

        conVarPanel:SizeToChildren(true,true)

        self.convarY = self.convarY + conVarPanel:GetTall() + self.spacing
    end
end


derma.DefineControl("QuestPlayerPreferenceMenu", "", PANEL, "DPanel")