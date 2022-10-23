local intensity = 0
local vig = Material("summe/officer_boost/vignette_w")

local function DrawHUDStuff(color)

    color = ColorAlpha(color, 100)

    surface.PlaySound("summe/officer_boost/on.mp3")
    hook.Add("HUDPaint", "OfficerBoost.FancyHUDStuff", function()    
        local ply = LocalPlayer()
        local x, y = ScrW(), ScrH()
        local FT = FrameTime()
    
        if not ply:Alive() then return end
        
        intensity = math.Approach(intensity, 2, FT * 3)
    
        surface.SetMaterial(vig)
        surface.SetDrawColor(color, (50 * intensity) * 0.3)
        surface.DrawTexturedRect(0, 0, x, y)
    end)    
end

local intPol = 0
local function DrawPlayerEffect(ply, color, radius)
    hook.Add("PostPlayerDraw", "OfficerBoost.FancyPlayerEffect", function(targetPly, flags)
        if not targetPly == ply then return end

        render.SetMaterial(Material("particle/particle_ring_wave_addnofog"))
        intPol = Lerp(FrameTime() * 3, intPol, radius * 2)
        render.DrawQuadEasy(ply:GetPos(), Vector(0, 0, 1), intPol, intPol, color, 0)
    end)
end

net.Receive("OfficerBoost.DrawHUD", function()

    local steamID = net.ReadString()
    local ply = player.GetBySteamID64(steamID) or Entity(2)
    local type = net.ReadString()

    print(ply)

    local data = OfficerBoost.Config[type]

    DrawHUDStuff(data.Color)

    intPol = 0

    timer.Simple(data.Duration, function()
        surface.PlaySound("summe/officer_boost/off.mp3")
        LocalPlayer():ScreenFade(SCREENFADE.IN, color_white, 0.4, 0.2)
        hook.Remove("HUDPaint", "OfficerBoost.FancyHUDStuff")
    end)

    if not IsValid(ply) then return end

    DrawPlayerEffect(ply, data.Color, data.Radius)

    timer.Simple(3, function()
        hook.Remove("PostPlayerDraw", "OfficerBoost.FancyPlayerEffect")
    end)

    if data.Sounds and data.Sounds != {} then
        ply:EmitSound(table.Random(data.Sounds), 100, 100, 1, CHAN_VOICE)
    end
end)