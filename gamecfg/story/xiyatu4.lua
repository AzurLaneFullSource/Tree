return {
	fadeOut = 1.5,
	mode = 2,
	id = "XIYATU4",
	once = true,
	fadeType = 2,
	fadein = 1.5,
	scripts = {
		{
			stopbgm = true,
			mode = 1,
			sequence = {
				{
					"A Party for the Ages\n\n<size=45>4.Setting the Table</size>",
					1
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_room",
			say = "Next item on the party preparations list: the food. Seattle and I arrive at the Sakura Empire dorm to hammer out our plans.",
			bgmDelay = 2,
			bgm = "story-richang-2",
			flashout = {
				black = true,
				dur = 1,
				alpha = {
					0,
					1
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
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 304020,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Oh, good day, Commander and Miss Seattle.",
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
			actor = 304020,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Welcome to our dormitory. Please have a seat and I'll bring tea out to you shortly.",
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
			actor = 304020,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Here we are. Enjoy.",
			painting = {
				alpha = 0.3,
				time = 1
			},
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
			actor = 199010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Appreciate it!",
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
			bgName = "bg_story_room",
			actor = 199010,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Yat Sen, random question, but what brings you here?",
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
			actor = 502010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Oh, no reason in particular.",
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
			actor = 502010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "I just wanted to have a small chat with Hiei.",
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
			expression = 7,
			side = 2,
			bgName = "bg_story_room",
			actor = 199010,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "A chat, eh? Let's see, things you have in common... Is it about food?",
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
			actor = 304020,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Yes, in fact. We were discussing the canteen's menu for this upcoming week.",
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
			actor = 304020,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Would you remind me where we left off, Yat Sen?",
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
			actor = 502010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Of course. I brought up how some have complained that the vegetables were seasoned too strongly. Perhaps we could work out a menu with milder seasoning.",
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
			actor = 304020,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "But then, those who prefer a stronger taste may complain that it needs more seasoning. Accounting for everyone's tastes is a tall order, I'm afraid...",
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
			actor = 502010,
			nameColor = "#A9F548FF",
			bgName = "bg_story_room",
			side = 0,
			dir = 1,
			hideOther = true,
			actorName = "Yat Sen & Hiei",
			say = "......",
			subActors = {
				{
					actor = 304020,
					pos = {
						x = 1185
					}
				}
			},
			painting = {
				alpha = 0.3,
				time = 0
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_room",
			say = "It sounds like they're at an impasse.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			bgName = "bg_story_room",
			actor = 199010,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Hey, could I chime in for a sec?",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			action = {
				{
					type = "shake",
					y = 45,
					delay = 0,
					dur = 0.15,
					x = 0,
					number = 2
				}
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "bg_story_room",
			actor = 199010,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "It COULD be that people just aren't used to the seasoning itself, rather than how strong it is. Different strokes, and all that.",
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
			actor = 199010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "You can always experiment and see what people like. And I've got the perfect occasion for you to do it!",
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
			bgName = "bg_story_room",
			actor = 199010,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "See, I'm throwing a party with a multinational theme on our next holiday, and I'd like you two to do the catering!",
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
			actor = 199010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "You'll have people from all different factions trying your food, and you can use their feedback to find that seasoning sweet spot. Whaddya say?",
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
			actor = 502010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Interesting... That would let us figure out everyone's tastes to a more exact degree.",
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
			actor = 304020,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "It's the perfect solution. We'd be happy to assist.",
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
			actor = 199010,
			side = 2,
			bgName = "bg_story_room",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Aw yeah! I'm glad you're both on board!",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			action = {
				{
					type = "shake",
					y = 45,
					delay = 0,
					dur = 0.15,
					x = 0,
					number = 2
				}
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "bg_story_room",
			actor = 199010,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "That's that solved. Let's see if we can recruit some more peeps, Commander!",
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
