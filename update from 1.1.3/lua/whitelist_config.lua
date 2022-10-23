/**
* General configuration
**/

-- Usergroups allowed to administrate the whitelist.
-- They are automatically whitelisted for all jobs if the AdminsBypass option is set to true.
SH_WHITELIST.Usergroups = {
	["owner"] = true,
	["manager"] = true,
	["superadmin"] = true,
	["admin"] = true,
}

-- Jobs that can whitelist a defined list of jobs.
-- Example: Let's say you have a 7th Company Leader job.
-- 			The 7th Company Leader would be able to whitelist players for the 7th Company's jobs.
--			So if your current job is 7th Company Leader, you would be able to open the Whitelist menu
--			and whitelist players for these jobs only.
SH_WHITELIST.WhitelistingJobs = {
	["7th Company Leader"] = {
		"7th Company Engineer",
		"7th Company Medic",
		"7th Company Rifleman",
		"7th Company Radio",
	},
	["1st Regiment Leader"] = {
		"1st Regiment Engineer",
		"1st Regiment Medic",
		"1st Regiment Rifleman",
		"1st Regiment Radio",
	},
}

-- Like above, but with usergroups.
-- If you want specific usergroups to be able to whitelist some jobs at any time,
-- this is the option you want to edit.
SH_WHITELIST.WhitelistingUsergroups = {
	["vip_gold"] = {
		"7th Company Engineer",
		"7th Company Medic",
		"7th Company Rifleman",
		"7th Company Radio",
	},
}

-- If the player is whitelisted to one of the jobs below,
-- they will get automatically assigned to the FIRST job found when connecting.
-- Empty the table to not use this feature.
SH_WHITELIST.AutoAssignJobs = {
	"1st Regiment Leader", -- If the player is whitelisted to this job, they will spawn with it. If not, c
	"1st Regiment Corporal",
	"1st Regiment Rifleman",
}

-- Can non-admins whitelist offline players or usergroups?
SH_WHITELIST.NonAdminsCanWhitelistAll = false

-- Can non-admins whitelist usergroups?
SH_WHITELIST.NonAdminsCanWhitelistUsergroups = false

-- Should admin usergroups (defined above) be automatically whitelisted for all jobs?
SH_WHITELIST.AdminsBypass = true

-- Should players be notified when they are (un)whitelisted for a job?
SH_WHITELIST.NotifyWhitelist = true

-- Should players be booted from their job if they are unwhitelisted from it?
-- They will be switched to GAMEMODE.DefaultTeam, which can be configured in the jobs file.
SH_WHITELIST.UnwhitelistBoot = true

-- Should whitelist changes be logged and printed using ServerLog?
SH_WHITELIST.UseServerLog = true

-- Use libgmodstore?
-- This library is intended to help provide information about updates and support should you run into issues.
-- DISCLAIMER: libgmodstore is NOT maintained by me (Shendow), I am NOT responsible if it causes errors or other issues.
--			   If it does, then disable the option below. You don't need it for the script to work - it only makes life easier.
-- More information here: https://www.gmodstore.com/community/threads/4465-libgmodstore/post-31807#post-3180776561198183613561
SH_WHITELIST.UseLibGModStore = false

-- Use Steam Workshop for the custom content?
-- If false, custom content will be downloaded through FastDL.
SH_WHITELIST.UseWorkshop = true

/**
* Jobs to whitelist configuration
**/

-- Job identifiers that require players to be whitelisted in order to become that job.
-- In other words, if your job is in the list below, then players can't join it unless they're whitelisted.
-- If it isn't in the list, anyone can join it.
-- Available identifiers:
-- NAMES. Example: Civil Protection	-> This will restrict the job called "Civil Protection"
-- COLORS. Example: 255 0 0			-> This will restrict jobs with the 255,0,0 color
-- CATEGORY. Example: Citizens		-> This will restrict jobs with the "Citizens" category
SH_WHITELIST.WhitelistedJobs = {
	["Civil Protection"] = true,
	["Mayor"] = true,
	["Mob boss"] = true,
}

-- Should jobs requiring a vote also require to be whitelisted?
SH_WHITELIST.WhitelistVotes = true

/**
* Command configuration
**/

-- Chat commands which can open the Whitelist menu
-- ! are automatically replaced by / and inputs are made lowercase for convenience.
SH_WHITELIST.MenuCommands = {
	["/wl"] = true,
	["/whitelist"] = true,
	["/whitelists"] = true,
}

/**
* Advanced configuration
* Edit at your own risk!
**/

SH_WHITELIST.ImageDownloadFolder = "sh_whitelist"

/**
* Theme configuration
**/

-- Width multiplier of the Whitelist window.
SH_WHITELIST.WidthMultiplier = 1.1

-- Height multiplier of the Whitelist window.
SH_WHITELIST.HeightMultiplier = 1.1

-- Font to use for normal text throughout the interface.
SH_WHITELIST.Font = "Circular Std Medium"

-- Font to use for bold text throughout the interface.
SH_WHITELIST.FontBold = "Circular Std Bold"

-- Color sheet. Only modify if you know what you're doing.
SH_WHITELIST.Style = {
	header = Color(52, 152, 219, 255),
	bg = Color(52, 73, 94, 255),
	inbg = Color(44, 62, 80, 255),

	close_hover = Color(231, 76, 60, 255),
	hover = Color(255, 255, 255, 10, 255),
	hover2 = Color(255, 255, 255, 5, 255),

	text = Color(255, 255, 255, 255),
	text_down = Color(0, 0, 0),
	textentry = Color(44, 62, 80),
	menu = Color(127, 140, 141),

	success = Color(46, 204, 113),
	failure = Color(231, 76, 60),
}

/**
* Language configuration
**/

-- Various strings used throughout the script.
-- Available languages: english, french, german, spanish
-- To add your own language, see the reports/language folder
-- You may need to restart the map after changing the language!
SH_WHITELIST.LanguageName = "english"