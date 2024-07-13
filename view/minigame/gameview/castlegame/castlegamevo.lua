local var0_0 = class("CastleGameVo")

var0_0.game_id = nil
var0_0.hub_id = nil
var0_0.total_times = nil
var0_0.drop = nil
var0_0.game_bgm = "bar-soft"
var0_0.game_time = 90
var0_0.rule_tip = "uscastle2023_minigame_help"
var0_0.frameRate = Application.targetFrameRate or 60
var0_0.ui_atlas = "ui/minigameui/castlegameui_atlas"
var0_0.game_ui = "CastleGameUI"
var0_0.SFX_COUNT_DOWN = "event:/ui/ddldaoshu2"
var0_0.SFX_POINT_DOWN = "event:/ui/break_out_full"
var0_0.GAME_FAIL = "game fail"
var0_0.w_count = 6
var0_0.h_count = 6
var0_0.stone_broken_time = 1.5
var0_0.floor_remove_time = 3
var0_0.floor_revert_time = 3
var0_0.bubble_ready_time = 0.5
var0_0.bubble_broken_time = 4
var0_0.item_ready_time = 2
var0_0.char_speed = 380
var0_0.char_speed_min = 30
var0_0.score_remove_time = 8.5
var0_0.score_data = {
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
var0_0.floor_rule = {
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
var0_0.round_data = {
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
var0_0.round_rule = {
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

function var0_0.Init(arg0_1, arg1_1)
	var0_0.game_id = arg0_1
	var0_0.hub_id = arg1_1
	var0_0.total_times = pg.mini_game_hub[var0_0.hub_id]
	var0_0.drop = pg.mini_game[var0_0.game_id].simple_config_data.drop_ids
	var0_0.total_times = pg.mini_game_hub[var0_0.hub_id].reward_need
end

function var0_0.Prepare()
	var0_0.gameTime = var0_0.game_time
	var0_0.gameStepTime = 0
	var0_0.scoreNum = 0

	local var0_2 = var0_0.round_rule[var0_0.GetGameRound()]

	var0_0.roundData = Clone(CastleGameVo.round_data[var0_2[math.random(1, #var0_2)]])
end

function var0_0.GetGameTimes()
	return var0_0.GetMiniGameHubData().count
end

function var0_0.GetGameUseTimes()
	return var0_0.GetMiniGameHubData().usedtime or 0
end

function var0_0.GetGameRound()
	local var0_5 = var0_0.GetGameUseTimes()
	local var1_5 = var0_0.GetGameTimes()

	if var1_5 and var1_5 > 0 then
		return var0_5 + 1
	else
		return var0_5
	end
end

function var0_0.GetMiniGameData()
	return getProxy(MiniGameProxy):GetMiniGameData(var0_0.game_id)
end

function var0_0.GetMiniGameHubData()
	return getProxy(MiniGameProxy):GetHubByHubId(var0_0.hub_id)
end

function var0_0.LoadSkeletonData(arg0_8, arg1_8)
	PoolMgr.GetInstance():LoadAsset(var0_0.ui_atlas, arg0_8, true, typeof(Object), function(arg0_9)
		if arg0_9 then
			local var0_9 = SpineAnimUI.AnimChar(arg0_8, arg0_9)

			arg1_8(var0_9)
		end
	end, true)
end

function var0_0.getBeachMap(arg0_10)
	return GetSpriteFromAtlas(BeachGuardAsset.map_asset_path, arg0_10)
end

function var0_0.getFloorImage(arg0_11)
	return GetSpriteFromAtlas(CastleGameVo.ui_atlas, arg0_11)
end

function var0_0.Sign(arg0_12, arg1_12, arg2_12)
	return (arg0_12.x - arg2_12.x) * (arg1_12.y - arg2_12.y) - (arg1_12.x - arg2_12.x) * (arg0_12.y - arg2_12.y)
end

function var0_0.PointInTriangle(arg0_13, arg1_13, arg2_13, arg3_13)
	local var0_13
	local var1_13
	local var2_13
	local var3_13
	local var4_13
	local var5_13 = var0_0.Sign(arg0_13, arg1_13, arg2_13)
	local var6_13 = var0_0.Sign(arg0_13, arg2_13, arg3_13)
	local var7_13 = var0_0.Sign(arg0_13, arg3_13, arg1_13)
	local var8_13 = var5_13 < 0 or var6_13 < 0 or var7_13 < 0
	local var9_13 = var5_13 > 0 or var6_13 > 0 or var7_13 > 0

	return not var8_13 or not var9_13
end

function var0_0.PointLeftLine(arg0_14, arg1_14, arg2_14)
	return (arg2_14.x - arg1_14.x) * (arg0_14.y - arg1_14.y) - (arg2_14.y - arg1_14.y) * (arg0_14.x - arg1_14.x) > 0
end

local var1_0 = 157
local var2_0 = 123
local var3_0 = 91
local var4_0 = 2
local var5_0 = -0.48
local var6_0 = Vector2(-671, -95)

function var0_0.GetRotationPos(arg0_15)
	local var0_15 = math.cos(var5_0)
	local var1_15 = math.sin(var5_0)
	local var2_15 = arg0_15 % CastleGameVo.w_count
	local var3_15 = math.floor(arg0_15 / CastleGameVo.h_count)
	local var4_15 = var1_0 * var2_15 + var3_0 * var3_15
	local var5_15 = var2_0 * var3_15 + var4_0 * var2_15
	local var6_15 = var0_15 * var4_15 - var1_15 * var5_15 + var6_0.x
	local var7_15 = var0_15 * var5_15 + var1_15 * var4_15 + var6_0.y

	return Vector2(var6_15, var7_15)
end

function var0_0.GetRotationPosByWH(arg0_16, arg1_16)
	local var0_16 = math.cos(var5_0)
	local var1_16 = math.sin(var5_0)
	local var2_16 = var1_0 * arg0_16 + var3_0 * arg1_16
	local var3_16 = var2_0 * arg1_16 + var4_0 * arg0_16
	local var4_16 = var0_16 * var2_16 - var1_16 * var3_16 + var6_0.x
	local var5_16 = var0_16 * var3_16 + var1_16 * var2_16 + var6_0.y

	return Vector2(var4_16, var5_16)
end

function var0_0.PointFootLine(arg0_17, arg1_17, arg2_17)
	local var0_17 = arg0_17.x
	local var1_17 = arg0_17.y
	local var2_17 = arg1_17.x
	local var3_17 = arg1_17.y
	local var4_17 = arg2_17.x
	local var5_17 = arg2_17.y
	local var6_17 = -((var2_17 - var0_17) * (var4_17 - var2_17) + (var3_17 - var1_17) * (var5_17 - var3_17)) / ((var2_17 - var4_17) * (var2_17 - var4_17) + (var3_17 - var5_17) * (var3_17 - var5_17))
	local var7_17 = var6_17 * (var4_17 - var2_17) + var2_17
	local var8_17 = var6_17 * (var5_17 - var3_17) + var3_17
	local var9_17 = true

	if var6_17 < 0 or var6_17 > 1 then
		var9_17 = false
	end

	return Vector2(var7_17, var8_17), var9_17
end

var0_0.gameTime = 0
var0_0.gameStepTime = 0
var0_0.deltaTime = 0
var0_0.scoreNum = 0
var0_0.joyStickData = nil
var0_0.roundData = nil

return var0_0
