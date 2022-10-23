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

local mat_soundon = Material("summe/bf2_scoreboard/sound_on.png", "noclamp smooth")
local mat_soundoff = Material("summe/bf2_scoreboard/sound_off.png", "noclamp smooth")

function LerpColor(frac,from,to)
	local col = Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
	)
	return col
end
 

local PlayerRow = {}

function PlayerRow:Init()
    self:SetText("")
    self.Collapsed = true
end

function PlayerRow:Paint(W, H)

    local w = self.w
    local h = self.h

    local theme = BF2_Scoreboard.Config.Theme
    local color

    if not IsValid(self.player) then return end

    if self.key%2 != 0 then
        color = Color(59,59,59,82)
    else
        color = Color(46,46,46,82)
    end

    if self.player == LocalPlayer() then
        color = ColorAlpha(theme.primary, 40)
    end

    if self:IsHovered() then
        color = ColorAlpha(color, 100)
    end

    local usrgrpName, usrgrpColor = BF2_Scoreboard:GetUsergroup(self.player)
    local rankName, rankColor = BF2_Scoreboard:GetRank(self.player)

    draw.RoundedBoxEx(5, 0, 0, W, H, color, true, true, true, true)

    draw.DrawText(self.key, "BF2Scoreboard.PlayerRow", w * .015, h * .17, theme.white, TEXT_ALIGN_CENTER)
    draw.DrawText(BF2_Scoreboard:ShortenString(self.player:Nick(), 26), "BF2Scoreboard.PlayerRow", w * .06, h * .17, theme.white, TEXT_ALIGN_LEFT)
    draw.DrawText(BF2_Scoreboard:ShortenString(rankName, 50), "BF2Scoreboard.PlayerRow", w * .265, h * .17, rankColor, TEXT_ALIGN_LEFT)
    draw.DrawText(BF2_Scoreboard:ShortenString(usrgrpName, 17), "BF2Scoreboard.PlayerRow", w * .65, h * .17, usrgrpColor, TEXT_ALIGN_LEFT)
    draw.DrawText(self.player:GetNWInt("BF2SB_TotalKills", 0), "BF2Scoreboard.PlayerRow", w * .838, h * .17, theme.white, TEXT_ALIGN_CENTER)
    draw.DrawText(self.player:Deaths(), "BF2Scoreboard.PlayerRow", w * .901, h * .17, theme.white, TEXT_ALIGN_CENTER)
    draw.DrawText(self.player:Ping(), "BF2Scoreboard.PlayerRow", w * .966, h * .17, theme.white, TEXT_ALIGN_CENTER)

    surface.SetDrawColor(theme.white)
    surface.DrawRect(w * .25, 0, w * .001, h)
    surface.DrawRect(w * .635, 0, w * .001, h)
    surface.DrawRect(w * .805, 0, w * .001, h)
    surface.DrawRect(w * .87, 0, w * .001, h)
    surface.DrawRect(w * .933, 0, w * .001, h)

    -- Details
    surface.DrawRect(0, h, w, h * .05)
    draw.DrawText(self.steamName or "nil", "BF2Scoreboard.PlayerRow", w * .01, h * 1.2, theme.grey, TEXT_ALIGN_LEFT)

end

function PlayerRow:DoClick()
    if self.Collapsed then
        self:SizeTo(self.w, self.h * 2, .2)
        self.Collapsed = false
    else
        self:SizeTo(self.w, self.h, .2)
        self.Collapsed = true
    end
end

function PlayerRow:SetPlayer(ply)
    if ply and ply:IsPlayer() then
        self.player = ply

        steamworks.RequestPlayerInfo(ply:SteamID64() or "bot", function(steamName)
            if steamName == "" then
                steamName = "#STEAMNAME"
            end
            self.steamName = steamName
        end)

        local theme = BF2_Scoreboard.Config.Theme

        local panel = self

        local width, height = self.w, self.h

        self.Avatar = vgui.Create("SummeLibrary.CircularAvatar", self)
        self.Avatar:SetPlayer(self.player, 64)
        self.Avatar:SetAlpha(200)
        self.Avatar:SetPos(width * .033, height * .12)
        self.Avatar:SetSize(height * .8, height * .8)

        self.MuteButton = vgui.Create("DButton", self)
        self.MuteButton:SetAlpha(200)
        self.MuteButton:SetPos(width * .96, height * 1.13)
        self.MuteButton:SetSize(height * .8, height * .8)
        self.MuteButton:SetText("")
        function self.MuteButton:Paint(w, h)
            if not IsValid(ply) then panel:Remove() return end
            if ply:IsMuted() then
                surface.SetMaterial(mat_soundoff)
            else
                surface.SetMaterial(mat_soundon)
            end
            surface.SetDrawColor(color_white)
            surface.DrawTexturedRect(0, 0, w, h)
        end
        function self.MuteButton:DoClick()
            if ply:IsMuted() then
                ply:SetMuted(false)
            else
                ply:SetMuted(true)
            end
        end

        self.ButtonPanel = vgui.Create("DPanel", self)
        self.ButtonPanel:SetPos(width * .25, height * 1.13)
        self.ButtonPanel:SetSize(width * .7, height * .8)
        self.ButtonPanel:SetDrawBackground(false)

        for k, v in SortedPairs(BF2_Scoreboard.Config.Actions) do
            local btn = vgui.Create("DButton", self.ButtonPanel)
            btn:Dock(LEFT)
            btn:DockMargin(width * .01, 0, 0, 0)
            btn:SetWide(width * .03)
            btn:SetText("")
            function btn:Paint(w, h)

                if self:IsHovered() then
                    draw.DrawText(v.name, "BF2Scoreboard.Actions", w * .5, h * .17, theme.white, TEXT_ALIGN_CENTER)
                else
                    surface.SetDrawColor(color_white)
                    if self:IsHovered() then surface.SetDrawColor(theme.grey) end
                    surface.SetMaterial(v.icon)
                    surface.DrawTexturedRect(w * .25, 0, w * .6, h)
                end
            end
            function btn:DoClick()
                v.func(ply, PlayerRow)
                surface.PlaySound("UI/buttonclick.wav")
            end
        end
    end
end

function PlayerRow:SetKey(key)
    self.key = key
end

function PlayerRow:GetPlayer()
    return self.player or false
end

vgui.Register("BF2Scoreboard.PlayerRow", PlayerRow, "DButton")