return {
	fadeOut = 1.5,
	mode = 2,
	id = "LIEKEXINGDUN4",
	once = true,
	fadeType = 2,
	fadein = 1.5,
	scripts = {
		{
			stopbgm = true,
			mode = 1,
			sequence = {
				{
					"An Ode to the Sea\n\n<size=45>4 Man vs. Machine</size>",
					1
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_103",
			say = "Lexington and I take a stroll down the port's main road.",
			bgmDelay = 2,
			bgm = "story-richang-1",
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
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_103",
			say = "She's seemed strangely absent-minded since we left Princeton's room. I wonder why.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_103",
			say = "I again check the note I received, then weigh our options on what to do next.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_103",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "You know, I think Princeton is right about what she said about data.",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_103",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "It's only a probability, not a guarantee that people will like it. But I don't feel like that's fully solved my problem...",
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
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_103",
			say = "All of a sudden, I notice that the sun has set.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "\"It's gotten late.\"",
					flag = 1
				},
				{
					content = "\"How about we have dinner?\"",
					flag = 2
				}
			}
		},
		{
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_103",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 1,
			say = "Oh. Yes, it has. Time flies...",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_103",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 1,
			say = "Goodness, I took up your whole day, didn't I? Sorry, Commander.",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_103",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 1,
			say = "...Dinner, you say? I could use a light meal, actually. Let's go.",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_103",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 2,
			say = "Well, I suppose we're not finding the answer today, so we might as well.",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_103",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 2,
			say = "Besides, I could go for something to eat. Lead the way, Commander.",
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
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_165",
			say = "We go into the canteen to sate our hunger.",
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
			bgName = "star_level_bg_165",
			say = "As soon as we step through the door, we're greeted by a strange sight.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 501040,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Please stop, Fu Shun... Leave it be...",
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
			actor = 501020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Get out of the way! That cursed machine needs to be destroyed! It has no place in the canteen!",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Um... Excuse me, what's on the menu tonight?",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "I hope it's nothing offensive and that's what you're fighting over...",
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
			actor = 501020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Nah, this is about something much bigger than a menu item!",
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
			actor = 501020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "It's that damn cooking machine! It's a crime against humanity!",
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
			actor = 501010,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Aren't you being dramatic? It makes Yat Sen's job easier, simple as that.",
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
			actor = 501020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "But WE should be helping her cook! Having a machine do it is so boring! And I need an excuse to get up to kitchen hijinks, but that's unrelated.",
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
			},
			effects = {
				{
					active = true,
					name = "speed"
				}
			}
		},
		{
			actor = 501030,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "We could rework it into a homework-solving machine. Processed papers beat processed food.",
			painting = {
				alpha = 0.3,
				time = 1
			},
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "The canteen has to feed a lot of people, so isn't machine labor perfect in this scenario?",
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
			actor = 501030,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Hah. You're starting to sound like An Shan.",
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
			actor = 501030,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Sure, it lightens the burden on our cooks, but letting a machine make our food just feels... soulless. At least in my opinion.",
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
			actor = 501030,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Anyway, since we're at an impasse right now, there's not much on the menu to choose from. Here, and bon appetit.",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Thanks. Incidentally, did the machine prepare it?",
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
			actor = 501030,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Who knows. Human or machine, it should taste the same, no?",
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
					y = 0,
					delay = 0,
					dur = 0.4,
					x = 30,
					number = 2
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_165",
			say = "Looks like this debate in the canteen won't end any time soon.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_165",
			say = "All of a sudden, I notice that the sun has set.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "\"This got strangely philosophical.\"",
					flag = 1
				}
			}
		},
		{
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Mhm. I suppose they feel things made by a machine have no \"soul.\"",
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
			actor = 107020,
			side = 2,
			bgName = "star_level_bg_165",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "But the food does taste the same... So what actually matters...",
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
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_165",
			say = "Slowly but steadily, Lexington is getting closer to the answer she's looking for.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
