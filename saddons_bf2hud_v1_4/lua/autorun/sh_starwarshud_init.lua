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

StarWarsHUD = {}

timer.Simple(0, function()
    SummeLibrary:Register({
        class = "starwarshud",
        name = "StarWarsHUD",
        color = Color(0,217,255),
        version = "1.4",
    })
end)

hook.Add("StarWarsHUD.Registered", "34343", function()
    local rootDir = "starwarshud"

    local function AddFile(File, dir)

        local fileSide = string.lower(string.Left(File , 3))

        if SERVER and fileSide == "sv_" then
            include(dir..File)
            SummeLibrary:Print("starwarshud", "> "..dir..File)
        elseif fileSide == "sh_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            end
            include(dir..File)
            SummeLibrary:Print("starwarshud", "> "..dir..File)
        elseif fileSide == "cl_" then
            if SERVER then 
                AddCSLuaFile(dir..File)
            elseif CLIENT then
                include(dir..File)
                SummeLibrary:Print("starwarshud", "> "..dir..File)
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

        hook.Run("StarWarsHUD.Loaded")

    end

    IncludeDir(rootDir)
end)