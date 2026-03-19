pg = pg or {}
pg.activity_banner = {
	{
		id = 1,
		pic = "temp1",
		type = 2,
		param = {
			"scene skinshop",
			{}
		},
		time = {
			{
				{
					2026,
					3,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					3,
					25
				},
				{
					23,
					59,
					59
				}
			}
		}
	},
	{
		id = 2,
		pic = "temp2",
		time = "stop",
		type = 2,
		param = {
			"scene get boat",
			{
				projectName = "new",
				page = 1
			}
		}
	},
	{
		id = 3,
		pic = "temp3",
		type = 2,
		param = {
			"scene activity",
			{
				event = "ActivityMediator.OPEN_CULTIVATING_PLANT",
				data = {}
			}
		},
		time = {
			{
				{
					2026,
					3,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					3,
					25
				},
				{
					23,
					59,
					59
				}
			}
		}
	},
	{
		param = "50479",
		id = 4,
		pic = "temp4",
		type = 3,
		time = {
			{
				{
					2026,
					3,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					3,
					25
				},
				{
					23,
					59,
					59
				}
			}
		}
	},
	{
		id = 5,
		pic = "temp5",
		time = "stop",
		type = 2,
		param = {
			"scene shop",
			{
				warp = "shopstreet"
			}
		}
	},
	{
		param = "50448",
		time = "stop",
		type = 3,
		id = 6,
		pic = "temp6"
	},
	{
		id = 7,
		pic = "temp7",
		time = "stop",
		type = 2,
		param = {
			"dorm 3d select"
		}
	},
	{
		param = "50501",
		id = 8,
		pic = "temp8",
		type = 3,
		time = {
			{
				{
					2026,
					3,
					19
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2026,
					3,
					25
				},
				{
					23,
					59,
					59
				}
			}
		}
	},
	{
		id = 9,
		pic = "temp9",
		time = "stop",
		type = 3,
		param = {
			"scene level",
			{
				open_remaster = true,
				isSP = true
			}
		}
	},
	[90] = {
		param = "",
		time = "stop",
		type = 9,
		id = 90,
		pic = "temp99"
	},
	[91] = {
		param = "",
		time = "stop",
		type = 9,
		id = 91,
		pic = "temp98"
	},
	[95] = {
		param = "",
		time = "stop",
		type = 11,
		id = 95,
		pic = "temp100"
	},
	[99] = {
		param = "",
		time = "stop",
		type = 12,
		id = 99,
		pic = "limit_skin"
	},
	[100] = {
		param = "Dumplings|A world-famous delight from the Dragon Empery! <color=#92fc63>(Increases EXP gained by 5% for 60 minutes.)</color>",
		time = "stop",
		type = 10,
		id = 100,
		pic = "dumpling"
	},
	[101] = {
		param = "Kagami Mochi| Make sure to unwrap it first before digging in! <color=#6dd329>(Increases EXP gained by 5% for 60 minutes).</color> ",
		time = "stop",
		type = 10,
		id = 101,
		pic = "jingbing"
	},
	[102] = {
		param = "Candy Cane|It is said that the first candy canes were pure white like the snow. <color=#6dd329>(Increases EXP gained by 5% for 60 minutes).</color> ",
		time = "stop",
		type = 10,
		id = 102,
		pic = "christmas"
	},
	[200] = {
		param = "",
		time = "stop",
		type = 13,
		id = 200,
		pic = "autumn"
	},
	[201] = {
		param = "",
		time = "always",
		type = 13,
		id = 201,
		pic = "spring"
	},
	[202] = {
		param = "",
		time = "stop",
		type = 13,
		id = 202,
		pic = "winter"
	},
	get_id_list_by_type = {
		[2] = {
			1,
			2,
			3,
			5,
			7
		},
		[3] = {
			4,
			6,
			8,
			9
		},
		[9] = {
			90,
			91
		},
		[11] = {
			95
		},
		[12] = {
			99
		},
		[10] = {
			100,
			101,
			102
		},
		[13] = {
			200,
			201,
			202
		}
	},
	all = {
		1,
		2,
		3,
		4,
		5,
		6,
		7,
		8,
		9,
		90,
		91,
		95,
		99,
		100,
		101,
		102,
		200,
		201,
		202
	}
}
