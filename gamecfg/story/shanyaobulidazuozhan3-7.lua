return {
	id = "SHANYAOBULIDAZUOZHAN3-7",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			bgm = "theme-vanguard",
			side = 2,
			bgName = "star_level_bg_596",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			say = "KABOOOM!",
			soundeffect = "event:/battle/boom2",
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
			expression = 2,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "demon★king",
			actorName = "Lord of Evil",
			actor = 900233,
			nameColor = "#FF9B93",
			hidePaintObj = true,
			say = "Ugh... Now I can FINALLY ditch this weird-ass film set.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "demon★king",
			actorName = "Lord of Evil",
			soundeffect = "event:/battle/boom2",
			actor = 900233,
			nameColor = "#FF9B93",
			hidePaintObj = true,
			say = "My troops, I command you! You're going down with me!",
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
			asideType = 4,
			mode = 1,
			spacing = 30,
			rectAlpha = 0,
			blackBg = true,
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
					"And so, the Lord of Evil and her terrifying army went up in flames and vanished.",
					0
				}
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "little★knight",
			dir = 1,
			actor = 204040,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Justice always prevails!",
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
			},
			dialogShake = {
				speed = 0.08,
				x = 15,
				number = 2
			}
		},
		{
			bgName = "star_level_bg_596",
			mode = 1,
			sequence = {
				{
					"",
					0
				}
			},
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
			icon = {
				scale = 2,
				image = "Props/20001",
				pos = {
					0,
					0
				}
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "little★knight",
			dir = 1,
			actor = 204040,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "The Omni-Cube is ours at last. What shall we wish for? World peace?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "super★burin",
			dir = 1,
			actor = 100020,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "No, bulin...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 100011,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "golden★purin",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "This Cube tempts man and brings war whenever it appears, purin... It's the reason behind all this, purin! It can't keep getting away with it, purin!",
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
			actor = 100002,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "magic★buli",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "For the sake of love, peace, justice, and the future, we need to destroy it rather than make a wish to it, buli!",
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
			actor = 100011,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "golden★purin",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Help us deal with it, little knight! Purin!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 204040,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "little★knight",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "...Of course! Gladly!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 100002,
			side = 2,
			bgName = "star_level_bg_596",
			factiontag = "magic★buli",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "In the name of the three bulin sisters – shatter into pieces, buli!",
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
			mode = 1,
			asideType = 1,
			bgm = "login",
			flashout = {
				dur = 1,
				alpha = {
					0,
					1
				}
			},
			flashin = {
				delay = 1,
				dur = 1,
				alpha = {
					1,
					0
				}
			},
			sequence = {
				{
					"There was a blinding light, and the Omni-Cube was broken into a million pieces.",
					0
				},
				{
					"The world was returned to peace and calm.",
					0.5
				},
				{
					"The little knight set out on her journey once more.",
					1
				},
				{
					"The bulin sisters, meanwhile, went back to leading their quiet lives.",
					1.5
				},
				{
					"Secretly, they waited for that big moment to come...",
					2
				},
				{
					"When they could flex their full might again.",
					2.5
				}
			}
		},
		{
			asideType = 1,
			mode = 1,
			sequence = {
				{
					"DISCLAIMER",
					0
				},
				{
					"This is a work of fiction based on the fantasies of the bulin sisters.",
					0.5
				},
				{
					"Any similarity to events, past or future, is merely a coincidence.",
					1
				},
				{
					"No Wisdom Cubes were destroyed during the production of this story.",
					1.5
				},
				{
					"We hope you enjoyed it.",
					2
				},
				{
					"Operation: Shining Bulin - The End",
					2.5
				}
			}
		}
	}
}
