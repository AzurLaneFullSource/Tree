return {
	id = "YONGZHEDELVTU2",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			side = 2,
			nameColor = "#A9F548FF",
			bgm = "story-richang-2",
			say = "Village - Outskirts",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "A villager came to the party with a quest to eliminate a group of imps damaging her crops. The party set off at once.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			nameColor = "#A9F548FF",
			side = 2,
			actor = 131171,
			dir = 1,
			say = "My MP has fully recovered... You're going down, imps...",
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
			actorName = "System",
			nameColor = "#A9F548FF",
			say = "LAFFEY cast EXPLOSION! IMP A took 999 DMG! IMP A was defeated!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			dialogShake = {
				speed = 0.09,
				x = 8.5,
				number = 2
			}
		},
		{
			side = 2,
			actorName = "System",
			nameColor = "#A9F548FF",
			say = "LAFFEY cast EXPLOSION! IMP B took 999 DMG! IMP B was defeated!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			dialogShake = {
				speed = 0.09,
				x = 8.5,
				number = 2
			}
		},
		{
			side = 2,
			actorName = "System",
			nameColor = "#A9F548FF",
			say = "...LAFFEY cast EXPLOSION! IMP Z took 999 DMG! IMP Z was defeated!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			dialogShake = {
				speed = 0.09,
				x = 8.5,
				number = 2
			}
		},
		{
			side = 2,
			actorName = "System",
			nameColor = "#A9F548FF",
			say = "Quest \"IMPS IN THE FIELD\" complete. You received 100G and VILLAGER'S MEAL!",
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
			side = 2,
			actorName = "System",
			nameColor = "#A9F548FF",
			say = "MAGE LAFFEY leveled up to LV 50!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			nameColor = "#A9F548FF",
			side = 2,
			actor = 131171,
			dir = 1,
			say = "Commission... complete...",
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
			actor = 131171,
			side = 2,
			nameColor = "#A9F548FF",
			dir = 1,
			say = "I'm all out of MP... You'll have to take it from here... Goodnight... Zzzzz...",
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
