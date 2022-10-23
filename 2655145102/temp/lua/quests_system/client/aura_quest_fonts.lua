-- Clientside functions
aura_scaleX = (ScrW() / 2560)
aura_scaleY = (ScrH() / 1440)

surface.CreateFont("QuestFontMain", {
	font = "SF Distant Galaxy",
	extended = false,
	size = 60 * aura_scaleY,
	weight = 1000,
})

surface.CreateFont("QuestFontQuestTitles", {
	font = "Exo 2",
	extended = false,
	size = 50 * aura_scaleY,
	weight = 1000,
})

surface.CreateFont("QuestFontQuestTitlesHUD", {
	font = "Exo 2",
	extended = false,
	size = 50,
	weight = 1000,
})

surface.CreateFont("QuestFontQuestMedium", {
	font = "Exo 2",
	extended = false,
	size = 40 * aura_scaleY,
	weight = 1000,
})

surface.CreateFont("QuestFontQuestSmall", {
	font = "Exo 2",
	extended = false,
	size = 30 * aura_scaleY,
	weight = 1000,
})

surface.CreateFont("QuestFontQuestTiny", {
	font = "Exo 2",
	extended = false,
	size = 25 * aura_scaleY,
	weight = 650,
})

surface.CreateFont("QuestFontQuestDescriptionBody", {
	font = "Arial",
	extended = false,
	size = 30 * aura_scaleY,
	weight = 1450,
})

surface.CreateFont("QuestFontQuestDescriptionMedium", {
	font = "Exo 2",
	extended = false,
	size = 35 * aura_scaleY,
	weight = 650,
})

surface.CreateFont("QuestFontQuestDescriptionTitle", {
	font = "Exo 2",
	extended = false,
	size = 45 * aura_scaleY,
	weight = 650,
})

surface.CreateFont("QuestFontQuestStoryEdit", {
	font = "Arial",
	extended = false,
	size = 23 * aura_scaleY,
	weight = 650,
})

surface.CreateFont("QuestFontQuestStoryEditSmall", {
	font = "Arial",
	extended = false,
	size = 18 * aura_scaleY,
	weight = 650,
})