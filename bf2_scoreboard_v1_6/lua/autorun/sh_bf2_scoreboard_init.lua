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

BF2_Scoreboard = {}

timer.Simple(0, function()
    SummeLibrary:Register({
        class = "bf2_scoreboard",
        name = "Battlefront II Scoreboard",
        color = Color(251,255,0),
        version = "1.6",
    })
end)

hook.Add("Battlefront II Scoreboard.Registered", "34343", function()
    local rootDir = "bf2_scoreboard"

    local function AddFile(File, dir)
        local fileSide = string.lower(string.Left(File , 3))

        if SERVER and fileSide == "sv_" then
            include(dir..File)
            SummeLibrary:Print("bf2_scoreboard", "> "..dir..File)
        elseif fileSide == "sh_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            end
            include(dir..File)
            SummeLibrary:Print("bf2_scoreboard", "> "..dir..File)
        elseif fileSide == "cl_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            elseif CLIENT then
                include(dir..File)
                SummeLibrary:Print("bf2_scoreboard", "> "..dir..File)
            end
        end
    end

    local function IncludeDir(dir)
        dir = dir .. "/"
        local File, Directory = file.Find(dir.."*", "LUA")

        for k, v in ipairs(File) do
            if string.EndsWith(v, ".lua") then
                AddFile(v, dir)
            end
        end
        
        for k, v in ipairs(Directory) do
            IncludeDir(dir..v)
        end

        hook.Run("Battlefront II Scoreboard.Loaded")

    end
    IncludeDir(rootDir)
end)