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

hook.Add("HUDDrawTargetID", "StarWarsHUD.DisableTargetID", function()
	return false
end)


hook.Add("Initialize", "Adad", function()
    function SummeLibrary:DrawImgurRotated(x, y, w, h, angle, id)
        if not SummeLibrary.ImgurMaterials[id] then
            SummeLibrary:GetImgurMaterial(id, function(mat)
                SummeLibrary.ImgurMaterials[id] = mat
            end)
    
            return
        end
    
        surface.SetMaterial(SummeLibrary.ImgurMaterials[id])
        surface.DrawTexturedRectRotated(x, y, w, h, angle)
    end
end)

local hide = {
    ["DarkRP_HUD"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
}

hook.Add("HUDShouldDraw", "StarWarsHUD.HideDefaultHUD", function(name)
    if (hide[name]) then
        return false
    end
end)

function draw.CircleCustom(x, y, w, h, ang, color, x0, y0)
    for i=0,ang do
        local c = math.cos(math.rad(i))
        local s = math.sin(math.rad(i))
        local newx = y0 * s - x0 * c
        local newy = y0 * c + x0 * s

        draw.NoTexture()
        surface.SetDrawColor(color)
        surface.DrawTexturedRectRotated(x + newx,y + newy,w,h, i)
    end
end

function StarWarsHUD:IsElementEnabled(id)
    if not StarWarsHUD.Config.Modules[id] then return false end
    return StarWarsHUD.Config.Modules[id].enabled
end