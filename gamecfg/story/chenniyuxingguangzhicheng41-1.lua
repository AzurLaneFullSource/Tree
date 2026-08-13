return {
	id = "CHENNIYUXINGGUANGZHICHENG41-1",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			bgm = "theme-shallowoftheworld",
			side = 2,
			bgName = "star_level_bg_589",
			nameColor = "#A9F548FF",
			shakeTime = 2,
			say = "RUMBLE...",
			soundeffect = "event:/ui/dalei",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			flashout = {
				black = false,
				dur = 1,
				alpha = {
					0,
					1
				}
			},
			effects = {
				{
					active = true,
					name = "yilishabai_alter_train_juqing"
				}
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_589",
			actor = 900352,
			dir = 1,
			nameColor = "#FFC960",
			say = "Dieu et mon droit.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			effects = {
				{
					active = true,
					name = "jinguang"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_589",
			say = "The Queen's Light rode high in the sky, leaving a golden trail like a shooting star. It carved a thin, yet clear boundary between the battling white and black.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 900322,
			side = 2,
			bgName = "star_level_bg_589",
			nameColor = "#BDBDBD",
			dir = 1,
			say = "Wooow, that train is pretty!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 900322,
			side = 2,
			bgName = "star_level_bg_589",
			nameColor = "#BDBDBD",
			dir = 1,
			say = "Are you test site beta's trump card?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			nameColor = "#FFC960",
			bgName = "star_level_bg_589",
			side = 2,
			dir = 1,
			actor = 900352,
			say = ".........",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			bgName = "star_level_bg_589",
			actor = 900352,
			dir = 1,
			nameColor = "#FFC960",
			say = "Honi soit qui mal y pense.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			effects = {
				{
					active = true,
					name = "jinguang"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_589",
			say = "Golden light radiated from the train, dispelling the darkness and transforming it into crimson-armored giants.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			movableNode = {
				{
					time = 2.8,
					name = "youlin_ylsb",
					spine = {
						action = "move",
						scale = 1
					},
					path = {
						{
							-1000,
							300
						},
						{
							1600,
							300
						}
					}
				},
				{
					time = 2.8,
					name = "youlin_ylsb",
					spine = {
						action = "move",
						scale = 1
					},
					path = {
						{
							-1000,
							125
						},
						{
							1600,
							125
						}
					}
				},
				{
					time = 2.8,
					name = "youlin_ylsb",
					spine = {
						action = "move",
						scale = 1
					},
					path = {
						{
							-1000,
							-50
						},
						{
							1600,
							-50
						}
					}
				},
				{
					time = 2.8,
					name = "youlin_ylsb",
					spine = {
						action = "move",
						scale = 1
					},
					path = {
						{
							-1000,
							-225
						},
						{
							1600,
							-225
						}
					}
				},
				{
					time = 2.8,
					name = "youlin_ylsb",
					spine = {
						action = "move",
						scale = 1
					},
					path = {
						{
							-1000,
							-400
						},
						{
							1600,
							-400
						}
					}
				}
			}
		},
		{
			actor = 900322,
			side = 2,
			bgName = "star_level_bg_589",
			nameColor = "#BDBDBD",
			dir = 1,
			say = "Ooh, that's a cool move!",
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
			actor = 900322,
			side = 2,
			bgName = "star_level_bg_589",
			nameColor = "#BDBDBD",
			dir = 1,
			say = "Awesome! Okay, I'm ready! Hit me with your best shot!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
