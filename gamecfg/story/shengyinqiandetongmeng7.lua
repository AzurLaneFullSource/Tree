return {
	id = "SHENGYINQIANDETONGMENG7",
	mode = 2,
	fadeOut = 1.5,
	scripts = {
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "storymap_lianhediguo",
			hidePaintObj = true,
			say = "The next day, the four freelancers joined us on the Tribunal's Hand. We arrived at the Regensburg City entrance to the divine waterways.",
			bgm = "theme-hrr",
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
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "Though called divine by the locals, they were really a network of canals left by the Antiochus.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_2"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "This canal network did more than just connect the Empire's major cities – it also featured various so-called \"divine relays\" along its route, aiding in long-distance communication.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_2"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "Large, high-speed transport vessels were positioned within as well. Since the Tribunal's Hand fit inside, we opted to travel that way.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_2"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "The waterways were technically owned by the Emperor of the Holy Unitas Empire.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_2"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "However, management of them was delegated to specific people.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_2"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "Regardless of these details, traveling from Regensburg City to Brandenburg meant passing through three other cities.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_3"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "These were Strasbourg City, Mainz City, and Magdeburg City, in order.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_3",
					"1_4"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "Based on our speed so far, we would reach Strasbourg City this evening.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_3",
					"1_4",
					"1_5"
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			say = "There, we would rendezvous with U-2501 and Z15 to bring them along.",
			hidePaintObj = true,
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			},
			canMarkNode = {
				"storymap_lianhediguo",
				{
					"1_1",
					"1_3",
					"1_4",
					"1_5",
					"1_6"
				}
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "star_level_bg_518",
			hidePaintObj = true,
			dir = 1,
			nameColor = "#A9F548FF",
			actor = 102160,
			say = "Commander, we've received confirmation that the route ahead is clear. We may launch the transport ship now.",
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
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_518",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "Then let's set sail for our next destination.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			mode = 1,
			stopbgm = true,
			asideType = 3,
			blackBg = true,
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
			sequence = {
				{
					"Holy Unitas Empire",
					1
				},
				{
					"Strasbourg City",
					2
				},
				{
					"Evening",
					3
				}
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			say = "The transport ship arrives at Strasbourg City, bathed in evening light.",
			bgm = "story-hrr",
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
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			say = "Elbe, the person in charge of this waterway, comes to greet us at the entrance. U-2501 and Z15 are with her.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			nameColor = "#A9F548FF",
			side = 2,
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			say = "Unfortunately, they come with bad tidings.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 401150,
			side = 2,
			bgName = "star_level_bg_557",
			factiontag = "Holy Unitas Empire",
			dir = 1,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "We finished our investigation, everyone!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 3,
			side = 2,
			bgName = "star_level_bg_557",
			factiontag = "Holy Unitas Empire",
			dir = 1,
			actor = 401150,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "The state of the netherworld is, uh... not great!",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 8,
			side = 2,
			bgName = "star_level_bg_557",
			factiontag = "Holy Unitas Empire",
			dir = 1,
			actor = 401150,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "U-2501 discovered enemies preparing for a big attack underwater.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 4,
			side = 2,
			bgName = "star_level_bg_557",
			factiontag = "Holy Unitas Empire",
			dir = 1,
			actor = 401150,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "There lurks something even more ominous deeper below...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 9706050,
			side = 2,
			bgName = "star_level_bg_557",
			factiontag = "Holy Unitas Empire",
			dir = 1,
			nameColor = "#FFC960",
			hidePaintObj = true,
			say = "Ugh... As if we didn't have enough trouble on our hands.",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			expression = 1,
			side = 2,
			bgName = "star_level_bg_557",
			factiontag = "Holy Unitas Empire",
			dir = 1,
			actor = 408150,
			nameColor = "#A9F548FF",
			hidePaintObj = true,
			say = "I'm sorry we couldn't bring better news...",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "(Something more ominous deep below, huh?)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "(During the World Expo, Marco Polo was setting up something underwater, too...)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "(That was why enemies kept appearing endlessly.)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "(As I recall...)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "(Hmm... She was converting the phenomenon of \"faith\" into a physical entity, was it?)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		},
		{
			actor = 0,
			nameColor = "#A9F548FF",
			bgName = "star_level_bg_557",
			hidePaintObj = true,
			side = 2,
			portrait = "zhihuiguan",
			say = "(I wonder if something similar is at work here.)",
			typewriter = {
				speed = 0.05,
				speedUp = 0.01
			}
		}
	}
}
