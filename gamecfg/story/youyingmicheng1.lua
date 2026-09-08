return {
	id = "YOUYINGMICHENG1",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			mode = 1,
			bgName = "star_level_bg_495",
			bgm = "story-darkplan",
			sequence = {
				{
					"",
					0
				}
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
			effects = {
				{
					active = true,
					name = "juqing_xiayu"
				}
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "star_level_bg_495",
			factiontag = "Manjuu Navigation Service",
			dir = 1,
			portrait = 900284,
			nameColor = "#A9F548FF",
			actorName = "TB",
			hidePaintObj = true,
			say = "You have deviated from your route. Please recalculate a route home.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			say = "A robotic voice echoed through the secluded alleyway as Z14 timidly pressed on, ever clutching her Little Ihn plushie.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			portrait = 900284,
			side = 2,
			bgName = "star_level_bg_495",
			factiontag = "Manjuu Navigation Service",
			dir = 1,
			nameColor = "#A9F548FF",
			actorName = "TB",
			hidePaintObj = true,
			say = "Nighttime Advisory: Do not enter poorly lit areas alone.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 401140,
			say = "I-I'll be fine... It's only for a minute.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 401140,
			side = 2,
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Urk... It's just an alleyway. Why does it feel so long?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			say = "BZZZZZT!",
			soundeffect = "event:/ui/didi",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 401140,
			side = 2,
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Eep?! A phone call? I thought I had my phone on silent...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 900559,
			nameColor = "#FF9B93",
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			dir = 1,
			actorName = "???",
			side = 2,
			say = "...%￥#...*^...？",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 5,
			side = 2,
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 401140,
			say = "Wh-who's there?",
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
			expression = 7,
			side = 2,
			bgName = "star_level_bg_495",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 401140,
			say = "Somebody... Help me! N-noooo!",
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
			blackBg = true,
			mode = 1,
			effects = {
				{
					active = true,
					name = "youyingmicheng"
				},
				{
					active = false,
					name = "juqing_xiayu"
				}
			},
			sequence = {
				{
					"",
					1
				}
			},
			flashout = {
				black = true,
				dur = 1,
				alpha = {
					0,
					1
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "The streets of New Era City No. 7 were an endless current of pedestrians. I stepped away from the crowd and entered the building that housed the Office of Paranormal Affairs.",
			bgm = "story-richang-visioncity",
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
			effects = {
				{
					active = false,
					name = "youyingmicheng"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "Morning rush hour had just passed, but the lobby was still full of people waiting for elevators. As I waited, I leafed through a document from City Hall, requesting a joint investigation into recent disappearances of young women.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Most of these disappearances occur at night. No apparent pattern to the locations.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Some of the scenes involved signal tampering, surveillance malfunctions, and dazed witnesses...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "Under normal standards, these would have been classified as missing persons incidents.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "But in this city, anything immediately unexplainable tends to get sent to the Office of Paranormal Affairs.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 202380,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			dir = 1,
			actorName = "???",
			side = 2,
			say = "The melody lingering about you... is just beautiful.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "star_level_bg_150",
			actorName = "???",
			dir = 1,
			actor = 202380,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Lost in thought, are we?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "A woman floating behind me drifts closer and gazes at me with smiling eyes.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "Nobody around us glances our way. It's as if nothing out of the ordinary is happening at all.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Poltergeist",
			dir = 1,
			actorName = "???",
			actor = 202380,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I can confirm one thing for you: it's the doing of my kind – another poltergeist.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Why? Did you hear something?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 202380,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Poltergeist",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "To put it in terms you'd understand, there are traces of a poltergeist left at the scene.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 202380,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Poltergeist",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "But to me, it seemed more of a... discordant melody.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Poltergeist",
			dir = 1,
			actor = 202380,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Either way, they're being unusually active.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "Tiger languidly runs her fingers through her hair. The tips of her long strands seem almost ethereal, only truly becoming \"corporeal\" when she speaks.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "This isn't the best place to talk. Let's go upstairs first – the elevator's this way.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "As the elevator arrives, an unusually spirited voice rings out from inside.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Haaaah! Take this, evil poltergeist! This is for the sake of everybody's happy future!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Bliss Breathing, First Form: Last-Second Power Up!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "The moment the doors open, somebody lunges out with closed eyes and a fierce expression, smacking me square between the eyes with a rolled-up pamphlet.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "...Huh?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Whaaaaa?!",
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
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			say = "Realizing she'd actually hit something, the assailant opens her eyes and turns bright red. Frantically, she hides the pamphlet behind her back.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "L-l-listen, that wasn't, um... that wasn't me... I mean, it WAS me, okay, but I wasn't thinking straight, alright?!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "I have no idea what you're talking about.",
					flag = 1
				},
				{
					content = "Let's try to avoid friendly fire, okay?",
					flag = 2
				}
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
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			optionFlag = 1,
			actor = 201210,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Th-thank goodness! I'm glad we can move past that...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			optionFlag = 2,
			actor = 201210,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I'm very sorry... Please forget that happened! I'm begging you!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			fontsize = 24,
			actor = 201210,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Ugh... Sorry. I panicked because I came to the wrong floor...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Huh? Aren't you the girl who joined after the telephone booth incident?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			portrait = "zhihuiguan",
			side = 2,
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			actor = 0,
			say = "This is the Office of Paranormal Affairs. Describe your location and the nature of your problem.",
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
			},
			effects = {
				{
					active = true,
					name = "memoryFog"
				}
			}
		},
		{
			paintingNoise = true,
			side = 2,
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 201210,
			say = "Please, help me! I ran into a shadowy monster, and it's been chasing me ever since! I'm hiding in a phone booth right now, but it's still around!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_150",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "My name is Javelin! I'm hardworking and diligent, and I'll do whatever it takes to work for you! I look forward to working with you!",
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
			},
			effects = {
				{
					active = false,
					name = "memoryFog"
				}
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "I'm the Commander of the Office of Paranormal Affairs. Good to have you.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_150",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Let me show you to the right floor.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			side = 2,
			actorName = "PA System",
			bgName = "bg_story_task",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			say = "Arriving at the 9th floor.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
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
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task",
			hidePaintObj = true,
			say = "The elevator door opens, and the last few yawning office workers exit.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "bg_story_task",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Umm... Commander, isn't this the top floor?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_story_task",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Yeah. We're going higher, though.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "bg_story_task",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Huh...?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task",
			hidePaintObj = true,
			say = "I press the 9 button on the panel a few more times. After a moment, the elevator ceases its descent and shudders slightly.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task",
			hidePaintObj = true,
			say = "The floor display does not change, but we continue to rise silently toward a higher floor.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "bg_story_task",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "There are hidden floors?!",
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
			expression = 8,
			side = 2,
			bgName = "bg_story_task",
			factiontag = "Poltergeist",
			dir = 1,
			actor = 202380,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Heehee. Isn't she cute?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "bg_story_task",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Thank you very... Huh?! C-Commander, there's someone b-behind you...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "bg_story_task",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Don't be afraid. She's been there this whole time – you just couldn't see her. Her name is Tiger.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "bg_story_task",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I-it's a pleasure to meet you, ma'am! My name is Javelin! I look forward to working with you!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task",
			hidePaintObj = true,
			say = "A few seconds later, the elevator dings, and the door opens. Thus, Javelin catches her first glimpse of another side of this world.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Huh... It's kinda normal.",
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
			flashin = {
				delay = 1,
				dur = 1,
				black = false,
				alpha = {
					1,
					0
				}
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "There aren't any magic circles or weird specimens wriggling about... I guess I expected it to look like a secret organization's hideout.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Even secret organizations have budgets.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			say = "After completing her registration, I hand her a new ID badge and uniform.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Change into this uniform, and you'll officially be an operative. Sorry to put you to work already, but you'll have to go to the orientation room for onboarding.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Change?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			say = "She looks down at her uniform and falls silent for a moment.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I-it's a little... flashy, for a uniform.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I mean, if anything, it looks more like a magical girl outfit!",
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
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "It's a standard-issue uniform.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "But it has RIBBONS!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "All the easier to identify you.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Explain the heart-shaped charm!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Also for identification purposes.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "What about this wand, then? What could it POSSIBLY be for other than to be cute?!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_496",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "That's... actually not for identification purposes. It's for self-defense.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201210,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "What the heck is with this place?!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			actor = 231211,
			stopbgm = true,
			hidePaintObj = true,
			say = "I-I think this should be good...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
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
			location = {
				"Orientation Room",
				3
			}
		},
		{
			expression = 8,
			side = 2,
			bgName = "star_level_bg_496",
			factiontag = "Newbie Operative",
			dir = 1,
			soundeffect = "event:/ui/knockdoor1",
			actor = 231211,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Umm, pardon me!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_603",
			hidePaintObj = true,
			say = "The orientation room was dimmer than the outside, with its curtains drawn tightly. The only illumination came from a few pendant lights.",
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
			expression = 2,
			side = 2,
			bgName = "star_level_bg_603",
			factiontag = "Newbie Operative",
			dir = 1,
			actor = 231211,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "(What the...? Is this how orientation rooms normally are?)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 301192,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_603",
			side = 2,
			withoutActorName = true,
			hideRecordIco = true,
			say = "A young girl sat in the middle of the room, head hanging over a desk. Her long hair covered most of her face.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 7,
			side = 2,
			bgName = "star_level_bg_603",
			factiontag = "Newbie Operative",
			dir = 1,
			actor = 231211,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Umm... Hi there?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 301192,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_603",
			side = 2,
			withoutActorName = true,
			hideRecordIco = true,
			say = "Noticing Javelin's presence, she slowly scratched a coin across the desk, creating a grating sound.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 301192,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_603",
			side = 2,
			withoutActorName = true,
			hideRecordIco = true,
			say = "Once the coin reached the edge of the desk...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 301191,
			side = 2,
			bgName = "star_level_bg_603",
			hideRecordIco = true,
			withoutActorName = true,
			nameColor = "#A9F548FF",
			say = "Two ghostly flames flared into existence, bathing the room in a terrifying red glow. The girl suddenly spoke.",
			bgm = "theme-akagi-inside",
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
			actor = 301191,
			nameColor = "#FF9B93",
			bgName = "star_level_bg_603",
			factiontag = "Poltergeist",
			dir = 1,
			side = 2,
			actorName = "???",
			say = "...Heheh... ￥#&￥... Sacrifice...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "star_level_bg_603",
			factiontag = "Poltergeist",
			dir = 1,
			actorName = "???",
			actor = 301191,
			nameColor = "#FF9B93",
			say = "^&#&￥... All mine...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 2,
			side = 2,
			bgName = "star_level_bg_603",
			factiontag = "Newbie Operative",
			dir = 1,
			actor = 231211,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "EEEEK!",
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
		}
	}
}
