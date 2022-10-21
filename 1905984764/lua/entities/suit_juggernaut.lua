AddCSLuaFile()

ENT.Base 			= "base_suit"

ENT.PrintName 		= "Juggernaut suit"
ENT.Category 		= "Suits"
ENT.Author 			= "TankNut"

ENT.Spawnable 		= true
ENT.AdminSpawnable	= true

ENT.SuitData = {
	Model = Model("models/moxfort/501st-juggernaut.mdl"),

	Hands = {
		Model = Model("models/aussiwozzi/cgi/base/501st_trooper_arms.mdl")
	},
		
	FootstepPitch = {95, 105},
	FootstepVolume = 0.75,
	Footsteps = {{
		"npc/footsteps/hardboot_generic1.wav",
		"npc/footsteps/hardboot_generic2.wav",
		"npc/footsteps/hardboot_generic3.wav"
	}, {
		"npc/footsteps/hardboot_generic4.wav",
		"npc/footsteps/hardboot_generic5.wav",
		"npc/footsteps/hardboot_generic6.wav"
	}}
}

local speed = GetConVar("suit_juggernaut_speed")
local damage = GetConVar("suit_juggernaut_damage")

function ENT:ScaleDamage(ply, dmg)
	local mult = damage:GetFloat()

	if mult == 0 then
		return true
	end

	dmg:ScaleDamage(mult)
end

if SERVER then
	function ENT:GetSpeedMod(ply)
		return speed:GetFloat()
	end
end