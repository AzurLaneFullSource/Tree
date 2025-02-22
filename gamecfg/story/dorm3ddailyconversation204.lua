return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	id = "DORM3DDAILYCONVERSATION204",
	alpha = 0,
	hideSkip = true,
	hideAuto = true,
	placeholder = {
		"dorm3d"
	},
	scripts = {
		{
			side = 2,
			actorName = 30221,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			say = "I found a recipe for a very good dessert, and I was hoping you could be my taste-tester.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = 30221,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			say = "The only problem is, it doesn't list exact amounts, it only says \"a little.\"",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = 30221,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			say = "How much is \"a little\" supposed to be?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "Try putting it all in a bit at a time.",
					flag = 1
				}
			},
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							skip = true,
							name = "shuohua_baoxiongsikao",
							type = "action"
						},
						{
							time = 2.5,
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
			actorName = 30221,
			nameColor = "#FFFFFF",
			hidePaintObj = true,
			say = "Yes, I suppose that's the only way. I'll give it a shot.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
