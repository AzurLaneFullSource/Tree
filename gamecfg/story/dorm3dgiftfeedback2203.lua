return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	id = "DORM3DGIFTFEEDBACK2203",
	alpha = 0,
	hideSkip = true,
	hideAuto = true,
	placeholder = {
		"dorm3d"
	},
	scripts = {
		{
			nameColor = "#FFFFFF",
			actorName = 20707,
			say = "I accept your gift. Now I have yet another reason to hold you in my heart. Heeheehee.",
			voice = "event:/dorm/drom3d_implacable_freegift_voice3/drom3d_implacable_freegift_voice3",
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
							name = "answer_01-start",
							type = "action"
						},
						{
							skip = true,
							name = "Face_smile_start",
							type = "action"
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
