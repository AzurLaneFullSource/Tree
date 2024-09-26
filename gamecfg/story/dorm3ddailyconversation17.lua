return {
	fadeOut = 1.5,
	dialogbox = 2,
	hideRecord = true,
	mode = 2,
	alpha = 0,
	id = "DORM3DDAILYCONVERSATION17",
	hideSkip = true,
	hideAuto = true,
	scripts = {
		{
			optionFlag = 1,
			side = 0,
			say = "!!!!!选项放第一句 say是什么呢？!!!!!!",
			hidePaintObj = true,
			options = {
				{
					content = "Is there something on your mind?",
					flag = 1
				}
			}
		},
		{
			side = 2,
			actorName = "Sirius",
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "Oh, um, I'm thinking about the clouds.",
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
							name = "sikao2",
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
			say = "I've been told that what a cloud looks like to you reflects what your heart desires above all else.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "And what does your heart desire most?",
					flag = 1
				}
			}
		},
		{
			side = 2,
			actorName = "Sirius",
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "Master... I think you already know the answer.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
