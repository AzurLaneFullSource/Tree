return {
	fadeOut = 1.5,
	mode = 2,
	id = "LIEKEXINGDUN1",
	once = true,
	fadeType = 2,
	fadein = 1.5,
	scripts = {
		{
			stopbgm = true,
			mode = 1,
			sequence = {
				{
					"An Ode to the Sea\n\n<size=45>1 Another Day, Another Prank</size>",
					1
				}
			}
		},
		{
			bgm = "story-richang-1",
			side = 2,
			bgName = "bg_story_task_2",
			hidePaintObj = true,
			nameColor = "#A9F548FF",
			bgmDelay = 2,
			say = "(knock knock)",
			soundeffect = "event:/ui/knockdoor2",
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
			expression = 3,
			side = 2,
			bgName = "bg_story_task_2",
			actor = 107030,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Oh, that's gotta be Lex!",
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
			bgName = "bg_story_task_2",
			actor = 107030,
			dir = 1,
			nameColor = "#A9F548FF",
			say = "Which means I'd better skedaddle now. Remember: play along, Commander!",
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
			bgName = "bg_story_task_2",
			say = "Outside my open window, Saratoga's voice fades into the distance.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task_2",
			say = "She rigged my door with some kind of contraption before she left. I wonder what that's about.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 107020,
			side = 2,
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Commander, was that Sara I just– Aahh!",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Seems I got my answer. She was here indeed...",
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
			bgName = "bg_story_task_2",
			say = "Lexington set off the contraption, showering her in colorful party ribbons. They make her look like an ornate Christmas tree.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task_2",
			say = "It's a warm welcome in Saratoga's book of mischief.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "bg_story_task_2",
			say = "......",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "\"Need a hand?\"",
					flag = 1
				},
				{
					content = "\"I'll get the blow dryer.\"",
					flag = 2
				}
			}
		},
		{
			actor = 107020,
			side = 2,
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 1,
			say = "Thanks, but I'll be fine.",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 1,
			say = "Oh, you have a blow dryer ready? Okay, then on second thought, by all means.",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			optionFlag = 2,
			say = "Please do. Sara's pranks must be relentless for you to keep a blow dryer lying around the office...",
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
			bgName = "bg_story_task_2",
			say = "After a few long minutes, I finally manage to dig Lexington out from the mound of ribbons.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 107020,
			side = 2,
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "I understand her love for pranks. I just wish they weren't always so excessive...",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "You'll have to forgive her for this mess, Commander. I'll clean it up at once.",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "...Hm? Are you sure?",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "So she set this prank up for me, not for you... I see.",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Knowing her, she must've thought I'm bummed out and she wanted to cheer me up. She worries too much.",
			painting = {
				alpha = 0.3,
				time = 1
			},
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			options = {
				{
					content = "\"Changing subjects... How about tea later this afternoon?\"",
					flag = 1
				}
			}
		},
		{
			actor = 107020,
			side = 2,
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Why the sudden invitation? Don't tell me you're worried about me as well. Nothing's wrong, honestly.",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "...You insist that I come? Well, I've never tried your tea before, so...",
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
			bgName = "bg_story_task_2",
			nameColor = "#A9F548FF",
			dir = 1,
			say = "Alright, we'll have tea later.",
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
