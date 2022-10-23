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

resource.AddWorkshop("2519414680")

hook.Add("OnNPCKilled", "BF2_Scoreboard.NPCKills", function(npc, attacker, inflictor)
    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    attacker:SetNWInt("BF2SB_TotalKills", attacker:GetNWInt("BF2SB_TotalKills", 0) + 1)
end)

hook.Add("PlayerDeath", "BF2_Scoreboard.PlayerKills", function(ply, inflictor, attacker)
    if not IsValid(attacker) or not attacker:IsPlayer() then return end

    if ply == attacker then return end

    attacker:SetNWInt("BF2SB_TotalKills", attacker:GetNWInt("BF2SB_TotalKills", 0) + 1)
end)