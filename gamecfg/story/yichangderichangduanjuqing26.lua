return {
	id = "YICHANGDERICHANGDUANJUQING26",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			actor = 205162,
			nameColor = "#A9F548FF",
			side = 2,
			hidePaintObj = true,
			withoutActorName = true,
			hideRecordIco = true,
			say = "Lion slows down her pace as we walk past a toy store, seemingly curious about the lion plush on the display shelf.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 7,
			nameColor = "#A9F548FF",
			actor = 205162,
			hidePaintObj = true,
			dir = 1,
			side = 2,
			say = "Ahem! I'm just a little tired from all the walking.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 7,
			side = 2,
			actor = 205162,
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Why don't you take a look? Maybe you'll find something you wanna buy?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "Let's buy that lion plush.",
					flag = 1
				},
				{
					content = "Not really.",
					flag = 2
				}
			}
		},
		{
			expression = 8,
			side = 2,
			actor = 205162,
			hidePaintObj = true,
			dir = 1,
			optionFlag = 1,
			nameColor = "#A9F548FF",
			say = "That lion plush... It has a very imposing presence.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 8,
			side = 2,
			actor = 205162,
			hidePaintObj = true,
			dir = 1,
			optionFlag = 1,
			nameColor = "#A9F548FF",
			say = "Heheh, you've got a good eye for quality♪",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			actor = 205162,
			hidePaintObj = true,
			dir = 1,
			optionFlag = 2,
			nameColor = "#A9F548FF",
			say = "...I see.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			actor = 205162,
			hidePaintObj = true,
			dir = 1,
			optionFlag = 2,
			nameColor = "#A9F548FF",
			say = "Then I won't get anything either. Let's go.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
