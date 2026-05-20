return {
	id = "SHEHUAXIANGMENGFUJINWAN20",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			stopbgm = true,
			mode = 1,
			sequence = {
				{
					"The Opulent! The Glamorous! Luxury Bay!\n\n<size=45>20 Where the Seagulls Go</size>",
					1
				}
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "star_level_bg_706",
			dir = 1,
			bgm = "story-richang-1",
			actor = 408130,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Did you find anything, L'Indomptable?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			location = {
				"Beach – Pier",
				3
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
			expression = 3,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 901130,
			say = "Just some feathers, bird droppings, a chocolate wrapper, some glass beads, a half-eaten potato...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 901130,
			say = "But not a trace of the Star of Luxury! Are you sure we can find it in the bird nest?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 901130,
			say = "Arghhh... I should have known better than listen to you, Gallant! Now I'm covered in feathers with no jewel to show for my troubles!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201390,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "But the book I read says birds are drawn to sparkly things!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 201390,
			say = "And it disappeared from all the way up there... So it had to have been a bird!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "That's certainly plausible, given the situation.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			say = "I approach the three and help pluck the feathers clinging to their hair.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201390,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "See, the Commander agrees with me! Let's keep looking through the nests –",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 408130,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Wait! Everyone, look up!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 408130,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "The seagulls... They're all going in the same direction!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 201390,
			say = "Maybe something's happening there. Let's check it out!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_660",
			hidePaintObj = false,
			say = "We follow the flock of seagulls to an outdoor pool.",
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
			expression = 2,
			side = 2,
			bgName = "star_level_bg_660",
			dir = 1,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = false,
			say = "Ugh... I already gave you all my fries... I've got nothing left...",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 5,
			side = 2,
			bgName = "star_level_bg_660",
			withoutActorName = true,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = false,
			say = "Z14 is trembling with tears in her eyes, circled by the flock of seagulls.",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 5,
			side = 2,
			bgName = "star_level_bg_660",
			portrait = 201390,
			dir = 1,
			nameColor = "#A9F548FF",
			actorScale = 1.1,
			actor = 401141,
			actorName = "Gallant",
			hidePaintObj = false,
			say = "Z14 is in trouble! Everyone, we gotta help her!",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			portrait = 201390,
			side = 2,
			bgName = "star_level_bg_660",
			expression = 5,
			dir = 1,
			actorName = "Gallant",
			actorScale = 1.1,
			soundeffect = "event:/ui/koushao",
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = false,
			say = "Fwee-fwee! Alert, alert!",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 5,
			side = 2,
			bgName = "star_level_bg_660",
			portrait = 201390,
			dir = 1,
			nameColor = "#A9F548FF",
			actorScale = 1.1,
			actor = 401141,
			actorName = "Gallant",
			hidePaintObj = false,
			say = "Disturbing peace and order is strictly forbidden!",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_660",
			withoutActorName = true,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = false,
			say = "Blowing her whistle, Gallant waves her hands around, startling the seagulls and making them fly off in a flutter of feathers.",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_660",
			hideOther = true,
			dir = 1,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Th-thanks... You saved me...",
			actorPosition = {
				x = 0,
				y = -100
			},
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
			actor = 201390,
			side = 2,
			bgName = "star_level_bg_660",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "You're very welcome! Ensuring everyone's peace and safety is the security team's duty and mission!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 11,
			side = 2,
			bgName = "star_level_bg_660",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 408130,
			say = "But... If the jewel isn't here, what did the seagulls come here for?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_660",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 201390,
			say = "Then, we should go back to investigating the bird nests!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_660",
			dir = 1,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Um... are you looking for a jewel?",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "star_level_bg_660",
			dir = 1,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Earlier, when the seagulls stole my fries, there were a few seagulls that wouldn't come near me...",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_660",
			dir = 1,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "They were all flocking around this big... gemstone?",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_660",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 901130,
			say = "A big gemstone? That's got to be the Star of Luxury!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "star_level_bg_660",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 408130,
			say = "Did you see where they were going?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_660",
			dir = 1,
			actorScale = 1.1,
			actor = 401141,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "Uh... I think they flew toward the Sea Breeze Hotel.",
			actorPosition = {
				x = 0,
				y = -100
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 201390,
			side = 2,
			bgName = "star_level_bg_660",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "All right! We finally got a new clue! Let's look into it!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_660",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Wait... How would a pack of seagulls carry a large gemstone...?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
