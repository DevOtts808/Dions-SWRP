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

local THEME = StarWarsHUD.Config.Theme

SummeLibrary:CreateFont("StarWarsHUD.HPCount", ScrH() * .015, 300, false)
SummeLibrary:CreateFont("StarWarsHUD.AmmoCount", ScrH() * .011, 300, false)
SummeLibrary:CreateFont("StarWarsHUD.Name", ScrH() * .02, 300, false)
SummeLibrary:CreateFont("StarWarsHUD.Credits", ScrH() * .017, 300, false)

local barColor = THEME.hpBarDamage

hook.Add("HUDPaint", "StarWarsHUD.DrawMain", function()
    if not StarWarsHUD:IsElementEnabled("main") then return end
    if not LocalPlayer():Alive() then return end

    local scrw, scrh = ScrW(), ScrH()

    local hudStartPos = {
        x = StarWarsHUD.Config.Modules["main"].x,
        y = StarWarsHUD.Config.Modules["main"].y,
    }

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .164, scrh * .04, THEME.blurBackgroundColor)
    draw.DrawBlur(hudStartPos.x, hudStartPos.y, scrw * .164, scrh * .04, 4, 3, 255)

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .17, scrh * .0025, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y + scrh * .04, scrw * .17, scrh * .0025, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y - scrh * .025, scrw * .0015, scrh * .095, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x + scrw * .13, hudStartPos.y, scrw * .0015, scrh * .04, THEME.grey)

    for i = 0, 2 do
        draw.RoundedBox(0, hudStartPos.x + scrw * .163, hudStartPos.y + (scrh * .0155 * i), scrw * .0015, scrh * .01, THEME.grey)
    end

    local hp, maxHp = LocalPlayer():Health(), LocalPlayer():GetMaxHealth()
    local quotient = math.Clamp(hp/maxHp, 0, 1)

    if barColor != THEME.hpBar then
        barColor = SummeLibrary:LerpColor(FrameTime() * 1, barColor, THEME.hpBar)
    end

    draw.RoundedBox(3, hudStartPos.x + scrw * .0045, hudStartPos.y + scrh * .0065, (scrw * .12225), scrh * .029, THEME.hpBarBackground)
    draw.RoundedBox(3, hudStartPos.x + scrw * .0045, hudStartPos.y + scrh * .0065, (scrw * .12225) * quotient, scrh * .029, barColor)

    local ap, maxAp = LocalPlayer():Armor(), StarWarsHUD.Config.Modules["main"].useGetMaxArmor and LocalPlayer():GetMaxArmor() or 255
    local quotient = math.Clamp(ap/maxAp, 0, 1)

    draw.RoundedBox(3, hudStartPos.x + scrw * .0045, hudStartPos.y + scrh * .03, (scrw * .12225) * quotient, scrh * .0057, THEME.apBar)

    draw.DrawText(hp, "StarWarsHUD.HPCount", hudStartPos.x + scrw * .1465, hudStartPos.y + scrh * .0063, THEME.whiteText, TEXT_ALIGN_CENTER)
    draw.DrawText(ap, "StarWarsHUD.AmmoCount", hudStartPos.x + scrw * .1468, hudStartPos.y + scrh * .022, THEME.whiteText, TEXT_ALIGN_CENTER)

    draw.DrawText(LocalPlayer():Name(), "StarWarsHUD.Name", hudStartPos.x + scrw * .005, hudStartPos.y - scrh * .023, THEME.whiteText, TEXT_ALIGN_LEFT)

    draw.DrawText(StarWarsHUD.Config.GetJob(LocalPlayer()) or "#RANK", "StarWarsHUD.Name", hudStartPos.x + scrw * .005, hudStartPos.y + scrh * .043, THEME.whiteText, TEXT_ALIGN_LEFT)

    draw.DrawText(StarWarsHUD.Config.GetMoney(LocalPlayer()), "StarWarsHUD.Credits", hudStartPos.x + scrw * .1615, hudStartPos.y - scrh * .022, THEME.money, TEXT_ALIGN_RIGHT)
end)

net.Receive("StarWarsHUD.DamageReceived", function()
    local dmgCount = net.ReadUInt(16)
    local dmgType = net.ReadUInt(16)

    barColor = THEME.hpBarDamage
end)

SummeLibrary:CreateFont("StarWarsHUD.WeaponXS", ScrH() * .01, 300, false)
SummeLibrary:CreateFont("StarWarsHUD.WeaponS", ScrH() * .013, 300, false)

hook.Add("HUDPaint", "StarWarsHUD.WeaponInfo", function()
    if not StarWarsHUD:IsElementEnabled("weapon") then return end
    if not LocalPlayer():Alive() then return end
    
    local scrw, scrh = ScrW(), ScrH()

    local hudStartPos = {
        x = StarWarsHUD.Config.Modules["weapon"].x,
        y = StarWarsHUD.Config.Modules["weapon"].y,
    }

    draw.RoundedBox(0, hudStartPos.x + scrw * .005, hudStartPos.y, scrw * .091, scrh * .0395, THEME.blurBackgroundColor)
    draw.DrawBlur(hudStartPos.x + scrw * .005, hudStartPos.y, scrw * .091, scrh * .0395, 4, 5, 255)

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .1, scrh * .0025, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y + scrh * .04, scrw * .1, scrh * .0025, THEME.grey)

    for i = 0, 2 do
        draw.RoundedBox(0, hudStartPos.x + scrw * .095, hudStartPos.y + (scrh * .0155 * i), scrw * .0015, scrh * .01, THEME.grey)
        draw.RoundedBox(0, hudStartPos.x + scrw * .005, hudStartPos.y + (scrh * .0155 * i), scrw * .0015, scrh * .01, THEME.grey)
    end

    local weaponObj = LocalPlayer():GetActiveWeapon()
    if not IsValid(weaponObj) then return end

    local printName = weaponObj:GetPrintName() or "Weapon"
    local font = "StarWarsHUD.Name"

    if #printName > 30 then
        font = "StarWarsHUD.WeaponXS"
    elseif #printName > 15 then
        font = "StarWarsHUD.WeaponS"
    end

    local ammoCurrent = weaponObj:Clip1()
    if ammoCurrent < 0 then
        draw.SimpleText(weaponObj.PrintName or "Weapon", font, hudStartPos.x + scrw * .05, hudStartPos.y + scrh * .019, THEME.whiteText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        local ammoType = weaponObj:GetPrimaryAmmoType()
        local ammoMax = LocalPlayer():GetAmmoCount(ammoType)
        draw.SimpleText(weaponObj.PrintName or "Weapon", font, hudStartPos.x + scrw * .01, hudStartPos.y + scrh * .019, THEME.whiteText, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.DrawText(ammoCurrent, "StarWarsHUD.HPCount", hudStartPos.x + scrw * .088, hudStartPos.y + scrh * .0063, THEME.whiteText, TEXT_ALIGN_RIGHT)
        draw.DrawText(ammoMax, "StarWarsHUD.AmmoCount", hudStartPos.x + scrw * .088, hudStartPos.y + scrh * .02, THEME.whiteText, TEXT_ALIGN_RIGHT)
    end
end)


SummeLibrary:CreateFont("StarWarsHUD.OHName", 20, 300, false)
SummeLibrary:CreateFont("StarWarsHUD.OHRank", 12, 300, false)

local greyAlpha = ColorAlpha(THEME.grey, 50)

hook.Add("HUDPaint", "StarWarsHUD.OverHead", function()
    if not StarWarsHUD:IsElementEnabled("overhead") then return end

    trace = LocalPlayer():GetEyeTrace()
    ent = trace.Entity

    if not IsValid(ent) then return end
    if not ent:IsPlayer() then return end
    if LocalPlayer():GetPos():Distance(ent:GetPos()) > 400 then return end
    if StarWarsHUD.Config.PlayerIsInvisible(ent) then return end

    local ply = ent

    local pos = ply:EyePos()
    pos.z = pos.z + 25
    pos = pos:ToScreen()

    local name = ply:Name()

    local scrw, scrh = ScrW(), ScrH()

    surface.SetDrawColor(THEME.whiteText)
    surface.SetFont("StarWarsHUD.Name")
    local ts = surface.GetTextSize(name)
    local width = scrw * .03 + ts

    draw.DrawBlur(pos.x - width/2, pos.y, width, scrh * .034, 4, 5, 255)

    draw.RoundedBox(0, pos.x - width/2, pos.y - scrh * .001, width, scrh * .0025, greyAlpha)

    draw.DrawText(name, "StarWarsHUD.OHName", pos.x, pos.y, THEME.whiteText, TEXT_ALIGN_CENTER)
    draw.DrawText(StarWarsHUD.Config.GetJob(ply) or "#RANK", "StarWarsHUD.OHRank", pos.x, pos.y + scrh * .018, THEME.whiteText, TEXT_ALIGN_CENTER)

    draw.RoundedBox(0, pos.x - width/2, pos.y + scrh * .033, width, scrh * .0025, greyAlpha)

    for i = 0, 2 do
        draw.RoundedBox(0, pos.x - width * .45, pos.y - scrh * .003 + (scrh * .0153 * i), scrw * .0015, scrh * .01, greyAlpha)
        draw.RoundedBox(0, pos.x + width * .435, pos.y - scrh * .003 + (scrh * .0153 * i), scrw * .0015, scrh * .01, greyAlpha)
    end
end)