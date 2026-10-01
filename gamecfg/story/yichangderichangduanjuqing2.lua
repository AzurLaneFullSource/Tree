return {
	id = "YICHANGDERICHANGDUANJUQING2",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			actor = 202381,
			nameColor = "#A9F548FF",
			NextIcon = 1,
			hidePaintObj = true,
			dir = 1,
			side = 2,
			say = "Commander, can you hear it?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 202381,
			nameColor = "#A9F548FF",
			side = 2,
			hidePaintObj = true,
			dir = 1,
			NextIcon = 1,
			say = "That lovely melody drifting in from beyond the skies?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "I can hear it.",
					flag = 1
				},
				{
					content = "Can't hear it.",
					flag = 2
				}
			}
		},
		{
			expression = 8,
			side = 2,
			NextIcon = 1,
			dir = 1,
			optionFlag = 1,
			actor = 202381,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I knew it. You can hear the stars singing in harmony too, can't you?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 202381,
			nameColor = "#A9F548FF",
			side = 2,
			hidePaintObj = true,
			dir = 1,
			optionFlag = 2,
			NextIcon = 1,
			say = "It's fine if you can't hear it just yet.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 202381,
			nameColor = "#A9F548FF",
			side = 2,
			hidePaintObj = true,
			dir = 1,
			optionFlag = 2,
			NextIcon = 1,
			say = "When the time comes, I'll take you to the cosmos myself, and we can listen to that beautiful movement together.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
