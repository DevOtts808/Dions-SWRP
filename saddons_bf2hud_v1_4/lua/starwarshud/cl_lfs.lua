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

local throttleColor = THEME.lfsThrottleLimitColor

local font1 = SummeLibrary:CreateFont("StarWarsHUD.Vel", ScrH() * .0275, 300, false)
local font1_1 = SummeLibrary:CreateFont("StarWarsHUD.Vel2", ScrH() * .0275, 800, false)
local font2 = SummeLibrary:CreateFont("StarWarsHUD.VelDetails", ScrH() * .013, 300, false)
local font3 = SummeLibrary:CreateFont("StarWarsHUD.LFSDetails", ScrH() * .013, 300, false)

hook.Add("HUDPaint", "StarWarsHUD.LFS", function()
    if not StarWarsHUD:IsElementEnabled("lfs") then return end

    local ply = LocalPlayer()
    local lfsEnt = ply:lfsGetPlane()

    if not IsValid(lfsEnt) then return end

    local scrw, scrh = ScrW(), ScrH()

    local hudStartPos = {
        x = scrw * .86,
        y = scrh * .17,
    }

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

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .13, scrh * .35, THEME.blurBackgroundColor)

    render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

    draw.DrawBlur(0, 0, scrw, scrh, 4, 3, 255)

    render.SetStencilEnable(false)

    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y, scrw * .13, scrh * .0025, THEME.grey)
    draw.RoundedBox(0, hudStartPos.x, hudStartPos.y + scrh * .35, scrw * .13, scrh * .0025, THEME.grey)

    local throttle = lfsEnt:GetThrottlePercent()
    local vel = lfsEnt:GetVelocity():Length()
    local speed = math.Round(vel * 0.09144,0)
    local alt = math.Round( (lfsEnt:GetPos().z + simfphys.LFS.AltitudeMinZ) * 0.0254,0)

    local _font = font1

    if throttle >= 100 then
        throttleColor = THEME.lfsThrottleLimitColor
        _font = font1_1
    end

    if throttleColor != THEME.lfsThrottleColor then
        throttleColor = SummeLibrary:LerpColor(FrameTime() * 2, throttleColor, THEME.lfsThrottleColor)
    end

    draw.CircleCustom(hudStartPos.x + scrw * .065, hudStartPos.y + scrh * .08, scrh * .01, scrh * .01, 360, THEME.greyBackground, -50, 0)
    draw.CircleCustom(hudStartPos.x + scrw * .065, hudStartPos.y + scrh * .08, scrh * .01, scrh * .01, throttle * 3.6, throttleColor, -50, 0)

    draw.DrawText(speed, _font, hudStartPos.x + scrw * .065, hudStartPos.y + scrh * .06, THEME.whiteText, TEXT_ALIGN_CENTER)
    draw.DrawText("km/h", font2, hudStartPos.x + scrw * .065, hudStartPos.y + scrh * .085, THEME.whiteText, TEXT_ALIGN_CENTER)

    draw.DrawText("CLASS", font3, hudStartPos.x + scrw * .013, hudStartPos.y + scrh * .15, THEME.whiteText, TEXT_ALIGN_LEFT)
    draw.DrawText(lfsEnt.PrintName, font3, hudStartPos.x + scrw * .115, hudStartPos.y + scrh * .15, THEME.whiteText, TEXT_ALIGN_RIGHT)
    draw.DrawText("STATUS", font3, hudStartPos.x + scrw * .013, hudStartPos.y + scrh * .165, THEME.whiteText, TEXT_ALIGN_LEFT)
    draw.DrawText("OK", font3, hudStartPos.x + scrw * .115, hudStartPos.y + scrh * .165, THEME.whiteText, TEXT_ALIGN_RIGHT)
    draw.DrawText("ALT", font3, hudStartPos.x + scrw * .013, hudStartPos.y + scrh * .18, THEME.whiteText, TEXT_ALIGN_LEFT)
    draw.DrawText(alt.."m", font3, hudStartPos.x + scrw * .115, hudStartPos.y + scrh * .18, THEME.whiteText, TEXT_ALIGN_RIGHT)
    draw.DrawText("THROTTLE", font3, hudStartPos.x + scrw * .013, hudStartPos.y + scrh * .195, THEME.whiteText, TEXT_ALIGN_LEFT)
    draw.DrawText(throttle.."%", font3, hudStartPos.x + scrw * .115, hudStartPos.y + scrh * .195, THEME.whiteText, TEXT_ALIGN_RIGHT)

    local colorBg = ColorAlpha(THEME.greyBackground, 100)

    draw.RoundedBox(3, hudStartPos.x + scrw * .012, hudStartPos.y + scrh * .23, (scrw * .105) * 1, scrh * .029, colorBg)

    local hp, maxHp = lfsEnt:GetHP(), lfsEnt:GetMaxHP()
    local quotient = math.Clamp(hp/maxHp, 0, 1)

    draw.RoundedBox(3, hudStartPos.x + scrw * .012, hudStartPos.y + scrh * .23, (scrw * .105) * quotient, scrh * .029, THEME.whiteText)

    local sp, maxSp = lfsEnt:GetShield(), lfsEnt:GetMaxShield()
    if sp > 0 then
        local quotient = math.Clamp(sp/maxSp, 0, 1)

        draw.RoundedBox(4, hudStartPos.x + scrw * .012, hudStartPos.y + scrh * .255, (scrw * .105) * quotient, scrh * .0057, THEME.apBar)
    end


    local sp, maxSp = lfsEnt:GetAmmoPrimary(), lfsEnt:GetMaxAmmoPrimary()
    local quotient = math.Clamp(sp/maxSp, 0, 1)

    draw.RoundedBox(4, hudStartPos.x + scrw * .028, hudStartPos.y + scrh * .285, (scrw * .07) * 1, scrh * .0057, colorBg)
    draw.RoundedBox(4, hudStartPos.x + scrw * .028, hudStartPos.y + scrh * .285, (scrw * .07) * quotient, scrh * .0057, THEME.whiteText)
    SummeLibrary:DrawImgur(hudStartPos.x + scrw * .012, hudStartPos.y + scrh * .279, scrh * .02, scrh * .02, "CuYeSH9")
    draw.DrawText(sp, font3, hudStartPos.x + scrw * .1, hudStartPos.y + scrh * .279, THEME.whiteText, TEXT_ALIGN_LEFT)

    local sp, maxSp = lfsEnt:GetAmmoSecondary(), lfsEnt:GetMaxAmmoSecondary()
    local quotient = math.Clamp(sp/maxSp, 0, 1)

    draw.RoundedBox(4, hudStartPos.x + scrw * .028, hudStartPos.y + scrh * .315, (scrw * .07) * 1, scrh * .0057, colorBg)
    draw.RoundedBox(4, hudStartPos.x + scrw * .028, hudStartPos.y + scrh * .315, (scrw * .07) * quotient, scrh * .0057, THEME.whiteText)
    SummeLibrary:DrawImgur(hudStartPos.x + scrw * .012, hudStartPos.y + scrh * .309, scrh * .02, scrh * .02, "v7v8Qq4")
    draw.DrawText(sp, font3, hudStartPos.x + scrw * .1, hudStartPos.y + scrh * .309, THEME.whiteText, TEXT_ALIGN_LEFT)

    --draw_circle(hudStartPos.x, hudStartPos.y + scrh * .2, scrh * 0.1, THEME.whiteText, .9)
end)