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
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
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
		param = "5802",
		id = 2,
		pic = "temp2",
		type = 3,
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
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
		id = 3,
		pic = "temp3",
		type = 2,
		param = {
			"scene get boat",
			{
				projectName = "new",
				page = 1
			}
		},
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
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
		id = 4,
		pic = "temp4",
		type = 2,
		param = {
			"scene shop",
			{
				warp = "shopstreet"
			}
		},
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
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
		type = 2,
		param = {
			"scene court yard"
		},
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
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
		id = 6,
		pic = "temp6",
		type = 2,
		param = {
			"scene charge",
			{
				wrap = 2
			}
		},
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
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
		id = 7,
		pic = "temp7",
		type = 3,
		param = {
			"crusing"
		},
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					27
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
		id = 8,
		pic = "temp8",
		type = 2,
		param = {
			"crusing"
		},
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					27
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
		type = 2,
		param = {
			"scene skinshop",
			{}
		}
	},
	[90] = {
		param = "",
		id = 90,
		pic = "temp99",
		type = 9,
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
				},
				{
					23,
					59,
					59
				}
			}
		}
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
		id = 99,
		pic = "limit_skin",
		type = 12,
		time = {
			{
				{
					2025,
					2,
					6
				},
				{
					0,
					0,
					0
				}
			},
			{
				{
					2025,
					2,
					12
				},
				{
					23,
					59,
					59
				}
			}
		}
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
	[200] = {
		param = "",
		time = "always",
		type = 13,
		id = 200,
		pic = "winter"
	},
	[201] = {
		param = "",
		time = "stop",
		type = 13,
		id = 201,
		pic = "christmas"
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
			3,
			4,
			5,
			6,
			8,
			9
		},
		[3] = {
			2,
			7
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
			101
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
		200,
		201,
		202
	}
}
