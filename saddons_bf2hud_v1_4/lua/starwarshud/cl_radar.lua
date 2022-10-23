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
local radarRange = 2000
local entCache = {}
local _checkTime = 0

local radarsize_ = 1

hook.Add("HUDPaint", "StarWarsHUD.DrawRadar", function()
    if not StarWarsHUD:IsElementEnabled("radar") then return end
    if not LocalPlayer():Alive() then return end
    
    local scrw, scrh = ScrW(), ScrH()

    local radarsize = {
        w = scrh * .22,
        h = scrh * .22,
    }

    local radarpos = {
        x = StarWarsHUD.Config.Modules["radar"].x,
        y = StarWarsHUD.Config.Modules["radar"].y,
    }

    local radarcenter = {
        x = radarpos.x + radarsize.w/2,
        y = radarpos.y + radarsize.h/2,
    }

    draw.NoTexture()

    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask( 0xFF )
	render.SetStencilTestMask( 0xFF )
	render.SetStencilReferenceValue( 0 )
	render.SetStencilCompareFunction( STENCIL_ALWAYS )
	render.SetStencilPassOperation( STENCIL_KEEP )
	render.SetStencilFailOperation( STENCIL_KEEP )
	render.SetStencilZFailOperation( STENCIL_KEEP )

    
    //If we draw on a pixel, set its value to 15
    render.SetStencilFailOperation( STENCILOPERATION_KEEP )
    render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
    render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
        render.SetStencilReferenceValue(15)
        render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )

    surface.SetDrawColor(THEME.blurBackgroundColor)
    draw.Circle(radarcenter.x * .999, radarcenter.y * .998, scrh * .112 * radarsize_, 30)

    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

    draw.DrawBlur(0, 0, scrw, scrh, 1, 5, 255)

    surface.SetDrawColor(color_white)

    for i = 1, 10 do
        draw.RoundedBox(0, radarpos.x, radarpos.y + scrh * .02 * i, radarsize.w, radarsize.w * .005, THEME.radarGrid)

        draw.RoundedBox(0, radarpos.x + scrw * .012 * i, radarpos.y, radarsize.w * .005, radarsize.w, THEME.radarGrid)
    end

    local t = math.sin(CurTime() * .5) * 255

    surface.DrawCircle(radarcenter.x, radarcenter.y, math.abs(math.sin(CurTime()) * 50) * radarsize_, Color(109, 109, 109, t))

    surface.DrawCircle(radarcenter.x - scrw * .001, radarcenter.y - scrh * .001, scrh * .111 * radarsize_, THEME.grey)
    surface.DrawCircle(radarcenter.x - scrw * .001, radarcenter.y - scrh * .001, scrh * .11 * radarsize_, THEME.grey)

    surface.SetDrawColor(color_white)
    SummeLibrary:DrawImgur(radarcenter.x - radarsize.w * .075, radarcenter.y - radarsize.h * .075, radarsize.w * .15 * radarsize_, radarsize.h * .15 * radarsize_, "8Zq6L6Z")

    local lpPos = LocalPlayer():GetPos()

    if _checkTime <= CurTime() then
        entCache = {}
        for k, ent in pairs(ents.FindInSphere(lpPos, radarRange)) do
            table.insert(entCache, ent)
        end
        _checkTime = CurTime() + 1
    end

    for k, ent in pairs(entCache) do
        if not IsValid(ent) then continue end
        local data = StarWarsHUD.Config.CheckEntity(ent)
        if not data then continue end

        local entPos = ent:GetPos()

        local dx = entPos.x - lpPos.x
		local dy = entPos.y - lpPos.y
		local dz = entPos.z - lpPos.z

        local dist = ( lpPos - Vector( 0, 0, lpPos.z ) ):Distance( entPos - Vector( 0, 0, entPos.z ) )

        local ang = math.atan2( dx, dy )				
		local fixedAng = ang + math.rad( LocalPlayer():EyeAngles().y ) + math.rad( 180 )

        local drawScale = ScrH()/10
        local radarBlipSize = drawScale/13

		local blipX = radarcenter.x + math.cos( fixedAng ) * ( dist/1500 * radarRange * .05) -- .05 controls size
		local blipY = radarcenter.y + math.sin( fixedAng ) * ( dist/1500 * radarRange * .05)

        surface.SetDrawColor(data.color)
        SummeLibrary:DrawImgurRotated(blipX, blipY, radarsize.w * .1 * radarsize_, radarsize.h * .1 * radarsize_, ent:GetAngles().y - 90, data.material or "8Zq6L6Z")
    end

    render.SetStencilEnable(false)
end)
