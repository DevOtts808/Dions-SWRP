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

BF2_Scoreboard.Languages = {}

function BF2_Scoreboard:L(key)
    return BF2_Scoreboard.Languages[BF2_Scoreboard.Config.Language][key] or "ERROR"
end

BF2_Scoreboard.Languages["en"] = {
    PLAYER = "PLAYER",
    RANK = "RANK",
    USERGROUP = "USERGROUP",
    KILLS = "KILLS",
    DEATHS = "DEATHS",
    PING = "PING",
    MY_STATS = "MY STATS",
}

BF2_Scoreboard.Languages["de"] = {
    PLAYER = "SPIELER",
    RANK = "RANG",
    USERGROUP = "BENUTZERGRUPPE",
    KILLS = "KILLS",
    DEATHS = "TODE",
    PING = "PING",
    MY_STATS = "MEINE STATS",
}

BF2_Scoreboard.Languages["fr"] = {
    PLAYER = "JOUEUR",
    RANK = "RANK",
    USERGROUP = "GROUPE D'UTILISATEURS",
    KILLS = "KILLS",
    DEATHS = "DEATHS",
    PING = "PING",
    MY_STATS = "MES STATISTIQUES",
}

BF2_Scoreboard.Languages["ru"] = {
    PLAYER = "ИГРОК",
    RANK = "РАНГ",
    USERGROUP = "ГРУППА ПОЛЬЗОВАТЕЛЕЙ",
    KILLS = "УБИВАЕТ",
    DEATHS = "СМЕРТЬ",
    PING = "ПИНГ",
    MY_STATS = "МОЯ СТАТИСТИКА",
}