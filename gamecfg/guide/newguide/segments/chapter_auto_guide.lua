return {
	id = "CHAPTER_AUTO_GUIDE",
	events = {
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "With Operational Handover, you can have your allies automatically clear stages to gain Proficiency!",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {}
			}
		},
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "Use Handover Permits, obtainable from daily missions and other sources, to receive the same rewards you would get from a manual sortie!",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {}
			}
		},
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "Once you've cleared a stage on Auto-Repeat, it will be unlocked for Operational Handover!",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {}
			},
			ui = {
				pathIndex = -1,
				dynamicPath = function()
					local var0_1 = "OverlayCamera/Overlay/UIMain/LevelStageInfoView(Clone)"

					if not IsNil(GameObject.Find(var0_1)) then
						return "OverlayCamera/Overlay/UIMain/LevelStageInfoView(Clone)/panel/auto_button"
					end

					return "OverlayCamera/Overlay/UIMain/LevelInfoSPUI(Clone)/panel/auto_button"
				end
			}
		}
	}
}
