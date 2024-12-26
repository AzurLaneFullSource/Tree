pg = pg or {}
pg.dorm3d_accompany = {
	{
		ship_id = 20220,
		name = "日常相伴",
		resource_room = 1,
		performance_time = 20,
		id = 1,
		image = "tianlangxing_accompany_room",
		timeline = "Xiangban_shinei",
		sceneInfo = "map_siriushostel_01|Tianlangxing_DB/SiriusHostel",
		favor = {
			300,
			{
				1015,
				1016,
				1017
			}
		},
		jump_trigger = {},
		unlock = {}
	},
	{
		ship_id = 20220,
		name = "休闲相伴",
		resource_room = 4,
		performance_time = 20,
		id = 2,
		image = "tianlangxing_accompany_beach",
		timeline = "Xiangban_shatan",
		sceneInfo = "map_beach_02|Beach",
		favor = {
			300,
			{
				1015,
				1016,
				1017
			}
		},
		jump_trigger = {},
		unlock = {
			5,
			4,
			20220
		}
	},
	[21] = {
		ship_id = 30221,
		name = "日常相伴",
		resource_room = 2,
		performance_time = 20,
		id = 21,
		image = "nengdai_accompany_room",
		timeline = "Xiangban_shinei_ND",
		sceneInfo = "map_noshirohostel_02|Nengdai_DB/NoshiroHostel",
		favor = {
			10,
			{
				1015,
				1016,
				1017
			}
		},
		jump_trigger = {},
		unlock = {}
	},
	[22] = {
		ship_id = 30221,
		name = "休闲相伴",
		resource_room = 4,
		performance_time = 20,
		id = 22,
		image = "tianlangxing_accompany_beach",
		timeline = "Xiangban_shatan_ND",
		sceneInfo = "map_beach_02|Beach",
		favor = {
			10,
			{
				1015,
				1016,
				1017
			}
		},
		jump_trigger = {},
		unlock = {
			5,
			4,
			30221
		}
	},
	get_id_list_by_ship_id = {
		[20220] = {
			1,
			2
		},
		[30221] = {
			21,
			22
		}
	},
	all = {
		1,
		2,
		21,
		22
	}
}
