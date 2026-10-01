return {
	id = "YICHANGDERICHANGDUANJUQING20",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			expression = 3,
			side = 2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			dir = 1,
			NextIcon = 1,
			actor = 900561,
			say = "Let me just sneak up closer... And when you least expect it... Boo!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			side = 2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			dir = 1,
			NextIcon = 1,
			actor = 900561,
			say = "Oh, you don't look surprised at all. I wouldn't have expected any less~",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			dir = 1,
			NextIcon = 1,
			actor = 900561,
			say = "What are you doing out here so late? Looking for something?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "Looking for you.",
					flag = 1
				},
				{
					content = "I just couldn't fall asleep.",
					flag = 2
				}
			}
		},
		{
			expression = 4,
			side = 2,
			NextIcon = 1,
			dir = 1,
			optionFlag = 1,
			actor = 900561,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Oh, you were looking for little ol' me? I'm so happy!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			NextIcon = 1,
			dir = 1,
			optionFlag = 1,
			actor = 900561,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Commander, what would you like to do with me now that you found me?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 8,
			side = 2,
			NextIcon = 1,
			dir = 1,
			optionFlag = 2,
			actor = 900561,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "In that case... Feel free to rely on me if you ever need anything.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
