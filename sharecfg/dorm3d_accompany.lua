pg = pg or {}
pg.dorm3d_accompany = {
	{
		ship_id = 20220,
		name = "日常相伴",
		timeline = "Xiangban_shinei",
		performance_time = 20,
		id = 1,
		image = "tianlangxing_accompany_room",
		sceneInfo = "map_siriushostel_01|Tianlangxing_DB/SiriusHostel",
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
	{
		ship_id = 20220,
		name = "休闲相伴",
		timeline = "Xiangban_shatan",
		performance_time = 20,
		id = 2,
		image = "tianlangxing_accompany_beach",
		sceneInfo = "map_beach_02|Common/Beach",
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
	get_id_list_by_ship_id = {
		[20220] = {
			1,
			2
		}
	},
	all = {
		1,
		2
	}
}
