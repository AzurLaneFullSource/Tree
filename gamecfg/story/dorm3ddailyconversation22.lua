return {
	fadeOut = 1.5,
	dialogbox = 2,
	hideRecord = true,
	mode = 2,
	alpha = 0,
	id = "DORM3DDAILYCONVERSATION22",
	hideSkip = true,
	hideAuto = true,
	scripts = {
		{
			actor = 0,
			side = 2,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			say = "Do you ever feel disappointed when you miss the sunset?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = 20220,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "Miss... the sunset? Is it a shame that you're missing out on the beauty of it? I'm not sure I understand.",
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
			actorName = 20220,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "Are you saying that you miss seeing the transition from dusk to night, so the line between days blurs?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = 20220,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "In that case, I shall help you with your papers every day from now on so you may finish your work sooner!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = 20220,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			dir = 1,
			say = "Whatever you wish for, I strive to make come true!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
