return {
	fadeOut = 1.5,
	mode = 2,
	defaultTb = 3101,
	id = "TANSUOZHEXINZHIXUYU3",
	placeholder = {
		"tb"
	},
	scripts = {
		{
			expression = 2,
			side = 2,
			bgName = "bg_project_explorer_room2",
			actor = -2,
			actorName = "Lora",
			bgm = "qe-ova-3",
			dynamicBgType = -2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Where should I leave these documents? On the desk?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "bg_project_explorer_room2",
			actor = -2,
			actorName = "Lora",
			dynamicBgType = -2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I'm just worried I'll put them in the wrong place...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = -2,
			side = 2,
			bgName = "bg_project_explorer_room2",
			actorName = "Lora",
			dynamicBgType = -2,
			nameColor = "#A9F548FF",
			important = true,
			hidePaintObj = true,
			say = "Also... maybe I should reorganize them according to date...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					flag = 1,
					content = "That'd be great. Sort by date, please.",
					type = 1
				},
				{
					flag = 2,
					content = "Sort them by color. It'll be more efficient.",
					type = 2
				}
			}
		},
		{
			actor = -2,
			side = 2,
			bgName = "bg_project_explorer_room2",
			actorName = "Lora",
			optionFlag = 1,
			dynamicBgType = -2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Alright, then...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "bg_project_explorer_room2",
			actor = -2,
			actorName = "Lora",
			optionFlag = 1,
			dynamicBgType = -2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I'll, um... keep at it!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "bg_project_explorer_room2",
			actor = -2,
			actorName = "Lora",
			optionFlag = 2,
			dynamicBgType = -2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "B-by color...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 7,
			side = 2,
			bgName = "bg_project_explorer_room2",
			actor = -2,
			actorName = "Lora",
			optionFlag = 2,
			dynamicBgType = -2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Okay! I'll see what I can do!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
