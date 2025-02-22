local var0_0 = {
	"First, let's <color=#ffde38>lock</color> this character in.",
	"Let's head back to the main screen again."
}

return {
	id = "S003",
	events = {
		{
			alpha = 0.359,
			waitScene = "NewShipLayer",
			ui = {
				path = "/OverlayCamera/Overlay/UIMain/NewShipUI(Clone)/shake_panel/click",
				pathIndex = -1,
				triggerType = {
					1
				},
				fingerPos = {
					posY = -134,
					posX = 209
				}
			}
		},
		{
			alpha = 0.214,
			style = {
				dir = -1,
				mode = 1,
				posY = 250,
				posX = 450,
				text = var0_0[1]
			},
			ui = {
				path = "OverlayCamera/Overlay/UIMain/Msgbox(Clone)/window/button_container/custom_button_1(Clone)",
				pathIndex = -1,
				triggerType = {
					1
				},
				fingerPos = {
					posY = -27.53,
					posX = 40.15
				}
			}
		},
		{
			alpha = 0.446,
			style = {
				dir = -1,
				mode = 2,
				posY = 213.63,
				posX = -194.88,
				text = var0_0[2]
			},
			ui = {
				path = "/OverlayCamera/Overlay/UIMain/blur_panel/adapt/top/back_btn",
				pathIndex = -1,
				triggerType = {
					1
				},
				fingerPos = {
					posY = -40,
					posX = 20
				}
			}
		}
	}
}
