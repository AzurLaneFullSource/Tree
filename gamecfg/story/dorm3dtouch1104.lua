return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	alpha = 0,
	id = "DORM3DTOUCH1104",
	hideSkip = true,
	hideAuto = true,
	scripts = {
		{
			actorName = "Sirius",
			nameColor = "#FFFFFF",
			say = "My honourable Master, that's my... Pl-please don't tease me like this.",
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
							name = "swim02_jian",
							type = "action"
						},
						{
							param = "Play",
							name = "Face_renzhen",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = false,
							time = 2,
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
