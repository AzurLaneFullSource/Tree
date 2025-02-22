return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	id = "DORM3DHELL21",
	alpha = 0,
	hideSkip = true,
	hideAuto = true,
	placeholder = {
		"dorm3d"
	},
	scripts = {
		{
			nameColor = "#FFFFFF",
			actorName = 30221,
			say = "You've arrived, {dorm3d}. Do you have any plans for today? If not, how about I help you make a schedule?",
			voice = "event:/dorm/Tianlangxing_dorm3d_tone1/drom3d_sirus_hello8",
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
							name = "shuohua_qidai",
							type = "action"
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
