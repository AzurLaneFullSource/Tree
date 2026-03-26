return {
	fadeOut = 1.5,
	mode = 2,
	id = "MANYOUZHEZHAOMUJIHUA12",
	placeholder = {
		"playername"
	},
	scripts = {
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_starsea_core_1",
			hidePaintObj = true,
			say = "As the night wears on, the Vagabonds scattered across the city take their positions. On my command, they spring into action.",
			bgm = "story-wanderingcity-pv",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			flashin = {
				delay = 0,
				dur = 1,
				black = true,
				alpha = {
					1,
					0
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_starsea_core_1",
			hidePaintObj = true,
			say = "Alarms blare across the city all at once. Unryuu and I use the opportunity to infiltrate the laboratory.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_starsea_core_1",
			hidePaintObj = true,
			say = "The device for inputting the Protocol Zero key is within sight.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_starsea_core_1",
			hidePaintObj = true,
			say = "We successfully reset the system. With no fanfare or explosions, the whole city goes dark at once. Instantly after, it lights up again, as if given new life.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			bgName = "bg_starsea_core_1",
			mode = 1,
			asideType = 4,
			spacing = 30,
			soundeffect = "event:/ui/didi",
			rectMargin = {
				100,
				100,
				200,
				200
			},
			sequence = {
				{
					"<size=35>Municipal Management System: Low-level format complete Purging all improper control protocols and derivative data. Restarting municipal management system core... Initializing citizen profiles and roles... Order restoration protocol complete.</size>",
					0
				},
				{
					"<size=35>Municipal Management System: Low-level format complete Purging all improper control protocols and derivative data. Restarting municipal management system core... Initializing citizen profiles and roles... Order restoration protocol complete.</size>",
					0.5
				},
				{
					"<size=35>Municipal Management System: Low-level format complete Purging all improper control protocols and derivative data. Restarting municipal management system core... Initializing citizen profiles and roles... Order restoration protocol complete.</size>",
					1
				},
				{
					"<size=35>Municipal Management System: Low-level format complete Purging all improper control protocols and derivative data. Restarting municipal management system core... Initializing citizen profiles and roles... Order restoration protocol complete.</size>",
					1.5
				},
				{
					"<size=35>Municipal Management System: Low-level format complete Purging all improper control protocols and derivative data. Restarting municipal management system core... Initializing citizen profiles and roles... Order restoration protocol complete.</size>",
					2
				},
				{
					"<size=35>Municipal Management System: Low-level format complete Purging all improper control protocols and derivative data. Restarting municipal management system core... Initializing citizen profiles and roles... Order restoration protocol complete.</size>",
					2.5
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_starsea_core_1",
			hidePaintObj = true,
			say = "The wanted notice disappears, and frozen privileges are gradually restored, bringing order back to Thorn City.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "bg_starsea_core_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 307171,
			say = "It worked... We've done it, Commander! You're getting rewarded handsomely later!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_starsea_core_1",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Yeah... It's all over.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			asideType = 1,
			mode = 1,
			flashout = {
				black = true,
				dur = 1,
				alpha = {
					0,
					1
				}
			},
			sequence = {
				{
					"Ending Log: 03 – Order Rebuilt",
					0
				},
				{
					"Calculating score...",
					0.5
				},
				{
					"Play time: 57.32 hours",
					1
				},
				{
					"Overall rating: A",
					1.5
				},
				{
					"In the name of order, we rebuild.",
					2
				},
				{
					"Vagabond City closed beta test terminated.",
					2.5
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			say = "As expected, I'm hit by an intense feeling of detachment. When I open my eyes, I'm back in my office at the port.",
			bgm = "story-richang-1",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			flashin = {
				delay = 0,
				dur = 1,
				black = true,
				alpha = {
					1,
					0
				}
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 312010,
			say = "Commander! Are you okay, nya?!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 312010,
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "There was a sudden fluctuation in the data stream, and it forced my test server to reboot, nya!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "I freed it from Long Island's control. It was all thanks to the Protocol Zero key you left for me.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 312010,
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Thank goodness, nya... That could've been really bad, nya!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 312010,
			say = "But... All of my test data got totally scrubbed, nya! There goes a month of my hard work... This sucks, nya!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			dialogShake = {
				speed = 0.08,
				x = 15,
				number = 2
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Isn't a reformatting preferable to letting Long Island keep control over your system?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 312010,
			say = "Yeah... I GUESS, nya...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 312010,
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Long Island's got some nerve, nya...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 312010,
			say = "Taking my game away from me, nya? I'm gonna find her and make her pay me back by being my new QA tester, nya!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			asideType = 1,
			mode = 1,
			flashout = {
				black = true,
				dur = 1,
				alpha = {
					0,
					1
				}
			},
			sequence = {
				{
					"The Vagabond's Recruitment Plan - The End",
					2
				}
			}
		}
	}
}
