local var0_0 = {
	"Your Support Fleet can aid fellow Guild members during boss battles.",
	"Let's try adding a ship to your Support Fleet!",
	"Tap here to edit your Support Fleet.",
	"Tap the ship you'd like to add to your Support Fleet."
}

return {
	id = "GNG001",
	events = {
		{
			alpha = 0.433,
			style = {
				dir = 1,
				mode = 2,
				posY = -223,
				posX = 495.2,
				text = var0_0[1]
			}
		},
		{
			alpha = 0.433,
			style = {
				dir = 1,
				mode = 2,
				posY = -223,
				posX = 495.2,
				text = var0_0[2]
			}
		},
		{
			alpha = 0.433,
			style = {
				dir = 1,
				mode = 2,
				posY = -223,
				posX = 495.2,
				text = var0_0[3]
			},
			ui = {
				path = "/UICamera/Canvas/UIMain/GuildEmptyUI(Clone)/GuildEventPage(Clone)/formation_btn",
				triggerType = {
					1
				},
				fingerPos = {
					posX = 166.9,
					posY = 0,
					rotateX = 0,
					rotateZ = 0,
					rotateY = 0
				}
			}
		},
		{
			alpha = 0.383,
			style = {
				dir = 1,
				mode = 2,
				posY = 267.65,
				posX = 17.53,
				text = var0_0[4]
			},
			ui = {
				path = "/OverlayCamera/Overlay/UIMain/GuildEventFormationUI(Clone)/frame/ship1",
				triggerType = {
					1
				},
				fingerPos = {
					posX = 166.9,
					posY = 0,
					rotateX = 0,
					rotateZ = 0,
					rotateY = 0
				}
			}
		}
	}
}
