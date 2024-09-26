return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	alpha = 0,
	id = "DORM3DGIFTFEEDBACK8",
	hideSkip = true,
	hideAuto = true,
	scripts = {
		{
			actorName = "Sirius",
			nameColor = "#FFFFFF",
			say = "I'll keep it safe and loved.",
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
							name = "toukan",
							type = "action"
						},
						{
							skip = true,
							name = "Face_deyi",
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
