return {
	id = "CHAPTER_AUTO_WORLD_GUIDE",
	events = {
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "You are now able to conduct Operational Handover.",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {
					{
						lineMode = 2,
						path = "OverlayCamera/Overlay/UIMain/top/adapt/right_chapter/line/display_panel/btns/delegate_btn",
						pathIndex = -1
					}
				}
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/top/adapt/right_chapter/line/display_panel/btns/delegate_btn",
				pathIndex = -1
			}
		},
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "You can set conditions to automatically progress through explorable sectors.",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {
					{
						lineMode = 2,
						path = "OverlayCamera/Overlay/UIMain/ChapterAutoPanelTypeWorld(Clone)/top/btnBack",
						pathIndex = -1
					}
				}
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/ChapterAutoPanelTypeWorld(Clone)/top/btnBack",
				pathIndex = -1
			}
		},
		{
			is3dDorm = false,
			alpha = 0.4,
			style = {
				text = "Alternatively, you may tap on an individual sector to conduct handover separately.",
				mode = 1,
				dir = 1,
				char = "char",
				posY = 0,
				posX = 0,
				uiset = {}
			}
		}
	}
}
