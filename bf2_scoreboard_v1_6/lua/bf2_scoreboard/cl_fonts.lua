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

surface.CreateFont( "BF2Scoreboard.Title", {
	font = "Roboto",
	extended = false,
	size = ScrH() * .07,
	weight = 1000,
})

surface.CreateFont( "BF2Scoreboard.SubTitle", {
	font = "Roboto",
	extended = false,
	size = ScrH() * .02,
	weight = 500,
})

surface.CreateFont( "BF2Scoreboard.StatsTitle", {
	font = "Roboto",
	extended = false,
	size = ScrH() * .05,
	weight = 1000,
})

surface.CreateFont( "BF2Scoreboard.PlayerRow", {
	font = "Roboto",
	extended = false,
	size = ScrH() * .022,
	weight = 500,
})

surface.CreateFont( "BF2Scoreboard.Actions", {
	font = "Roboto",
	extended = false,
	size = ScrH() * .015,
	weight = 500,
})


surface.CreateFont( "BF2Scoreboard.PlayerMax", {
	font = "Roboto",
	extended = false,
	size = ScrH() * .015,
	weight = 500,
	italic = false,
})