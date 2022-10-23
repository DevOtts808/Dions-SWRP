-- Utility functions for clientside stuff (mostly Derma)
aura_quest_color_red = Color(255,0,0,255)
aura_quest_color_blue = Color(0,0,255,255)
aura_quest_color_blue_2 = Color(0,0,175,255)
aura_quest_color_blue_3 = Color(0,0,200,100)
aura_quest_color_yellow = Color(255,255,0,255)
aura_quest_color_dark_gray = Color(0,0,0,100)
aura_quest_color_gray = Color(0,0,0,150)
aura_quest_color_gray2 = Color(50,50,50,250)
aura_quest_color_light_gray = Color(0,0,0,200)
aura_quest_color_off_blue = Color(0,150,200,50)
aura_quest_color_off_blue2 = Color(0, 37, 60, 220)
aura_quest_color_off_blue3 = Color(0,120,74,255)
aura_quest_color_off_blue4 = Color(20,0,50,50)
aura_quest_color_off_blue5 = Color(0, 74, 120, 255)
aura_quest_color_off_blue6 = Color(0,60,74,255)
aura_quest_color_off_blue7 = Color(0,0,60,100)
aura_quest_color_light_white = Color(255,255,255,100)
aura_quest_color_off_white = Color(100,100,100,200)
aura_quest_color_off_red = Color(120, 74, 74, 255)
aura_quest_color_dark_green = Color(0, 150, 0, 150)
aura_quest_color_dark_green2 = Color(0, 125, 0, 150)
aura_quest_color_dark_green3 = Color(0,150,0,50)
aura_quest_color_off_green = Color(0, 255, 0, 220)
aura_quest_color_dark_cyan = Color(0, 255, 255, 50)
aura_quest_color_dark_purple = Color(255,0,255 ,50)
aura_quest_color_off_purple = Color(120, 0, 74, 255)



function Aura_TypeToFillTextBox(panel, text, time, func)
	if (timer.Exists(LocalPlayer():SteamID64() .. "TitleFiller")) then
		timer.Stop(LocalPlayer():SteamID64() .. "TitleFiller")
	end
    if (istable(text)) then
        text = table.Random(text)
    end
	local reps = string.len(text)
	local del = time/reps

	local count = 0
	timer.Create(LocalPlayer():SteamID64() .. "TitleFiller",del,reps, function()
		if (IsValid(panel)) then
			count = count + 1
			panel:SetText(panel:GetText() .. string.sub(text,count,count))
			panel:SizeToContentsY()
		end
	end)

	timer.Simple(time, function()
		if (IsValid(panel)) then
			func()
		end
	end)
end

function Aura_Quest_drawCircle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function Aura_OpenQuestConfigMenu()
	local settingsMenu = vgui.Create("QuestPlayerPreferenceMenu")
end

local contextIcon = file.Exists( "materials/aura_quest_context_menu_icon.png" , "GAME" ) and "aura_quest_context_menu_icon.png" or "icon64/tool.png"

list.Set( "DesktopWindows", "AuraQuestConfigMenu", {
	title = "AuraQuest Settings",
	icon = contextIcon,
	init = function( icon, window )
		Aura_OpenQuestConfigMenu()
	end
} )