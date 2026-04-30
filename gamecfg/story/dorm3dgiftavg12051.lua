return {
	fadeOut = 1.5,
	dialogbox = 2,
	hideRecord = true,
	mode = 2,
	alpha = 0,
	id = "DORM3DGIFTAVG12051",
	hideSkip = true,
	hideAuto = true,
	placeholder = {
		"dorm3d"
	},
	scripts = {
		{
			actorName = 30707,
			side = 2,
			wait = 1,
			hidePaintObj = true,
			nameColor = "#FFFFFF",
			say = "Ah. My Commander! I didn't hear your footsteps, so you startled me.",
			voice = "event:/dorm/drom3d_Taiho_gift_timeline03_voice1/drom3d_Taiho_gift_timeline03_voice1",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "amazed_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_amazed_start",
							type = "action"
						},
						{
							skip = false,
							time = 1.5,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "Are you cleaning out your closet?",
					flag = 1
				}
			}
		},
		{
			side = 2,
			actorName = 30707,
			wait = 1,
			hidePaintObj = true,
			dir = 1,
			nameColor = "#FFFFFF",
			say = "Haha, of course not. I'm just grabbing a new pair of pajamas.",
			voice = "event:/dorm/drom3d_Taiho_gift_timeline03_voice2/drom3d_Taiho_gift_timeline03_voice2",
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
							name = "yandere_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_smile_start",
							type = "action"
						},
						{
							skip = false,
							time = 1.5,
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
			actorName = 30707,
			wait = 1,
			hidePaintObj = true,
			dir = 1,
			nameColor = "#FFFFFF",
			say = "It's a new set that you've never seen before... Heehee.",
			voice = "event:/dorm/drom3d_Taiho_gift_timeline03_voice3/drom3d_Taiho_gift_timeline03_voice3",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "Okay. Well, I look forward to that.",
					flag = 1
				}
			}
		},
		{
			actorName = 30707,
			side = 2,
			wait = 1,
			hidePaintObj = true,
			dir = 1,
			nameColor = "#FFFFFF",
			say = "Please do! Also... I'd like you to join in the new pajama changing ceremony with me♡",
			voice = "event:/dorm/drom3d_Taiho_gift_timeline03_voice4/drom3d_Taiho_gift_timeline03_voice4",
			dispatcher = {
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							param = "Play",
							name = "satisfied_01-start",
							time = 0,
							type = "action",
							skip = true
						},
						{
							skip = true,
							name = "Face_shy_start",
							type = "action"
						},
						{
							skip = false,
							time = 1.5,
							type = "wait"
						}
					}
				},
				callbackData = {
					hideUI = false,
					name = STORY_EVENT.TEST_DONE
				}
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
