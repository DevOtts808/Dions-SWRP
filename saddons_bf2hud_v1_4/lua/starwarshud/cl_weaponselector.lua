--[[
   _____ _          __          __            _    _ _    _ _____  
  / ____| |         \ \        / /           | |  | | |  | |  __ \ 
 | (___ | |_ __ _ _ _\ \  /\  / /_ _ _ __ ___| |__| | |  | | |  | |
  \___ \| __/ _` | '__\ \/  \/ / _` | '__/ __|  __  | |  | | |  | |
  ____) | || (_| | |   \  /\  / (_| | |  \__ \ |  | | |__| | |__| |
 |_____/ \__\__,_|_|    \/  \/ \__,_|_|  |___/_|  |_|\____/|_____/ 
                                                                                                                          
        Created by Summe https://steamcommunity.com/id/DerSumme/
        Purchased content: https://discord.gg/k6YdMwj9w2                          
]]--

if not StarWarsHUD:IsElementEnabled("weaponselector") then return end

hook.Add("HUDShouldDraw", "StarWarsHUD.HideWeaponSelector", function(name)
    if name == "CHudWeaponSelection" then
        return false
    end
end)

local THEME = StarWarsHUD.Config.Theme

StarWarsHUD._currentNum = 1
StarWarsHUD._closeTime = 0

SummeLibrary:CreateFont("StarWarsHUD.WS.Header", ScrH() * .03, 500, false)
SummeLibrary:CreateFont("StarWarsHUD.WS.Btn", ScrH() * .02, 500, false)
SummeLibrary:CreateFont("StarWarsHUD.WS.BtnActive", ScrH() * .02, 1000, false)

function StarWarsHUD:OpenWeaponSelector()
    self.Menu = vgui.Create("DFrame")
    self.Menu:SetSize(ScrW(), ScrH())
    self.Menu:SetDraggable(false)
    self.Menu:ShowCloseButton(false)
    self.Menu:Center()
    self.Menu:SetAlpha(0)
    self.Menu:SetTitle("")
    self.Menu:AlphaTo(255, 0.3, 0)

    function self.Menu:Close()
        self:AlphaTo(0, 0.3, 0, function()
            self:Remove()
        end)
    end

    local Scrw, Scrh = ScrW(), ScrH()

    function self.Menu:Paint(w, h)
    end

    StarWarsHUD._closeTime = CurTime() + 3

    function self.Menu:Think()
        if StarWarsHUD._closeTime <= CurTime() then
            self:Close()
        end
    end

    local _weapons = LocalPlayer():GetWeapons()
    table.sort(_weapons, function(a, b) return a:GetSlot() < b:GetSlot() end)

    for i = 0, 5 do
        local slotColumn = vgui.Create("DPanel", self.Menu)
        slotColumn:SetPos(Scrw * .18 + (Scrw * .105 * i), Scrh * .1)
        slotColumn:SetSize(Scrw * .1, Scrh * .6)
        function slotColumn:Paint(w, h)
            --draw.RoundedBox(0, 0, 0, w, h * .03, THEME.grey)
        end

        local header = vgui.Create("DButton", slotColumn)
        header:Dock(TOP)
        header:SetText("")
        header:SetSize(0, Scrh * .07)
        function header:Paint(w, h)
            draw.DrawPanelBlur(self, 6) 

            draw.RoundedBox(0, 0, 0, w, h * .03, THEME.grey)
            draw.RoundedBox(0, 0, h * .97, w, h * .03, THEME.grey)

            for i = 0, 2 do
                draw.RoundedBox(0, w * .07, h * .05 + (h * .35 * i), w * .02, h * .21, THEME.grey)
                draw.RoundedBox(0, w * .93, h * .05 + (h * .35 * i), w * .02, h * .21, THEME.grey)
            end

            draw.DrawText(i + 1, "StarWarsHUD.WS.Header", w * .5, h * .32, color_white, TEXT_ALIGN_CENTER)
        end

        for key, weaponObj in pairs(_weapons) do
            if not IsValid(weaponObj) then continue end
            local activeWeapon = LocalPlayer():GetActiveWeapon()
            if not IsValid(activeWeapon) then continue end -- pretty dumb I know

            if weaponObj:GetClass() == activeWeapon:GetClass() then
                StarWarsHUD._currentNum = key
            end

            if weaponObj:GetSlot() == i then

                local btn = vgui.Create("DButton", slotColumn)
                btn:Dock(TOP)
                btn:DockMargin(0, Scrh * .005, 0, 0)
                btn:SetText("")
                btn:SetSize(0, Scrh * .04)
                btn.key = key
                btn.BarStatus = 0


                function btn:Paint(w, h)
                    local color = THEME.whiteText
                    if not IsValid(weaponObj) then return end

                    if StarWarsHUD._currentNum == btn.key then
                        color = THEME.weaponSelectorHighlight
                        draw.DrawText(weaponObj:GetPrintName(), "StarWarsHUD.WS.BtnActive", w * .5, h * .32, color, TEXT_ALIGN_CENTER)
                        self.BarStatus = math.Clamp(self.BarStatus + (FrameTime() * 7), 0, 1)
                    else
                        draw.DrawText(weaponObj:GetPrintName(), "StarWarsHUD.WS.Btn", w * .5, h * .32, color, TEXT_ALIGN_CENTER)
                        self.BarStatus = math.Clamp(self.BarStatus - (FrameTime() * 7), 0, 1)
                    end

                    draw.RoundedBox(0, 0, h * .95, w * self.BarStatus, h * .05, color_white)
                end

            end
        end
    end
end

hook.Add("PlayerBindPress", "StarWarsHUD.WeaponSelector", function(ply, bind, pressed)
    if LocalPlayer():InVehicle() then return end

    if bind == "invnext" and not ply:KeyDown(IN_ATTACK) and pressed then
        if not IsValid(StarWarsHUD.Menu) then
            StarWarsHUD:OpenWeaponSelector()
        else
            StarWarsHUD._closeTime = CurTime() + 3
        end

        StarWarsHUD._currentNum = math.Clamp(StarWarsHUD._currentNum + 1, 0, #LocalPlayer():GetWeapons())

        surface.PlaySound("summe/hud/navigation_tab_01.mp3")
    end

    if bind == "invprev" and not ply:KeyDown(IN_ATTACK) and pressed then
        if not IsValid(StarWarsHUD.Menu) then
            StarWarsHUD:OpenWeaponSelector()
        else
            StarWarsHUD._closeTime = CurTime() + 3
        end

        StarWarsHUD._currentNum = math.Clamp(StarWarsHUD._currentNum - 1, 1, 1000)

        surface.PlaySound("summe/hud/navigation_tab_01.mp3")
    end

    if string.sub(bind, 1, 4) == "slot" and not ply:KeyDown(IN_ATTACK) and pressed then
        local n = tonumber(string.sub(bind, 5, 5) or 1) or 1
        n = n - 1

        if not IsValid(StarWarsHUD.Menu) then
            StarWarsHUD:OpenWeaponSelector()
        else
            StarWarsHUD._closeTime = CurTime() + 3
        end

        local _weapons = LocalPlayer():GetWeapons()
        table.sort(_weapons, function(a, b) return a:GetSlot() < b:GetSlot() end)

        local _nextWeaponExists = IsValid(_weapons[StarWarsHUD._currentNum + 1])
        local _weaponExists = IsValid(_weapons[StarWarsHUD._currentNum])

        if _weaponExists and _weapons[StarWarsHUD._currentNum]:GetSlot() == n and _nextWeaponExists and _weapons[StarWarsHUD._currentNum + 1]:GetSlot() == n then
            StarWarsHUD._currentNum = StarWarsHUD._currentNum + 1
        else
            for k, weaponObj in SortedPairs(_weapons) do
                if weaponObj:GetSlot() == n then
                    StarWarsHUD._currentNum = k
                    surface.PlaySound("summe/hud/navigation_tab_01.mp3")
                    return
                end
            end
        end
    end

    if bind == "+attack" and IsValid(StarWarsHUD.Menu) and pressed then
        local _weapons = LocalPlayer():GetWeapons()
        table.sort(_weapons, function(a, b) return a:GetSlot() < b:GetSlot() end)
        local weapon = _weapons[StarWarsHUD._currentNum]
        if not IsValid(weapon) then return end

        local wepClass = weapon:GetClass()

        RunConsoleCommand('use', wepClass)

        StarWarsHUD.Menu:Close()

        surface.PlaySound("summe/hud/navigation_activate_01.mp3")

        return true
    end
end)