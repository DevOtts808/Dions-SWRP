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

BF2_Scoreboard.Config = {}

BF2_Scoreboard.Config.Theme = {
    white = color_white,
    grey = Color(173,173,173),
    primary = Color(255,196,0)
}

-- Configuration of the display of the usergroups
BF2_Scoreboard.Config.Usergroups = {
    ["superadmin"] = {
        name = "Server Manager",
        color = Color(255,109,109)
    },
    ["Gamemaster"] = {
        name = "Event Manager",
        color = Color(250,109,255)
    },
    ["admin"] = {
        name = "Admin",
        color = Color(250,109,255)
    },
    ["moderator"] = {
        name = "Moderator",
        color = Color(109,245,255)
    },
    ["builder"] = {
        name = "Builder",
        color = Color(109,245,255)
    },
    ["event staff"] = {
        name = "Event Staff",
        color = Color(109,245,255)
    },
    ["user"] = {
        name = "User",
        color = Color(194,194,194)
    },
}

-- The titles on top of the scoreboard
BF2_Scoreboard.Config.Texts = {
    title = "You are playing on",
    subtitle = "Dion's SWRP",
}

-- Language selection
-- en / de / fr / ru
BF2_Scoreboard.Config.Language = "en"

-- Action buttons (SAM, ULX etc.)
-- Only touch if you have experience!
BF2_Scoreboard.Config.Actions = {
    ["goto"] = {
        name = "Goto",
        icon = Material("summe/bf2_scoreboard/goto.png", "smooth"),
        func = function(ply)
            if ULib then
                RunConsoleCommand("ulx", "goto", ply:Name())
            elseif serverguard then
                serverguard.command.Run("goto", "false", ply:Name())
            elseif sam then
                RunConsoleCommand("sam", "goto", ply:Name())
            end
        end
    },
    ["return"] = {
        name = "Return",
        icon = Material("summe/bf2_scoreboard/return.png", "smooth"),
        func = function(ply)
            if ULib then
                RunConsoleCommand("ulx", "return", ply:Name())
            elseif serverguard then
                serverguard.command.Run("return", "false", ply:Name())
            elseif sam then
                RunConsoleCommand("sam", "return", ply:Name())
            end
        end
    },
    ["bring"] = {
        name = "Bring",
        icon = Material("summe/bf2_scoreboard/bring.png", "smooth"),
        func = function(ply)
            if ULib then
                RunConsoleCommand("ulx", "bring", ply:Name())
            elseif serverguard then
                serverguard.command.Run("bring", "false", ply:Name())
            elseif sam then
                RunConsoleCommand("sam", "bring", ply:Name())
            end
        end
    },
    ["freeze"] = {
        name = "Freeze",
        icon = Material("summe/bf2_scoreboard/freeze.png", "smooth"),
        func = function(ply)
            if ply:IsFlagSet(FL_FROZEN) then
                if ULib then
                    RunConsoleCommand("ulx", "unfreeze", ply:Name())
                elseif serverguard then
                    serverguard.command.Run("unfreeze", "false", ply:Name())
                elseif sam then
                    RunConsoleCommand("sam", "unfreeze", ply:Name())
                end
            else
                if ULib then
                    RunConsoleCommand("ulx", "freeze", ply:Name())
                elseif serverguard then
                    serverguard.command.Run("freeze", "false", ply:Name())
                elseif sam then
                    RunConsoleCommand("sam", "freeze", ply:Name())
                end
            end
        end
    },
    ["kick"] = {
        name = "Kick",
        icon = Material("summe/bf2_scoreboard/disconnect.png", "smooth"),
        func = function(ply)
            if ULib then
                RunConsoleCommand("ulx", "kick", ply:Name())
            elseif serverguard then
                serverguard.command.Run("kick", "false", ply:Name())
            elseif sam then
                RunConsoleCommand("sam", "kick", ply:Name())
            end
        end
    },
    ["steamid"] = {
        name = "SteamID",
        icon = Material("summe/bf2_scoreboard/copy.png"),
        func = function(ply)
            SetClipboardText(ply:SteamID64() or "BOT")
        end
    },
    
}