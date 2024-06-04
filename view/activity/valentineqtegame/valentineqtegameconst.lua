local var0 = class("ValentineQteGameConst")

var0.DEBUG = false
var0.OP_SCORE_GEAR_PERFECT = 1
var0.OP_SCORE_GEAR_GREAT = 2
var0.OP_SCORE_GEAR_GOOD = 3
var0.OP_SCORE_GEAR_MISS = 4
var0.GMAE_TIME = 50
var0.SLIDEWAY_WIDTH = 1334
var0.SLIDER_WIDTH = 104
var0.PERFECT_WIDTH = 150
var0.GREAT_WIDTH = 270
var0.GOOD_WIDTH = 500
var0.INIT_SPEED = 550
var0.SPEEDUP_RATIO_PRE_5SEC = 3
var0.SPEED_UP = var0.INIT_SPEED * var0.SPEEDUP_RATIO_PRE_5SEC * 0.01
var0.MAX_SPEEDUP_RATIO = 120
var0.MAX_SPEED = var0.INIT_SPEED * var0.MAX_SPEEDUP_RATIO * 0.01
var0.BASE_OP_SCORE = 100
var0.OP_SCORE = {
	[var0.OP_SCORE_GEAR_PERFECT] = 1,
	[var0.OP_SCORE_GEAR_GREAT] = 0.7,
	[var0.OP_SCORE_GEAR_GOOD] = 0.5,
	[var0.OP_SCORE_GEAR_MISS] = 0
}
var0.COMBO_EXTRA_SCORE_RATIO = {
	{
		2,
		5,
		20
	},
	{
		6,
		10,
		40
	},
	{
		11,
		15,
		60
	},
	{
		16,
		20,
		80
	},
	{
		21,
		Mathf.Infinity,
		100
	}
}
var0.OP_INTERVAL = 0.2
var0.GEN_ITEM_FIRST_TIME = 5
var0.GEN_ITEM_INTERVAL = 3
var0.ITEM_DISAPPEAR_TIME = 5
var0.MAX_ITEM_COUNT = 4
var0.CHAT_CONTENT = {
	{
		6000,
		Mathf.Infinity,
		"s"
	},
	{
		3000,
		5999,
		"a"
	},
	{
		1000,
		2999,
		"b"
	},
	{
		0,
		999,
		"c"
	}
}
var0.GEAR_SHOW_TIME = 0.7
var0.OPEN_DOOR_TIME = 3
var0.SOUND_PICK_ITEM = "event:/ui/mini_get"
var0.GEAR_SOUND = {
	[var0.OP_SCORE_GEAR_PERFECT] = "event:/ui/mini_perfect",
	[var0.OP_SCORE_GEAR_GREAT] = "event:/ui/mini_great",
	[var0.OP_SCORE_GEAR_GOOD] = "event:/ui/mini_miss",
	[var0.OP_SCORE_GEAR_MISS] = "event:/ui/mini_miss"
}

return var0
