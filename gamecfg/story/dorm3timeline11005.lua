return {
	hideRecord = true,
	dialogbox = 2,
	mode = 2,
	id = "DORM3TIMELINE11005",
	alpha = 0,
	hideSkip = true,
	hideAuto = true,
	placeholder = {
		"dorm3d"
	},
	scripts = {
		{
			bgm = "Story-room-newjersey",
			stopbgm = true,
			dispatcher = {
				nextOne = true,
				name = STORY_EVENT.TEST,
				data = {
					op_list = {
						{
							sceneRoot = "Xinzexi_DB/Newjerseyhostel",
							name = "FFliwu_10517_02",
							scene = "map_newjerseyhostel_01",
							type = "timeline",
							skip = false,
							options = {
								{
									{
										content = "Interesting. This takes a bit of thinking."
									}
								},
								{
									{
										content = "I've seen through your strategy."
									}
								},
								{
									{
										content = "This doesn't seem like a fair fight."
									}
								},
								{
									{
										content = "Maybe I can at least force a draw!"
									}
								}
							},
							touchs = {
								{
									{
										pos = {
											0,
											0
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
