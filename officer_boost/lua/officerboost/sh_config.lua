OfficerBoost.Config = {}

OfficerBoost.Config["Normal"] = {}
OfficerBoost.Config["Normal"].Color = Color(255,196,1) -- Ring and HUD color
OfficerBoost.Config["Normal"].SpeedBoost = 1.4 -- The speed boost: current speed * boost
OfficerBoost.Config["Normal"].JumpBoost = 1.4 -- The jump boost: current jump boost * boost
OfficerBoost.Config["Normal"].AdditionalHealth = 150 -- The additional health: current health + health
OfficerBoost.Config["Normal"].RPMBoost = 1.5  -- The TFA RPM Boost: current rpm * boost
OfficerBoost.Config["Normal"].Radius = 256 -- The radius of the sphere
OfficerBoost.Config["Normal"].Duration = 25 -- The duration of the effect
OfficerBoost.Config["Normal"].Sounds = {"summe/officer_boost/baseboost1.mp3", "summe/officer_boost/baseboost2.mp3", "summe/officer_boost/baseboost3.mp3", "summe/officer_boost/will1.mp3", "summe/officer_boost/will2.mp3", "summe/officer_boost/will3.mp3"}
OfficerBoost.Config["Normal"].GiveBack = 240 -- The cool down when you get the swep back -- false to disable

OfficerBoost.Config["LastStand"] = {}
OfficerBoost.Config["LastStand"].Color = Color(132,1,255)
OfficerBoost.Config["LastStand"].SpeedBoost = 0.4
OfficerBoost.Config["LastStand"].JumpBoost = 0.3
OfficerBoost.Config["LastStand"].AdditionalHealth = 200
OfficerBoost.Config["LastStand"].AdditionalArmor = 100
OfficerBoost.Config["LastStand"].Radius = 256
OfficerBoost.Config["LastStand"].Duration = 25
OfficerBoost.Config["LastStand"].Sounds = {"summe/officer_boost/laststand1.mp3", "summe/officer_boost/laststand2.mp3", "summe/officer_boost/laststand3.mp3"}
OfficerBoost.Config["LastStand"].GiveBack = 240