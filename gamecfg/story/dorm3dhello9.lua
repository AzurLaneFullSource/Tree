return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	alpha = 0,
	id = "DORM3DHELLO9",
	hideSkip = true,
	hideAuto = true,
	scripts = {
		{
			nameColor = "#FFFFFF",
			actorName = "Sirius",
			say = "You're finally here, honourable Master. I always look forward to our time together. Shall I relieve your exhaustion with a massage first?",
			voice = "event:/dorm/Tianlangxing_dorm3d_tone1/drom3d_sirus_hello9",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							skip = true,
							name = "Bow",
							type = "action"
						},
						{
							param = "Play",
							name = "Face_weixiao",
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
		}
	}
}
