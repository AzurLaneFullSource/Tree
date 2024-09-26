pg = pg or {}
pg.dorm3D_dolly = {
	[1001] = {
		name = "Dolly1_2",
		char_id = 20220,
		move_time = 0,
		id = 1001,
		wait_time = 0
	},
	[1002] = {
		name = "Dolly2_3",
		char_id = 20220,
		move_time = 3,
		id = 1002,
		wait_time = -1
	},
	get_id_list_by_char_id = {
		[20220] = {
			1001,
			1002
		}
	},
	all = {
		1001,
		1002
	}
}
