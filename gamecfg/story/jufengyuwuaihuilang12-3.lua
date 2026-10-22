return {
	id = "JUFENGYUWUAIHUILANG12-3",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_525",
			say = "We carefully maneuvered the vessel, fighting off the pincer attack by the sea serpent and skelebeasts.",
			bgm = "theme-tempest",
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
			bgName = "star_level_bg_525",
			say = "Eventually...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			bgName = "star_level_bg_525",
			mode = 1,
			sequence = {
				{
					"",
					0
				}
			},
			movableNode = {
				{
					time = 1000,
					name = "fengfan_haigu_boss03",
					spine = {
						action = "normal",
						scale = 1
					},
					path = {
						{
							0,
							-200
						},
						{
							0,
							-200
						}
					}
				}
			}
		},
		{
			side = 2,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_525",
			shakeTime = 2,
			say = "ROOOOAR!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			effects = {
				{
					active = true,
					name = "speed"
				}
			},
			movableNode = {
				{
					time = 1000,
					name = "fengfan_haigu_boss03",
					spine = {
						action = "normal",
						scale = 1
					},
					path = {
						{
							0,
							-200
						},
						{
							0,
							-200
						}
					}
				}
			}
		},
		{
			expression = 5,
			side = 2,
			bgName = "star_level_bg_525",
			factiontag = "Stellapolis",
			dir = 1,
			actor = 9600190,
			nameColor = "#A9F548FF",
			say = "Now! They're distracted! Execute the plan!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			effects = {
				{
					active = false,
					name = "speed"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_525",
			say = "KABOOOOM!",
			soundeffect = "event:/battle/boom2",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			flashN = {
				color = {
					1,
					1,
					1,
					1
				},
				alpha = {
					{
						0,
						1,
						0.2,
						0
					},
					{
						1,
						0,
						0.2,
						0.2
					},
					{
						0,
						1,
						0.2,
						0.4
					},
					{
						1,
						0,
						0.2,
						0.6
					}
				}
			},
			dialogShake = {
				speed = 0.09,
				x = 8.5,
				number = 2
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_525",
			say = "Selimiye's illusions take shape, and Anne's shroud of darkness proves effective. Just then, a whisper reaches us from high in the starry sky.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			bgName = "star_level_bg_594",
			mode = 1,
			asideType = 4,
			spacing = 30,
			flashout = {
				black = true,
				dur = 1,
				alpha = {
					0,
					1
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
					"Capture...",
					0
				}
			}
		},
		{
			actor = 9600170,
			nameColor = "#FEF15E",
			bgName = "star_level_bg_594",
			hidePaintObj = true,
			dir = 1,
			actorName = "???",
			side = 2,
			say = "Capture it alive...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			portrait = "zhihuiguan",
			side = 2,
			bgName = "star_level_bg_525",
			factiontag = "Commander",
			actor = 0,
			nameColor = "#A9F548FF",
			say = "......",
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
			expression = 1,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_525",
			side = 2,
			dir = 1,
			actor = 9600190,
			say = "Whoever's up there making those crazy demands, how about YOU come down and try it?! Ugh!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_525",
			say = "Selimiye and I exchange glances.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_525",
			factiontag = "Commander",
			side = 2,
			portrait = "zhihuiguan",
			say = "(I am curious about this order, but...)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			portrait = "zhihuiguan",
			side = 2,
			bgName = "star_level_bg_525",
			factiontag = "Commander",
			actor = 0,
			nameColor = "#A9F548FF",
			say = "The thing is...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "Sorry, but it's just not feasible.",
					flag = 1
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_525",
			say = "Given that we were the only two to hear it, it didn't take long to come to an agreement.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_525",
			factiontag = "Commander",
			side = 2,
			portrait = "zhihuiguan",
			say = "Royal Fortune, prepare to dive!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_525",
			side = 2,
			dir = 1,
			actor = 9600010,
			say = "Hold on tight, everyone. We're gonna scram!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
