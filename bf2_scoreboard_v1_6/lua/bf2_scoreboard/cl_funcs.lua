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

function BF2_Scoreboard:GetUsergroup(ply)
    local usrgrp = ply:GetUserGroup()

    if BF2_Scoreboard.Config.Usergroups[usrgrp] then
        return BF2_Scoreboard.Config.Usergroups[usrgrp].name, BF2_Scoreboard.Config.Usergroups[usrgrp].color
    else
        return BF2_Scoreboard.Config.Usergroups["user"].name, BF2_Scoreboard.Config.Usergroups["user"].color
    end
end

function BF2_Scoreboard:ShortenString(string, maxChars)
    if #string > maxChars then
        local t = ""

        for _, char in pairs(string.Split(string, "")) do
            if #t < maxChars then
                t = t..char
            end
        end

        return t.."..."

    else
        return string
    end
end

function BF2_Scoreboard:GetRank(ply)
    if not ply or not IsValid(ply) then return "nil", Color(255,255,255) end

    if DarkRP then
        local job = ply:getDarkRPVar("job")
        local rpTeam = RPExtraTeams[ply:Team()]

        if not rpTeam or not rpTeam.color then
            return "N/A", Color(255,255,255)
        end

        return job or "N/A", rpTeam.color or Color(255,255,255)
    else
        return "N/A", Color(255,255,255)
    end
end

function BF2_Scoreboard:GetPlayers()
    local t = {}

    for k, ply in pairs(player.GetAll()) do
        t[ply] = {
            name = ply:Nick(),
            team = ply:Team(),
            group = ply:GetUserGroup(),
            kills = ply:Frags(),
            deaths = ply:Deaths(),
            ping = ply:Ping(),
        }
    end

    return t
end