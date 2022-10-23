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

util.AddNetworkString("StarWarsHUD.DamageReceived")

hook.Add("EntityTakeDamage", "StarWarsHUD.Listener", function(target, info)
	if target:IsPlayer() then
		net.Start("StarWarsHUD.DamageReceived")
		net.WriteUInt(info:GetDamage(), 16)
        --net.WriteUInt(info:GetDamageType(), 16)
		net.Send(target)
	end
end)

resource.AddFile("2811413920")