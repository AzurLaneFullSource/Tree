return {
	id = "SHENGYINQIANDETONGMENG33-2",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			expression = 2,
			side = 2,
			bgName = "bg_aircraft_future",
			actor = 102160,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Commander, the destruction of the netherworld is slowing.",
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
			location = {
				"Tribunal's Hand",
				3
			}
		},
		{
			expression = 2,
			nameColor = "#A9F548FF",
			bgName = "bg_aircraft_future",
			side = 2,
			dir = 1,
			actor = 102160,
			say = "It seems the area around the tower is resisting it the most... Some areas have stopped changing entirely.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_aircraft_future",
			side = 2,
			portrait = "zhihuiguan",
			say = "It can never be easy, can it? Prepare all units for battle–",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_aircraft_future",
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
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_aircraft_future",
			side = 2,
			portrait = "zhihuiguan",
			say = "What's going on? Why did the defense system just activate?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			nameColor = "#A9F548FF",
			bgName = "bg_aircraft_future",
			side = 2,
			dir = 1,
			actor = 102160,
			say = "Flying objects detected on radar... Wait, what is this?!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			nameColor = "#A9F548FF",
			bgName = "bg_aircraft_future",
			side = 2,
			actor = 102059,
			say = "Commander, emergency! Something has happened on the front line!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			nameColor = "#A9F548FF",
			bgName = "bg_aircraft_future",
			side = 2,
			actor = 102059,
			say = "Transmitting recon plane footage now!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_hrr_2",
			say = "Darkness parts from the water's surface and rises as a great, dark wall.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
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
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_hrr_2",
			say = "It takes a few seconds for me to parse what I'm seeing in the footage.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_hrr_2",
			side = 2,
			portrait = "zhihuiguan",
			say = "The netherworld... used the last of its power to create flying enemies?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_hrr_2",
			say = "Our so-called wall is actually a flood of black enemies, closing in on the Holy Unitas Empire like a plague of locusts.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_hrr_2",
			say = "It's enough to make you think the world is ending.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_hrr_2",
			side = 2,
			portrait = "zhihuiguan",
			say = "The netherworld's death throes... Here I was, ready to let the locals end this with their own hands.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_hrr_2",
			side = 2,
			portrait = "zhihuiguan",
			say = "Memphis, get me in contact with Friedrich der Große.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = "Communicator",
			bgName = "bg_hrr_2",
			nameColor = "#A9F548FF",
			say = "BEEP BEEP!",
			soundeffect = "event:/ui/didi",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_hrr_2",
			factiontag = "The Emperor",
			dir = 1,
			actor = 499020,
			nameColor = "#A9F548FF",
			say = "I'm here, my child.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_hrr_2",
			side = 2,
			portrait = "zhihuiguan",
			say = "The enemy is launching a counterattack. We need to destroy that tower immediately – can you use that orbital strike of yours again?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_hrr_2",
			factiontag = "The Emperor",
			dir = 1,
			actor = 499020,
			nameColor = "#A9F548FF",
			say = "It's primed and ready.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_hrr_2",
			side = 2,
			portrait = "zhihuiguan",
			say = "Destroy that tower and end this.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_hrr_2",
			factiontag = "The Emperor",
			dir = 1,
			paintingNoise = true,
			actor = 499020,
			nameColor = "#A9F548FF",
			say = "I would be happy to grant your wish, my child.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
