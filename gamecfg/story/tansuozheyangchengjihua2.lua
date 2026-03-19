return {
	fadeOut = 1.5,
	mode = 2,
	defaultTb = 3002,
	id = "TANSUOZHEYANGCHENGJIHUA2",
	placeholder = {
		"tb"
	},
	scripts = {
		{
			expression = 2,
			side = 2,
			bgName = "bg_project_explorer_room1",
			tbActor = true,
			actorName = "Lora",
			bgm = "qe-ova-13",
			actor = 3002,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "{tb}... {tb}... {tb}!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 15,
			side = 2,
			bgName = "bg_project_explorer_room1",
			actorName = "Lora",
			tbActor = true,
			actor = 3002,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Okey-dokey! From now on, you're {tb} to me!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
