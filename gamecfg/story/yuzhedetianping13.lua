﻿return {
	fadeOut = 1.5,
	mode = 2,
	id = "YUZHEDETIANPING13",
	once = true,
	fadeType = 2,
	fadein = 1.5,
	scripts = {
		{
			stopbgm = true,
			mode = 1,
			asideType = 3,
			sequence = {
				{
					"Sardegna Empire - Taranto",
					1
				},
				{
					"Immediately after the Gazer appearance",
					2
				}
			},
			flashin = {
				delay = 1,
				dur = 1,
				black = true,
				alpha = {
					1,
					0
				}
			}
		},
		{
			actor = 601050,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Whoooa! Giant dandelions are falling from the sky!",
			bgm = "story-clemenceau-judgement",
			action = {
				{
					type = "shake",
					y = 45,
					delay = 0,
					dur = 0.15,
					x = 0,
					number = 2
				}
			},
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 601040,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Whatever those are, they're obviously NOT dandelions!",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 601060,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			say = "Bleehhh... Since when did the Sirens start fielding disgusting weapons like this?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 607010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "The area around Taranto is a mess... Worse yet, I can't get in touch with Veneto or Littorio.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "Abruzzi, don't you think we should set out to battle?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 602010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			say = "No. Best not to jump the gun before we know what's going on.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			nameColor = "#A9F548FF",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			actor = 602010,
			side = 2,
			say = "Rash decisions have cost us too many times in the past.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 607010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Good point... Then hopefully, someone will contact us very soon.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			nameColor = "#ffff4d",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			actorName = "Communicator",
			stopbgm = true,
			say = "BEEP—",
			bgm = "theme-marcopolo",
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
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "This is Marco Polo. Do you read me?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "Oh! It's you, Marco Polo!",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "Thank goodness. This is Aquila speaking. Are you still at the World Expo?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 607010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "How's the situation over there? Do you have any idea what's going on?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "I had a feeling you knew something bizarre is happening.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "As you can already tell, all of Sardegna is in serious danger.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "In accordance with the state of emergency protocol, I am tasked with resolving this situation.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "Until the state of emergency is lifted, all military forces in and around Sardegna are under my command.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "Aquila, you and everyone else at Taranto are to head to the Expo immediately, prepare for battle, and wait for further instructions.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "To provide rescue and relief efforts? Understood.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 607010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Actually, wait... If I remember right, Veneto takes precedence over you on the chain of command on the state of emergency protocol...",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "What happened to her? Did she confer authority to you?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "Veneto this, Veneto that... It's always about her, isn't it?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "That's precisely why I've chosen this path.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#ffff4d",
			actor = 699010,
			say = "You know what? Screw all of you! Hmph!",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = "Communicator",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			nameColor = "#ffff4d",
			say = "BEEP—",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "Hm? H-hello? Marco Polo?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "Aren't you going to tell us what's going on?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 602010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			say = "It seems safe to say something quite bad is going down.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 602010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			say = "It'd be one thing if this was just another quarrel between them, but this clearly goes way beyond any feud.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			nameColor = "#A9F548FF",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			actor = 602010,
			side = 2,
			say = "That strange substance continues to spread even as we speak.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			nameColor = "#A9F548FF",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			actor = 601060,
			side = 2,
			say = "Bad news! Really bad news, everyone!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			nameColor = "#A9F548FF",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			actor = 601060,
			side = 2,
			say = "Look outside! Some ginormous three-legged robot appeared out of nowhere!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			nameColor = "#A9F548FF",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			actor = 601060,
			side = 2,
			say = "It's releasing a white mist everywhere, and it's coming towards us!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 602010,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			say = "A white mist? It can't be!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			nameColor = "#A9F548FF",
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			actor = 602010,
			side = 2,
			say = "That robot must be the source of the spore-like substance gumming up the sky!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_underheaven_1",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 607010,
			say = "Abruzzi! Da Recco! Let us prepare for battle at once!",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}