return {
	fadeOut = 1.5,
	dialogbox = 2,
	hideRecord = true,
	mode = 2,
	alpha = 0,
	id = "DORM3DDAILYCONVERSATION13",
	hideSkip = true,
	hideAuto = true,
	scripts = {
		{
			actor = 0,
			side = 2,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			say = "You always open the door just before I knock. Your timing is impeccable.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = "Sirius",
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "Heehee. I'm simply very good at detecting your footsteps and your presence, Master.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "shy",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = false,
							time = 1,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			}
		},
		{
			side = 2,
			actorName = "Sirius",
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "No, actually, perhaps we simply operate on the same wavelength.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
