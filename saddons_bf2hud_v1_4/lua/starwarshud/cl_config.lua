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

StarWarsHUD.Config = {}
StarWarsHUD.Config.Modules = {}

-- CHANGES ONLY APPLY AFTER MAPCHANGE / REJOIN!!!

StarWarsHUD.Config.Theme = {
    blurBackgroundColor = Color(24,24,24,63),
    grey = Color(248,248,248,84),
    greyBackground = Color(34,34,34,20),
    whiteText = Color(255,255,255),
    hpBar = Color(255,255,255),
    hpBarDamage = Color(255,0,0),
    hpBarBackground = Color(34,34,34,93),
    apBar = Color(15,82,186),
    money = Color(180,255,177),
    radarGrid = Color(138,138,138,5),
    radarMarkingPlayer = Color(246,255,163),
    radarMarkingNextbot = Color(255,129,129),
    radarMarkingNPC = Color(255,129,129),
    radarMarkingLFS = Color(130,236,255),
    weaponSelectorHighlight = Color(255,196,0),
    lfsThrottleLimitColor = Color(255,116,116),
    lfsThrottleColor = Color(255,255,255),
}

--[[
StarWarsHUD.Config.Theme = {
    blurBackgroundColor = Color(115,246,255,5),
    grey = Color(0,204,255,129),
    greyBackground = Color(34,34,34,20),
    whiteText = Color(255,255,255),
    hpBar = Color(255,255,255),
    hpBarDamage = Color(255,0,0),
    hpBarBackground = Color(34,34,34,93),
    apBar = Color(142,153,255),
    money = Color(180,255,177),
    radarGrid = Color(138,138,138,5),
    radarMarkingPlayer = Color(246,255,163),
    radarMarkingNextbot = Color(255,129,129),
    radarMarkingNPC = Color(255,129,129),
    radarMarkingLFS = Color(130,236,255),
    weaponSelectorHighlight = Color(255,196,0),
    lfsThrottleLimitColor = Color(255,116,116),
    lfsThrottleColor = Color(255,255,255),
}
]]--

local scrw, scrh = ScrW(), ScrH()

StarWarsHUD.Config.Modules["main"] = {
    enabled = true,
    x = scrw * .02,
    y = scrh * .89,
    useGetMaxArmor = false, -- turn to false if the armor bar is not getting displayed
}

StarWarsHUD.Config.Modules["weapon"] = {
    enabled = true,
    x = scrw * .86,
    y = scrh * .92,
}

StarWarsHUD.Config.Modules["radar"] = {
    enabled = false,
    x = scrw * .8455,
    y = scrh * .67,
}

StarWarsHUD.Config.Modules["lfs"] = {
    enabled = true,
    x = scrw * .86,
    y = scrh * .17,
}

StarWarsHUD.Config.Modules["weaponselector"] = {
    enabled = false,
}

StarWarsHUD.Config.Modules["overhead"] = {
    enabled = true,
}

StarWarsHUD.Config.GetMoney = function(ply)
    if DarkRP then
        return DarkRP.formatMoney(ply:getDarkRPVar("money"))
    end

    if ix then
        local char = ply:GetCharacter()
        if not char then return 0 end

        local money = char:GetMoney()

        return ix.currency.Get(money)
    end

    if nut then
        local char = ply:getChar()
        if not char then return 0 end

        local money = char:getMoney()

        return nut.currency.get(money)
    end

    if YRP then
        return ply:YRPGetMoney()
    end

    return ""
end

StarWarsHUD.Config.GetJob = function(ply)
    if DarkRP or nut or ix then
        return SummeLibrary:GetRank(ply)
    end

    return "#JOB"
end

StarWarsHUD.Config.CheckEntity = function(ent) -- RADAR
    if ent == LocalPlayer() then return false end

    if ent:IsPlayer() then
        if StarWarsHUD.Config.PlayerIsInvisible(ent) then return end

        return {
            color = StarWarsHUD.Config.Theme.radarMarkingPlayer,
        }
    end

    if ent:IsNextBot() then
        return {
            color = StarWarsHUD.Config.Theme.radarMarkingNextbot,
        }
    end

    if ent:IsNPC() then
        return {
            color = StarWarsHUD.Config.Theme.radarMarkingNPC,
        }
    end

    if ent.LFS then
        return {
            color = StarWarsHUD.Config.Theme.radarMarkingLFS,
            material = "CLQP8vb",
        }
    end


    return false
end

StarWarsHUD.Config.PlayerIsInvisible = function(ply)
    if ply:GetRenderMode() == RENDERMODE_TRANSALPHA or ply:GetColor().a == 0 then
        return true
    end

    return false
end