local var0 = class("CastleGameVo")

var0.game_id = nil
var0.hub_id = nil
var0.total_times = nil
var0.drop = nil
var0.game_bgm = "bar-soft"
var0.game_time = 90
var0.rule_tip = "uscastle2023_minigame_help"
var0.frameRate = Application.targetFrameRate or 60
var0.ui_atlas = "ui/minigameui/castlegameui_atlas"
var0.game_ui = "CastleGameUI"
var0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0.SFX_POINT_DOWN = "event:/ui/break_out_full"
var0.GAME_FAIL = "game fail"
var0.w_count = 6
var0.h_count = 6
var0.stone_broken_time = 1.5
var0.floor_remove_time = 3
var0.floor_revert_time = 3
var0.bubble_ready_time = 0.5
var0.bubble_broken_time = 4
var0.item_ready_time = 2
var0.char_speed = 380
var0.char_speed_min = 30
var0.score_remove_time = 8.5
var0.score_data = {
	{
		score = 200,
		speed = 50,
		time = 5,
		tpl = "chengbao_guangqiu_jin"
	},
	{
		score = 100,
		speed = 25,
		time = 5,
		tpl = "chengbao_guangqiu_zi"
	},
	{
		score = 50,
		speed = 10,
		time = 5,
		tpl = "chengbao_guangqiu_lan"
	}
}
var0.floor_rule = {
	{
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		12,
		13,
		14,
		15,
		16,
		17
	},
	{
		18,
		19,
		20,
		21,
		22,
		23,
		24,
		25,
		26,
		27,
		28,
		29,
		30,
		31,
		32,
		33,
		34,
		35
	},
	{
		7,
		8,
		9,
		10,
		13,
		16,
		19,
		22,
		25,
		26,
		27,
		28
	},
	{
		0,
		1,
		6,
		7,
		4,
		5,
		10,
		11,
		24,
		25,
		30,
		31,
		28,
		29,
		34,
		35
	},
	{
		2,
		3,
		8,
		9,
		12,
		13,
		14,
		15,
		16,
		17,
		18,
		19,
		20,
		21,
		22,
		23,
		26,
		27,
		32,
		33
	},
	{
		7,
		8,
		9,
		10,
		13,
		14,
		15,
		16,
		19,
		20,
		21,
		22,
		25,
		26,
		27,
		28
	},
	{
		12,
		13,
		16,
		17,
		18,
		19,
		22,
		23,
		24,
		25,
		28,
		29,
		30,
		31,
		32,
		33,
		34,
		35
	},
	{
		0,
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		10,
		11,
		14,
		15,
		20,
		21,
		26,
		27
	},
	{
		3,
		4,
		5,
		9,
		10,
		11,
		15,
		16,
		17,
		18,
		19,
		20,
		24,
		25,
		26,
		30,
		31,
		32
	},
	{
		0,
		1,
		2,
		6,
		7,
		8,
		12,
		13,
		14,
		21,
		22,
		23,
		27,
		28,
		29,
		33,
		34,
		35
	},
	{
		1,
		3,
		5,
		6,
		14,
		15,
		17,
		18,
		20,
		21,
		29,
		30,
		32,
		34
	},
	{
		0,
		5,
		7,
		10,
		14,
		15,
		20,
		21,
		25,
		28,
		30,
		35
	},
	{
		1,
		4,
		6,
		7,
		8,
		9,
		10,
		11,
		13,
		16,
		19,
		22,
		24,
		25,
		26,
		27,
		28,
		29,
		31,
		34
	}
}
var0.round_data = {
	{
		floors = {
			{
				time = 5,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 13,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 21,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 29,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 37,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 45,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 53,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 61,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 69,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 77,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 85,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			}
		},
		carriage = {
			34,
			42,
			50,
			58,
			66,
			74,
			82
		},
		stone = {
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		boom = {
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		score_time = {
			{
				time = 2,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 12,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 20,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 28,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 36,
				num = 18,
				score = {
					4,
					6,
					8
				}
			},
			{
				time = 44,
				num = 18,
				score = {
					4,
					6,
					8
				}
			},
			{
				time = 52,
				num = 18,
				score = {
					4,
					6,
					8
				}
			},
			{
				time = 60,
				num = 18,
				score = {
					4,
					6,
					8
				}
			},
			{
				time = 68,
				num = 18,
				score = {
					8,
					10,
					0
				}
			},
			{
				time = 76,
				num = 18,
				score = {
					8,
					10,
					0
				}
			},
			{
				time = 84,
				num = 18,
				score = {
					12,
					0,
					0
				}
			}
		},
		bubble_time = {
			{
				time = 8.5,
				num = 1
			},
			{
				time = 16.5,
				num = 1
			},
			{
				time = 24.5,
				num = 1
			},
			{
				time = 32.5,
				num = 1
			},
			{
				time = 40.5,
				num = 1
			},
			{
				time = 48.5,
				num = 1
			},
			{
				time = 56.5,
				num = 1
			},
			{
				time = 64.5,
				num = 2
			},
			{
				time = 72.5,
				num = 2
			},
			{
				time = 80.5,
				num = 2
			},
			{
				time = 88.5,
				num = 2
			}
		}
	},
	{
		floors = {
			{
				time = 5,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 13,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 21,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 29,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 37,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 45,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 53,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 61,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 69,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 77,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 85,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			}
		},
		carriage = {
			100
		},
		stone = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		boom = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		score_time = {
			{
				time = 2,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 12,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 20,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 28,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 36,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 44,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 52,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 60,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 68,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 76,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 84,
				num = 18,
				score = {
					2,
					4,
					12
				}
			}
		},
		bubble_time = {
			{
				time = 8.5,
				num = 2
			},
			{
				time = 16.5,
				num = 2
			},
			{
				time = 24.5,
				num = 2
			},
			{
				time = 32.5,
				num = 2
			},
			{
				time = 40.5,
				num = 2
			},
			{
				time = 48.5,
				num = 2
			},
			{
				time = 56.5,
				num = 2
			},
			{
				time = 64.5,
				num = 2
			},
			{
				time = 72.5,
				num = 2
			},
			{
				time = 80.5,
				num = 2
			},
			{
				time = 88.5,
				num = 2
			}
		}
	},
	{
		floors = {
			{
				time = 5,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 13,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 21,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 29,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 37,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 45,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 53,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 61,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 69,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 77,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 85,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			}
		},
		carriage = {
			100
		},
		stone = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		boom = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		score_time = {
			{
				time = 2,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 12,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 20,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 28,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 36,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 44,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 52,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 60,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 68,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 76,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 84,
				num = 18,
				score = {
					2,
					4,
					12
				}
			}
		},
		bubble_time = {
			{
				time = 8.5,
				num = 2
			},
			{
				time = 16.5,
				num = 2
			},
			{
				time = 24.5,
				num = 2
			},
			{
				time = 32.5,
				num = 2
			},
			{
				time = 40.5,
				num = 2
			},
			{
				time = 48.5,
				num = 2
			},
			{
				time = 56.5,
				num = 2
			},
			{
				time = 64.5,
				num = 2
			},
			{
				time = 72.5,
				num = 2
			},
			{
				time = 80.5,
				num = 2
			},
			{
				time = 88.5,
				num = 2
			}
		}
	},
	{
		floors = {
			{
				time = 5,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 13,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 21,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 29,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 37,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 45,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 53,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 61,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 69,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 77,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 85,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			}
		},
		carriage = {
			100
		},
		stone = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		boom = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		score_time = {
			{
				time = 2,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 12,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 20,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 28,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 36,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 44,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 52,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 60,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 68,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 76,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 84,
				num = 18,
				score = {
					2,
					4,
					12
				}
			}
		},
		bubble_time = {
			{
				time = 8.5,
				num = 2
			},
			{
				time = 16.5,
				num = 2
			},
			{
				time = 24.5,
				num = 2
			},
			{
				time = 32.5,
				num = 2
			},
			{
				time = 40.5,
				num = 2
			},
			{
				time = 48.5,
				num = 2
			},
			{
				time = 56.5,
				num = 2
			},
			{
				time = 64.5,
				num = 2
			},
			{
				time = 72.5,
				num = 2
			},
			{
				time = 80.5,
				num = 2
			},
			{
				time = 88.5,
				num = 2
			}
		}
	},
	{
		floors = {
			{
				time = 5,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 13,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 21,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 29,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 37,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 45,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 53,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 61,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 69,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 77,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 85,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			}
		},
		carriage = {
			100
		},
		stone = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		boom = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		score_time = {
			{
				time = 2,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 12,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 20,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 28,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 36,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 44,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 52,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 60,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 68,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 76,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 84,
				num = 18,
				score = {
					2,
					4,
					12
				}
			}
		},
		bubble_time = {
			{
				time = 8.5,
				num = 2
			},
			{
				time = 16.5,
				num = 2
			},
			{
				time = 24.5,
				num = 2
			},
			{
				time = 32.5,
				num = 2
			},
			{
				time = 40.5,
				num = 2
			},
			{
				time = 48.5,
				num = 2
			},
			{
				time = 56.5,
				num = 2
			},
			{
				time = 64.5,
				num = 2
			},
			{
				time = 72.5,
				num = 2
			},
			{
				time = 80.5,
				num = 2
			},
			{
				time = 88.5,
				num = 2
			}
		}
	},
	{
		floors = {
			{
				time = 5,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 13,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 21,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 29,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 37,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 45,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 53,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 61,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 69,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 77,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 85,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			}
		},
		carriage = {
			100
		},
		stone = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		boom = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		score_time = {
			{
				time = 2,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 12,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 20,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 28,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 36,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 44,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 52,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 60,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 68,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 76,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 84,
				num = 18,
				score = {
					2,
					4,
					12
				}
			}
		},
		bubble_time = {
			{
				time = 8.5,
				num = 2
			},
			{
				time = 16.5,
				num = 2
			},
			{
				time = 24.5,
				num = 2
			},
			{
				time = 32.5,
				num = 2
			},
			{
				time = 40.5,
				num = 2
			},
			{
				time = 48.5,
				num = 2
			},
			{
				time = 56.5,
				num = 2
			},
			{
				time = 64.5,
				num = 2
			},
			{
				time = 72.5,
				num = 2
			},
			{
				time = 80.5,
				num = 2
			},
			{
				time = 88.5,
				num = 2
			}
		}
	},
	{
		floors = {
			{
				time = 5,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 13,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 21,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 29,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 37,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 45,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 53,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 61,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 69,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 77,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			},
			{
				time = 85,
				rule_id = {
					1,
					2,
					3,
					4,
					5,
					6,
					7,
					8,
					9,
					10,
					11,
					12,
					13
				}
			}
		},
		carriage = {
			100
		},
		stone = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		boom = {
			{
				time = {
					5.5,
					5.5
				},
				index = {}
			},
			{
				time = {
					13.5,
					13.5
				},
				index = {}
			},
			{
				time = {
					21.5,
					21.5
				},
				index = {}
			},
			{
				time = {
					29.5,
					29.5
				},
				index = {}
			},
			{
				time = {
					37.5,
					37.5
				},
				index = {}
			},
			{
				time = {
					45.5,
					45.5
				},
				index = {}
			},
			{
				time = {
					53.5,
					53.5
				},
				index = {}
			},
			{
				time = {
					61.5,
					61.5
				},
				index = {}
			},
			{
				time = {
					69.5,
					69.5
				},
				index = {}
			},
			{
				time = {
					77.5,
					77.5
				},
				index = {}
			},
			{
				time = {
					85.5,
					85.5
				},
				index = {}
			}
		},
		score_time = {
			{
				time = 2,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 12,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 20,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 28,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 36,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 44,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 52,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 60,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 68,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 76,
				num = 18,
				score = {
					2,
					4,
					12
				}
			},
			{
				time = 84,
				num = 18,
				score = {
					2,
					4,
					12
				}
			}
		},
		bubble_time = {
			{
				time = 8.5,
				num = 2
			},
			{
				time = 16.5,
				num = 2
			},
			{
				time = 24.5,
				num = 2
			},
			{
				time = 32.5,
				num = 2
			},
			{
				time = 40.5,
				num = 2
			},
			{
				time = 48.5,
				num = 2
			},
			{
				time = 56.5,
				num = 2
			},
			{
				time = 64.5,
				num = 2
			},
			{
				time = 72.5,
				num = 2
			},
			{
				time = 80.5,
				num = 2
			},
			{
				time = 88.5,
				num = 2
			}
		}
	}
}
var0.round_rule = {
	{
		1
	},
	{
		1
	},
	{
		1
	},
	{
		1
	},
	{
		1
	},
	{
		1
	},
	{
		1
	}
}

function var0.Init(arg0, arg1)
	var0.game_id = arg0
	var0.hub_id = arg1
	var0.total_times = pg.mini_game_hub[var0.hub_id]
	var0.drop = pg.mini_game[var0.game_id].simple_config_data.drop_ids
	var0.total_times = pg.mini_game_hub[var0.hub_id].reward_need
end

function var0.Prepare()
	var0.gameTime = var0.game_time
	var0.gameStepTime = 0
	var0.scoreNum = 0

	local var0 = var0.round_rule[var0.GetGameRound()]

	var0.roundData = Clone(CastleGameVo.round_data[var0[math.random(1, #var0)]])
end

function var0.GetGameTimes()
	return var0.GetMiniGameHubData().count
end

function var0.GetGameUseTimes()
	return var0.GetMiniGameHubData().usedtime or 0
end

function var0.GetGameRound()
	local var0 = var0.GetGameUseTimes()
	local var1 = var0.GetGameTimes()

	if var1 and var1 > 0 then
		return var0 + 1
	else
		return var0
	end
end

function var0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0.game_id)
end

function var0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0.hub_id)
end

function var0.LoadSkeletonData(arg0, arg1)
	PoolMgr.GetInstance():LoadAsset(var0.ui_atlas, arg0, true, typeof(Object), function(arg0)
		if arg0 then
			local var0 = SpineAnimUI.AnimChar(arg0, arg0)

			arg1(var0)
		end
	end, true)
end

function var0.getBeachMap(arg0)
	return GetSpriteFromAtlas(BeachGuardAsset.map_asset_path, arg0)
end

function var0.getFloorImage(arg0)
	return GetSpriteFromAtlas(CastleGameVo.ui_atlas, arg0)
end

function var0.Sign(arg0, arg1, arg2)
	return (arg0.x - arg2.x) * (arg1.y - arg2.y) - (arg1.x - arg2.x) * (arg0.y - arg2.y)
end

function var0.PointInTriangle(arg0, arg1, arg2, arg3)
	local var0
	local var1
	local var2
	local var3
	local var4
	local var5 = var0.Sign(arg0, arg1, arg2)
	local var6 = var0.Sign(arg0, arg2, arg3)
	local var7 = var0.Sign(arg0, arg3, arg1)
	local var8 = var5 < 0 or var6 < 0 or var7 < 0
	local var9 = var5 > 0 or var6 > 0 or var7 > 0

	return not var8 or not var9
end

function var0.PointLeftLine(arg0, arg1, arg2)
	return (arg2.x - arg1.x) * (arg0.y - arg1.y) - (arg2.y - arg1.y) * (arg0.x - arg1.x) > 0
end

local var1 = 157
local var2 = 123
local var3 = 91
local var4 = 2
local var5 = -0.48
local var6 = Vector2(-671, -95)

function var0.GetRotationPos(arg0)
	local var0 = math.cos(var5)
	local var1 = math.sin(var5)
	local var2 = arg0 % CastleGameVo.w_count
	local var3 = math.floor(arg0 / CastleGameVo.h_count)
	local var4 = var1 * var2 + var3 * var3
	local var5 = var2 * var3 + var4 * var2
	local var6 = var0 * var4 - var1 * var5 + var6.x
	local var7 = var0 * var5 + var1 * var4 + var6.y

	return Vector2(var6, var7)
end

function var0.GetRotationPosByWH(arg0, arg1)
	local var0 = math.cos(var5)
	local var1 = math.sin(var5)
	local var2 = var1 * arg0 + var3 * arg1
	local var3 = var2 * arg1 + var4 * arg0
	local var4 = var0 * var2 - var1 * var3 + var6.x
	local var5 = var0 * var3 + var1 * var2 + var6.y

	return Vector2(var4, var5)
end

function var0.PointFootLine(arg0, arg1, arg2)
	local var0 = arg0.x
	local var1 = arg0.y
	local var2 = arg1.x
	local var3 = arg1.y
	local var4 = arg2.x
	local var5 = arg2.y
	local var6 = -((var2 - var0) * (var4 - var2) + (var3 - var1) * (var5 - var3)) / ((var2 - var4) * (var2 - var4) + (var3 - var5) * (var3 - var5))
	local var7 = var6 * (var4 - var2) + var2
	local var8 = var6 * (var5 - var3) + var3
	local var9 = true

	if var6 < 0 or var6 > 1 then
		var9 = false
	end

	return Vector2(var7, var8), var9
end

var0.gameTime = 0
var0.gameStepTime = 0
var0.deltaTime = 0
var0.scoreNum = 0
var0.joyStickData = nil
var0.roundData = nil

return var0
