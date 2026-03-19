return {
	fadeOut = 1.5,
	mode = 2,
	defaultTb = 3003,
	id = "TANSUOZHELAIFANGJISHI2",
	placeholder = {
		"tb"
	},
	scripts = {
		{
			actor = 1102010,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "They're blooming so beautifully... Oh! Commander! Welcome. I see you brought Lora with you.",
			bgm = "qe-ova-3",
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
			actor = -2,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			side = 2,
			actorName = "Lora",
			say = "You always look so focused when you're dealing with plants, Zeven...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 1102010,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Why, yes, because you need to take good care of plants, just like any other living thing.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "(Ask her if she was talking to the flowers.)",
					flag = 1
				}
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "(Ask her if she was talking to the flowers.)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 1102010,
			say = "That I was. These tulips were just replanted, so I need to be especially careful with them, you see.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 1102010,
			say = "Each and every flower possesses a unique growth rhythm, so you need to patiently observe and gently look after them.",
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
			actor = 1102010,
			say = "If you speak to them a lot, they'll respond by blooming in the most beautiful way. Say, what do you think about this approach to cultivation, Commander?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "(Tell her she's talented at it.)",
					flag = 1
				},
				{
					content = "(Tell her she's very gentle.)",
					flag = 2
				}
			}
		},
		{
			portrait = "zhihuiguan",
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			optionFlag = 1,
			actor = 0,
			say = "One thing's for sure: You're really talented at looking after plants.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			portrait = "zhihuiguan",
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			optionFlag = 2,
			actor = 0,
			say = "You're a very gentle gardener, I can tell you that.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 1102010,
			say = "Thank you for your kind words.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 1102010,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Allow me to thank you by offering you some freshly brewed flower tea.",
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
			say = "De Zeven Provinciën picks up a small teapot next to her and pours two cups of tea.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = -2,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			side = 2,
			actorName = "Lora",
			say = "Even if you're only doing what you're good at... it really makes me feel at ease...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = -2,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			xpression = 6,
			side = 2,
			actorName = "Lora",
			say = "Patiently talking to the flowers, looking for just the right way to care for them...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 6,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			actor = -2,
			actorName = "Lora",
			nameColor = "#A9F548FF",
			say = "Taking your time, slowly getting closer little by little... Could that be the key to making {tb} and me feel comfortable with each other?",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 1102010,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Well, the principles behind growing flowers and raising a child are actually quite similar.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 1102010,
			side = 2,
			bgName = "star_level_bg_706",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "You might be surprised to learn that I'm actually quite good at these things.",
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
			actor = 1102010,
			say = "Ah, I'd better get back to tending some of my other flowers now...",
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
			actor = 1102010,
			say = "Feel free to stay and watch, if you'd like!",
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
			say = "After staying to observe the garden for a while, Lora and I turn and leave.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
