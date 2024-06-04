local var0 = class("DecodeGameConst")

var0.DISORDER = {
	11,
	1,
	10,
	17,
	4,
	6,
	7,
	18,
	3,
	8,
	19,
	9,
	5,
	16,
	12,
	20,
	13,
	15,
	2,
	14,
	16
}
var0.START_POS = {
	-336.8,
	-93.6
}
var0.BLOCK_SIZE = {
	170,
	170
}
var0.MAP_ROW = 4
var0.MAP_COLUMN = 5
var0.MAP_NAME_OFFSET = 5
var0.PROGRESS2FILLAMOUMT = 0.0125
var0.PROGRESS2ANGLE = 4.5
var0.OPEN_DOOR_DELAY = 0
var0.MAX_MAP_COUNT = 3
var0.DECODE_MAP_TIME = 0.5
var0.SCAN_MAP_TIME = 1
var0.SWITCH_MAP = 0.5
var0.SCAN_GRID_TIME = 1
var0.SWITCH_TO_DECODE_TIME = 0.4
var0.GET_AWARD_ANIM_TIME = 0.7
var0.PASSWORDS = {
	"4",
	"8",
	"-",
	"1",
	"9",
	"0",
	"3",
	"-",
	"7",
	"1",
	"5",
	"4",
	"3",
	"-",
	"8",
	"9",
	"2",
	"6",
	"4",
	"1"
}
var0.PASSWORD = {
	{
		2,
		2
	},
	{
		4,
		2
	},
	{
		3,
		4
	},
	{
		3,
		3
	},
	{
		2,
		1
	},
	{
		4,
		3
	},
	{
		3,
		2
	},
	{
		2,
		4
	},
	{
		1,
		1
	}
}
var0.MAPS_PASSWORD = {
	{
		{
			3,
			2
		},
		{
			2,
			4
		},
		{
			1,
			1
		}
	},
	{
		{
			2,
			2
		},
		{
			4,
			2
		},
		{
			3,
			4
		}
	},
	{
		{
			3,
			3
		},
		{
			2,
			1
		},
		{
			4,
			3
		}
	}
}
var0.AWARD = {
	3,
	980,
	1
}
var0.STORYID = "MAOZIPT"
var0.UNLOCK_STORYID = {
	[20] = "LIMINGZHIAN1",
	[40] = "LIMINGZHIAN2",
	[60] = "LIMINGZHIAN3"
}
var0.LAST_STORYID = "LIMINGZHIAN4"

function var0.Vect2Index(arg0, arg1)
	return (arg0 - 1) * DecodeGameConst.MAP_COLUMN + arg1
end

function var0.Index2Vect(arg0)
	local var0 = math.ceil(arg0 / var0.MAP_COLUMN)
	local var1 = arg0 - (var0 - 1) * var0.MAP_COLUMN

	return var0, var1
end

var0.HELP_BGS = {
	{
		"decode_helper_1",
		{
			1714,
			771
		},
		{
			1,
			1
		}
	},
	{
		"decode_helper_2",
		{
			1546,
			769
		},
		{
			1,
			1
		}
	},
	{
		"decode_helper_3",
		{
			1723,
			885
		},
		{
			1,
			1
		}
	}
}
var0.OPEN_DOOR_VOICE = ""
var0.SWITCH_MAP_VOCIE = "event:/ui/dg-youanniu"
var0.PRESS_DOWN_PASSWORDBTN = "event:/ui/dg-xiaanniu"
var0.PRESS_UP_PASSWORDBTN = "event:/ui/dg-xiaanniu"
var0.SCAN_MAP_VOICE = ""
var0.INCREASE_PROGRESS_VOICE = ""
var0.PASSWORD_IS_RIGHT_VOICE = "event:/ui/dg-zhengque"
var0.PASSWORD_IS_FALSE_VOICE = "event:/ui/dg-cuowu"
var0.INCREASE_PASSWORD_PROGRESS_VOICE = ""
var0.GET_AWARD_DONE_VOICE = "event:/ui/dg-jiangli"

return var0
