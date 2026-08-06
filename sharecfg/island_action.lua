pg = pg or {}
pg.island_action = rawget(pg, "island_action") or setmetatable({
	__name = "island_action"
}, confNEO)
pg.island_action.all = {
	1000,
	1001,
	1002,
	1003,
	1004,
	1005,
	1006,
	1007,
	1008,
	1009,
	1011,
	1012,
	1013,
	1014,
	1015,
	1016,
	1017,
	1018,
	1019,
	1020,
	1021,
	1022,
	1023,
	1024,
	1025,
	1026,
	1027,
	1028,
	1029,
	1030,
	2000,
	2001,
	2002,
	2003,
	2004,
	2005,
	2006
}
pg.island_action.get_id_list_by_type = {
	{
		1000,
		1001,
		1002,
		1003,
		1004,
		1005,
		1006,
		1007,
		1008,
		1009,
		1011,
		1012,
		1013,
		1014,
		1015,
		1016,
		1017,
		1018,
		1019,
		1020,
		1021,
		1022,
		1023,
		1024,
		1025,
		1026,
		1027,
		1028,
		1029,
		1030
	},
	{
		2000,
		2001,
		2002,
		2003,
		2004,
		2005,
		2006
	}
}
pg.base = pg.base or {}
pg.base.island_action = {}

;(function()
	pg.base.island_action[1000] = {
		sigle_action_reply_type = 2,
		name = "Greet",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Greet], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "hi",
		id = 1000,
		responder_feedback = "",
		chara_sigle_action_reply = {
			101,
			102,
			104
		},
		jump_page = {}
	}
	pg.base.island_action[1001] = {
		sigle_action_reply_type = 2,
		name = "Goodbye",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Goodbye], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "bye",
		id = 1001,
		responder_feedback = "",
		chara_sigle_action_reply = {
			101
		},
		jump_page = {}
	}
	pg.base.island_action[1002] = {
		sigle_action_reply_type = 2,
		name = "Nod",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Nod], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "nod",
		id = 1002,
		responder_feedback = "",
		chara_sigle_action_reply = {
			103,
			105
		},
		jump_page = {}
	}
	pg.base.island_action[1003] = {
		sigle_action_reply_type = 2,
		name = "Shake Head",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Shake Head], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "shakehead",
		id = 1003,
		responder_feedback = "",
		chara_sigle_action_reply = {
			202,
			207
		},
		jump_page = {}
	}
	pg.base.island_action[1004] = {
		sigle_action_reply_type = 2,
		name = "Clap",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Clap], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "clap",
		id = 1004,
		responder_feedback = "",
		chara_sigle_action_reply = {
			103,
			105
		},
		jump_page = {}
	}
	pg.base.island_action[1005] = {
		sigle_action_reply_type = 2,
		name = "Praise the Sun",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Praise the Sun], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "handsup",
		id = 1005,
		responder_feedback = "",
		chara_sigle_action_reply = {
			204,
			207
		},
		jump_page = {
			{
				"星彩奖",
				{}
			}
		}
	}
	pg.base.island_action[1006] = {
		sigle_action_reply_type = 2,
		name = "Hands on Hips",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Hands on Hips], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "akimbo",
		id = 1006,
		responder_feedback = "",
		chara_sigle_action_reply = {
			106
		},
		jump_page = {}
	}
	pg.base.island_action[1007] = {
		sigle_action_reply_type = 2,
		name = "Bow",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Bow], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "bow",
		id = 1007,
		responder_feedback = "",
		chara_sigle_action_reply = {
			105,
			204
		},
		jump_page = {
			{
				"Island Collection",
				{}
			}
		}
	}
	pg.base.island_action[1008] = {
		sigle_action_reply_type = 2,
		name = "Excited Jump",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Excited Jump], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "vjump",
		id = 1008,
		responder_feedback = "",
		chara_sigle_action_reply = {
			106,
			204
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1009] = {
		sigle_action_reply_type = 2,
		name = "Stamp Feet",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Stamp Feet], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "stomp",
		id = 1009,
		responder_feedback = "",
		chara_sigle_action_reply = {
			201,
			207
		},
		jump_page = {}
	}
	pg.base.island_action[1011] = {
		sigle_action_reply_type = 2,
		name = "Flaunt Muscles",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Flaunt Muscles], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "muscle",
		id = 1011,
		responder_feedback = "",
		chara_sigle_action_reply = {
			106,
			204
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1012] = {
		sigle_action_reply_type = 2,
		name = "Dance",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Character action to [Dance], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "dance",
		id = 1012,
		responder_feedback = "",
		chara_sigle_action_reply = {
			106,
			204
		},
		jump_page = {
			{
				"星彩奖",
				{}
			}
		}
	}
	pg.base.island_action[1013] = {
		sigle_action_reply_type = 2,
		name = "The Hero is Here",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "The hero is here! Express your style and enthusiasm to the world.",
		tech_id = 0,
		resource = "herocoming",
		id = 1013,
		responder_feedback = "",
		chara_sigle_action_reply = {
			204,
			207
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1014] = {
		sigle_action_reply_type = 2,
		name = "Stretch",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Stretch",
		tech_id = 0,
		resource = "stretch",
		id = 1014,
		responder_feedback = "",
		chara_sigle_action_reply = {
			207
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1015] = {
		sigle_action_reply_type = 2,
		name = "Cower",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Cower",
		tech_id = 0,
		resource = "fearshake",
		id = 1015,
		responder_feedback = "",
		chara_sigle_action_reply = {
			201,
			207
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1016] = {
		sigle_action_reply_type = 2,
		name = "Clench Fists",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Clench Fists",
		tech_id = 0,
		resource = "holdfist",
		id = 1016,
		responder_feedback = "",
		chara_sigle_action_reply = {
			103,
			107
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1017] = {
		sigle_action_reply_type = 2,
		name = "Smug",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Smug",
		tech_id = 0,
		resource = "vouch",
		id = 1017,
		responder_feedback = "",
		chara_sigle_action_reply = {
			106,
			108
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1018] = {
		sigle_action_reply_type = 2,
		name = "Meditate",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Meditate",
		tech_id = 0,
		resource = "float",
		id = 1018,
		responder_feedback = "",
		chara_sigle_action_reply = {
			106,
			108
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[1019] = {
		sigle_action_reply_type = 2,
		name = "Refuse",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Refuse",
		tech_id = 0,
		resource = "refuse",
		id = 1019,
		responder_feedback = "",
		chara_sigle_action_reply = {
			204,
			207
		},
		jump_page = {
			{
				"Season Ⅲ - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1020] = {
		sigle_action_reply_type = 2,
		name = "Yawn",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Yawn",
		tech_id = 0,
		resource = "yawn",
		id = 1020,
		responder_feedback = "",
		chara_sigle_action_reply = {
			108,
			207
		},
		jump_page = {
			{
				"Season Ⅲ - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1021] = {
		sigle_action_reply_type = 2,
		name = "Wipe Sweat",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Wipe Sweat",
		tech_id = 0,
		resource = "wipingsweat",
		id = 1021,
		responder_feedback = "",
		chara_sigle_action_reply = {
			204
		},
		jump_page = {
			{
				"Season Ⅲ - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1022] = {
		sigle_action_reply_type = 2,
		name = "Scratch Head",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Scratch Head",
		tech_id = 0,
		resource = "scratchinghead",
		id = 1022,
		responder_feedback = "",
		chara_sigle_action_reply = {
			105,
			106
		},
		jump_page = {
			{
				"Season Ⅲ - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1023] = {
		sigle_action_reply_type = 2,
		name = "Shoot Hoops",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Shoot Hoops",
		tech_id = 0,
		resource = "shootingbasketball",
		id = 1023,
		responder_feedback = "",
		chara_sigle_action_reply = {
			102,
			106
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[1024] = {
		sigle_action_reply_type = 2,
		name = "Blow Kiss",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Blow Kiss",
		tech_id = 0,
		resource = "blowkisses",
		id = 1024,
		responder_feedback = "",
		chara_sigle_action_reply = {
			102,
			104,
			105
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[1025] = {
		sigle_action_reply_type = 2,
		name = "Point",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Point",
		tech_id = 0,
		resource = "point",
		id = 1025,
		responder_feedback = "",
		chara_sigle_action_reply = {
			105,
			204
		},
		jump_page = {
			{
				"Season IV - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1026] = {
		sigle_action_reply_type = 2,
		name = "Greet",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Greet",
		tech_id = 0,
		resource = "welcome",
		id = 1026,
		responder_feedback = "",
		chara_sigle_action_reply = {
			102,
			107
		},
		jump_page = {
			{
				"Season IV - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1027] = {
		sigle_action_reply_type = 2,
		name = "Stare",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Stare",
		tech_id = 0,
		resource = "lookover",
		id = 1027,
		responder_feedback = "",
		chara_sigle_action_reply = {
			105,
			201
		},
		jump_page = {
			{
				"Season IV - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1028] = {
		sigle_action_reply_type = 2,
		name = "Stuffed",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Stuffed",
		tech_id = 0,
		resource = "slapbelly",
		id = 1028,
		responder_feedback = "",
		chara_sigle_action_reply = {
			106,
			207
		},
		jump_page = {
			{
				"Season IV - Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[1029] = {
		sigle_action_reply_type = 2,
		name = "Sleepy",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Sleepy",
		tech_id = 0,
		resource = "doze",
		id = 1029,
		responder_feedback = "",
		chara_sigle_action_reply = {
			103,
			108
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[1030] = {
		sigle_action_reply_type = 2,
		name = "Jump",
		respond_point = "",
		type = 1,
		feedback_type = 1,
		desc = "Action - Jump",
		tech_id = 0,
		resource = "jumpinplace",
		id = 1030,
		responder_feedback = "",
		chara_sigle_action_reply = {
			103,
			104
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[2000] = {
		chara_sigle_action_reply = "",
		name = "High Five",
		sigle_action_reply_type = 0,
		type = 2,
		feedback_type = 0,
		desc = "Character action to [High Five], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "givemefive",
		id = 2000,
		responder_feedback = "givemefive_end",
		respond_point = {
			0.07173,
			0,
			1.28364
		},
		jump_page = {}
	}
	pg.base.island_action[2001] = {
		chara_sigle_action_reply = "",
		name = "Shake Hands",
		sigle_action_reply_type = 0,
		type = 2,
		feedback_type = 0,
		desc = "Character action to [Shake Hands], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "handshake",
		id = 2001,
		responder_feedback = "handshake_end",
		respond_point = {
			0.03018,
			0,
			1.35235
		},
		jump_page = {
			{
				"Island Seasonal Shop",
				{}
			}
		}
	}
	pg.base.island_action[2002] = {
		chara_sigle_action_reply = "",
		name = "Hug",
		sigle_action_reply_type = 0,
		type = 2,
		feedback_type = 0,
		desc = "Character action to [Hug], it shows the character's emotion and attitude.",
		tech_id = 0,
		resource = "hug",
		id = 2002,
		responder_feedback = "hug_end",
		respond_point = {
			0.05431,
			0,
			0.62654
		},
		jump_page = {
			{
				"星彩奖",
				{}
			}
		}
	}
	pg.base.island_action[2003] = {
		chara_sigle_action_reply = "",
		name = "Celebrate",
		sigle_action_reply_type = 0,
		type = 2,
		feedback_type = 0,
		desc = "Action - Celebrate",
		tech_id = 0,
		resource = "claphands",
		id = 2003,
		responder_feedback = "claphands_end",
		respond_point = {
			0,
			0,
			1.5276
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[2004] = {
		chara_sigle_action_reply = "",
		name = "Hand Heart",
		sigle_action_reply_type = 0,
		type = 2,
		feedback_type = 0,
		desc = "Action - Hand Heart",
		tech_id = 0,
		resource = "handheart",
		id = 2004,
		responder_feedback = "handheart_end",
		respond_point = {
			0,
			0,
			1.35224
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[2005] = {
		chara_sigle_action_reply = "",
		name = "Take a Bow",
		sigle_action_reply_type = 0,
		type = 2,
		feedback_type = 0,
		desc = "Action - Take a Bow",
		tech_id = 0,
		resource = "curtaincall",
		id = 2005,
		responder_feedback = "curtaincall_end_sp",
		respond_point = {
			0,
			0,
			2
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
	pg.base.island_action[2006] = {
		chara_sigle_action_reply = "",
		name = "Group Dance",
		sigle_action_reply_type = 0,
		type = 2,
		feedback_type = 0,
		desc = "Action - Group Dance",
		tech_id = 0,
		resource = "mutidance",
		id = 2006,
		responder_feedback = "mutidance_end",
		respond_point = {
			0,
			0,
			1.41529
		},
		jump_page = {
			{
				"Stellar Prize Draw",
				{}
			}
		}
	}
end)()
