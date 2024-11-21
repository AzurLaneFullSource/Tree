return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	id = "DORM3DPAIDGIFTFEEDBACK2",
	alpha = 0,
	hideSkip = true,
	hideAuto = true,
	placeholder = {
		"dorm3d"
	},
	scripts = {
		{
			bgm = "story-room-sirius",
			stopbgm = true,
			dispatcher = {
				nextOne = true,
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							skip = false,
							name = "FFliwu_cadiban",
							time = 0,
							type = "timeline",
							options = {},
							touchs = {
								[0] = {
									{
										pos = {
											50,
											-30
										}
									}
								},
								{
									{
										pos = {
											0,
											50
										}
									}
								}
							}
						}
					}
				},
				callbackData = {
					hideUI = true,
					name = STORY_EVENT.TEST_DONE
				}
			}
		}
	}
}
