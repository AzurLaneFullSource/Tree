return {
	id = "YOUYINGMICHENG18-3",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_148",
			hidePaintObj = true,
			say = "When the Companion Ball's glow touches Lion, she's startled for a moment – but then, she smirks.",
			bgm = "story-visioncity-1",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 9,
			side = 2,
			bgName = "star_level_bg_148",
			factiontag = "Poltergeist",
			dir = 1,
			actor = 205162,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I'm willing to accept when I'm beat. You win.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			asideType = 4,
			mode = 1,
			bgName = "bg_youyingmicheng_2",
			spacing = 30,
			flashout = {
				black = true,
				dur = 0.5,
				alpha = {
					0,
					1
				}
			},
			flashin = {
				delay = 0.5,
				dur = 0.5,
				black = true,
				alpha = {
					1,
					0
				}
			},
			rectMargin = {
				100,
				100,
				200,
				200
			},
			sequence = {
				{
					"Thus, Cities No. 3 through 6 have joined hands with us.",
					0
				},
				{
					"The front line progressed to New Era City No. 2...",
					1
				},
				{
					"The stronghold of Dark Lord Azuchi.",
					2
				}
			}
		}
	}
}
