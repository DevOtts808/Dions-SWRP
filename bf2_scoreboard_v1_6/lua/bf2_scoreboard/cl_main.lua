--[[
  ____        _   _   _       __                 _     _____ _____         _____                    _                         _ 
 |  _ \      | | | | | |     / _|               | |   |_   _|_   _|       / ____|                  | |                       | |
 | |_) | __ _| |_| |_| | ___| |_ _ __ ___  _ __ | |_    | |   | |        | (___   ___ ___  _ __ ___| |__   ___   __ _ _ __ __| |
 |  _ < / _` | __| __| |/ _ \  _| '__/ _ \| '_ \| __|   | |   | |         \___ \ / __/ _ \| '__/ _ \ '_ \ / _ \ / _` | '__/ _` |
 | |_) | (_| | |_| |_| |  __/ | | | | (_) | | | | |_   _| |_ _| |_        ____) | (_| (_) | | |  __/ |_) | (_) | (_| | | | (_| |
 |____/ \__,_|\__|\__|_|\___|_| |_|  \___/|_| |_|\__| |_____|_____|      |_____/ \___\___/|_|  \___|_.__/ \___/ \__,_|_|  \__,_|
                                                                                                                                
                                                                                                                                                                          
    Created by Summe: https://steamcommunity.com/id/DerSumme/ 
    Purchased content: https://discord.gg/k6YdMwj9w2
]]--

local blur = Material("pp/blurscreen")
local frame = Material("summe/bf2_scoreboard/main_new.png", "smooth")

local function DrawBlur(panel, amount)
    local x, y = panel:LocalToScreen(0, 0)
    local scrW, scrH = ScrW(), ScrH()
    surface.SetDrawColor(53, 53, 53)
    surface.SetMaterial(blur)

    for i = 1, 3 do
        blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
    end
end

function BF2_Scoreboard:OpenMenu()
    if self.MainFrame then self.MainFrame:Remove() end

    local width = ScrW() * 1
    local height = ScrH() * 1
    local theme = BF2_Scoreboard.Config.Theme
    local ply = LocalPlayer()

    self.MainFrame = vgui.Create("DFrame")
    self.MainFrame:SetTitle("")
    self.MainFrame:SetSize(width, height)
    self.MainFrame:Center()
    self.MainFrame:SetDraggable(false)
    self.MainFrame:SetTitle("")
    self.MainFrame:ShowCloseButton(false)
    self.MainFrame:MakePopup()
    self.MainFrame:SetKeyboardInputEnabled(false)
    self.MainFrame:SetAlpha(0)
    self.MainFrame.Paint = function(me,w,h)
        DrawBlur(me, 6)
        surface.SetDrawColor(Color(0,0,0,200))
        surface.DrawRect(0,0,w,h)

        surface.SetDrawColor(color_white)
        surface.SetMaterial(frame)
        surface.DrawTexturedRect(w * .056, h * .12, w * .9, h * .85)

        draw.DrawText(BF2_Scoreboard.Config.Texts.subtitle, "BF2Scoreboard.Title", w * .5, h * .05, theme.white, TEXT_ALIGN_CENTER)
        draw.DrawText(BF2_Scoreboard.Config.Texts.title, "BF2Scoreboard.SubTitle", w * .5, h * .03, theme.grey, TEXT_ALIGN_CENTER)

        draw.DrawText(#player.GetAll(), "BF2Scoreboard.PlayerRow", w * .5, h * .12, theme.white, TEXT_ALIGN_CENTER)
        draw.DrawText(game.MaxPlayers(), "BF2Scoreboard.PlayerMax", w * .5, h * .14, theme.grey, TEXT_ALIGN_CENTER)

        draw.DrawText(BF2_Scoreboard:L("MY_STATS"), "BF2Scoreboard.StatsTitle", w * .08, h * .875, theme.primary, TEXT_ALIGN_LEFT)

        draw.DrawText(ply:GetNWInt("BF2SB_TotalKills", 0), "BF2Scoreboard.StatsTitle", w * .32, h * .875, theme.white, TEXT_ALIGN_CENTER)
        draw.DrawText(BF2_Scoreboard:L("KILLS"), "BF2Scoreboard.SubTitle", w * .32, h * .92, theme.primary, TEXT_ALIGN_CENTER)

        draw.DrawText(ply:Deaths(), "BF2Scoreboard.StatsTitle", w * .456, h * .875, theme.white, TEXT_ALIGN_CENTER)
        draw.DrawText(BF2_Scoreboard:L("DEATHS"), "BF2Scoreboard.SubTitle", w * .456, h * .92, theme.primary, TEXT_ALIGN_CENTER)

        draw.DrawText(ply:Ping(), "BF2Scoreboard.StatsTitle", w * .57, h * .875, theme.white, TEXT_ALIGN_CENTER)
        draw.DrawText(BF2_Scoreboard:L("PING"), "BF2Scoreboard.SubTitle", w * .57, h * .92, theme.primary, TEXT_ALIGN_CENTER)

        draw.DrawText(string.upper(ply:GetUserGroup()), "BF2Scoreboard.StatsTitle", w * .775, h * .875, theme.white, TEXT_ALIGN_CENTER)
        draw.DrawText(BF2_Scoreboard:L("USERGROUP"), "BF2Scoreboard.SubTitle", w * .775, h * .92, theme.primary, TEXT_ALIGN_CENTER)


        draw.DrawText(BF2_Scoreboard:L("PLAYER"), "BF2Scoreboard.PlayerRow", w * .09, h * .17, theme.white, TEXT_ALIGN_LEFT)

        draw.DrawText(BF2_Scoreboard:L("RANK"), "BF2Scoreboard.PlayerRow", w * .305, h * .17, theme.white, TEXT_ALIGN_LEFT)

        draw.DrawText(BF2_Scoreboard:L("USERGROUP"), "BF2Scoreboard.PlayerRow", w * .6245, h * .17, theme.white, TEXT_ALIGN_LEFT)

        draw.DrawText(BF2_Scoreboard:L("KILLS"), "BF2Scoreboard.PlayerRow", w * .78, h * .17, theme.white, TEXT_ALIGN_CENTER)

        draw.DrawText(BF2_Scoreboard:L("DEATHS"), "BF2Scoreboard.PlayerRow", w * .833, h * .17, theme.white, TEXT_ALIGN_CENTER)

        draw.DrawText(BF2_Scoreboard:L("PING"), "BF2Scoreboard.PlayerRow", w * .885, h * .17, theme.white, TEXT_ALIGN_CENTER)
    end
    self.MainFrame:AlphaTo(255, 0.2)

    self.PlayerList = vgui.Create("DScrollPanel", self.MainFrame)
    self.PlayerList:SetPos(width * .085, height * .2)
    self.PlayerList:SetSize(width * .83, height * .6)
    local sbar = self.PlayerList:GetVBar()
    sbar:SetSize(0,0)
    
    sbar.LerpTarget = 0

    function sbar:AddScroll(dlta)
        local OldScroll = self.LerpTarget or self:GetScroll()
        dlta = dlta * 75
        self.LerpTarget = math.Clamp(self.LerpTarget + dlta, -self.btnGrip:GetTall(), self.CanvasSize + self.btnGrip:GetTall())

        return OldScroll ~= self:GetScroll()
    end

    sbar.Think = function(s)
        local frac = FrameTime() * 5

        if math.abs(s.LerpTarget - s:GetScroll()) <= (s.CanvasSize / 10) then
            frac = FrameTime() * 2
        end

        local newpos = Lerp(frac, s:GetScroll(), s.LerpTarget)
        s:SetScroll(math.Clamp(newpos, 0, s.CanvasSize))

        if s.LerpTarget < 0 and s:GetScroll() <= 0 then
            s.LerpTarget = 0
        elseif s.LerpTarget > s.CanvasSize and s:GetScroll() >= s.CanvasSize then
            s.LerpTarget = s.CanvasSize
        end
    end

    local function ReSort()

        self.PlayerList:Clear()

        local players = BF2_Scoreboard:GetPlayers()
        local i = 1
        for player, data in SortedPairsByMemberValue(players, cookie.GetString("BF2Scoreboard.SortOrder", "team")) do
            local playerPanel = vgui.Create("BF2Scoreboard.PlayerRow", self.PlayerList)
            playerPanel:Dock(TOP)
            playerPanel:SetTall(height * .035)
            playerPanel.w = width * .83
            playerPanel.h = playerPanel:GetTall()
            playerPanel:SetPlayer(player)
            playerPanel:SetKey(i)
    
            i = i + 1
        end 
    end

    self.SButtonName = vgui.Create("DButton", self.MainFrame)
    self.SButtonName:SetSize(width * .1, height * .02)
    self.SButtonName:SetPos(width * .09, height * .17)
    self.SButtonName:SetText("")
    function self.SButtonName:Paint() end
    function self.SButtonName:DoClick() cookie.Set("BF2Scoreboard.SortOrder", "name") ReSort() end

    self.SButtonTeam = vgui.Create("DButton", self.MainFrame)
    self.SButtonTeam:SetSize(width * .1, height * .02)
    self.SButtonTeam:SetPos(width * .3, height * .17)
    self.SButtonTeam:SetText("")
    function self.SButtonTeam:Paint() end
    function self.SButtonTeam:DoClick() cookie.Set("BF2Scoreboard.SortOrder", "team") ReSort() end

    self.SButtonGroup = vgui.Create("DButton", self.MainFrame)
    self.SButtonGroup:SetSize(width * .1, height * .02)
    self.SButtonGroup:SetPos(width * .62, height * .17)
    self.SButtonGroup:SetText("")
    function self.SButtonGroup:Paint() end
    function self.SButtonGroup:DoClick() cookie.Set("BF2Scoreboard.SortOrder", "group") ReSort() end

    self.SButtonKills = vgui.Create("DButton", self.MainFrame)
    self.SButtonKills:SetSize(width * .04, height * .02)
    self.SButtonKills:SetPos(width * .76, height * .17)
    self.SButtonKills:SetText("")
    function self.SButtonKills:Paint() end
    function self.SButtonKills:DoClick() cookie.Set("BF2Scoreboard.SortOrder", "kills") ReSort() end

    self.SButtonDeaths = vgui.Create("DButton", self.MainFrame)
    self.SButtonDeaths:SetSize(width * .04, height * .02)
    self.SButtonDeaths:SetPos(width * .815, height * .17)
    self.SButtonDeaths:SetText("")
    function self.SButtonDeaths:Paint() end
    function self.SButtonDeaths:DoClick() cookie.Set("BF2Scoreboard.SortOrder", "deaths") ReSort() end

    self.SButtonPing = vgui.Create("DButton", self.MainFrame)
    self.SButtonPing:SetSize(width * .04, height * .02)
    self.SButtonPing:SetPos(width * .865, height * .17)
    self.SButtonPing:SetText("")
    function self.SButtonPing:Paint() end
    function self.SButtonPing:DoClick() cookie.Set("BF2Scoreboard.SortOrder", "ping") ReSort() end
    
    ReSort()
end

hook.Add('ScoreboardShow', '232222222222222', function()
    BF2_Scoreboard:OpenMenu()
    return true
end )

hook.Add('ScoreboardHide', '2333333333', function()
    if IsValid(BF2_Scoreboard.MainFrame) then BF2_Scoreboard.MainFrame:Remove() end
    return true
end )

hook.Add("Battlefront II Scoreboard.Loaded", "RemoveFAdminShit", function()
    hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
    hook.Remove("ScoreboardHide", "FAdmin_scoreboard")
end)