-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- weapon_cuff_elastic.lua  SHARED --
--                                 --
-- Elastic handcuffs.              --
-------------------------------------

AddCSLuaFile()

SWEP.Base = "weapon_cuff_base"

SWEP.Category = "Handcuffs"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = "Stretchable restraint."

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.AdminSpawnable = true

SWEP.Slot = 3
SWEP.PrintName = "Elastic Restraint"

//
// Handcuff Vars
SWEP.CuffTime = 0.3 // Seconds to handcuff
SWEP.CuffSound = Sound( "buttons/lever7.wav" )

SWEP.CuffMaterial = "models/props_pipes/GutterMetal01a"
SWEP.CuffRope = "cable/red"
SWEP.CuffStrength = 1.6
SWEP.CuffRegen = 1
SWEP.RopeLength = 150
SWEP.CuffReusable = true
SWEP.CuffRecharge = 10

SWEP.CuffBlindfold = true
SWEP.CuffGag = true

SWEP.CuffStrengthVariance = 0 // Randomise strength
SWEP.CuffRegenVariance = 0 // Randomise regen