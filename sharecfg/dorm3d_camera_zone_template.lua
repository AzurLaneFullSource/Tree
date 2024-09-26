pg = pg or {}
pg.dorm3d_camera_zone_template = {
	[1001] = {
		move_range_horizonal = "",
		name = "Bedroom",
		move_range_vertical = "",
		record_time = 60,
		id = 1001,
		room_id = 1,
		watch_camera = "Bed",
		regular_anim = {
			1001,
			1002,
			1003,
			1004,
			1005,
			1006,
			1007,
			1008,
			1009,
			1010,
			1011,
			1012
		},
		special_furniture = {
			{
				4,
				100102
			},
			{
				121,
				100102
			}
		},
		anim_speeds = {
			0.2,
			0.5,
			1,
			1.5,
			2
		},
		focus_distance = {
			0.1,
			5
		},
		blur_strength = {
			-2,
			2
		},
		exposure = {
			-3,
			3
		},
		contrast = {
			-100,
			100
		},
		saturation = {
			-100,
			100
		}
	},
	[1002] = {
		move_range_horizonal = "",
		name = "Dining Area",
		move_range_vertical = "",
		record_time = 60,
		id = 1002,
		room_id = 1,
		watch_camera = "Table",
		regular_anim = {
			1001,
			1002,
			1003,
			1004,
			1005,
			1006,
			1007,
			1008,
			1009,
			1010,
			1011,
			1012
		},
		special_furniture = {
			{
				1,
				100202
			}
		},
		anim_speeds = {
			0.2,
			0.5,
			1,
			1.5,
			2
		},
		focus_distance = {
			0.1,
			5
		},
		blur_strength = {
			-2,
			2
		},
		exposure = {
			-3,
			3
		},
		contrast = {
			-100,
			100
		},
		saturation = {
			-100,
			100
		}
	},
	[1003] = {
		move_range_horizonal = "",
		name = "Living Area",
		move_range_vertical = "",
		record_time = 60,
		id = 1003,
		room_id = 1,
		watch_camera = "Chair",
		regular_anim = {
			1001,
			1002,
			1003,
			1004,
			1005,
			1006,
			1007,
			1008,
			1009,
			1010,
			1011,
			1012
		},
		special_furniture = {
			{
				3,
				100301
			}
		},
		anim_speeds = {
			0.2,
			0.5,
			1,
			1.5,
			2
		},
		focus_distance = {
			0.1,
			5
		},
		blur_strength = {
			-2,
			2
		},
		exposure = {
			-3,
			3
		},
		contrast = {
			-100,
			100
		},
		saturation = {
			-100,
			100
		}
	},
	[4001] = {
		move_range_horizonal = "",
		name = "Beach Chair",
		move_range_vertical = "",
		record_time = 60,
		id = 4001,
		room_id = 4,
		watch_camera = "Tianlangxing",
		regular_anim = {
			4001,
			4002,
			4003,
			4004,
			4005
		},
		special_furniture = {},
		anim_speeds = {
			0.2,
			0.5,
			1,
			1.5,
			2
		},
		focus_distance = {
			0.1,
			5
		},
		blur_strength = {
			-2,
			2
		},
		exposure = {
			-3,
			3
		},
		contrast = {
			-100,
			100
		},
		saturation = {
			-100,
			100
		}
	},
	get_id_list_by_room_id = {
		{
			1001,
			1002,
			1003
		},
		[4] = {
			4001
		}
	},
	all = {
		1001,
		1002,
		1003,
		4001
	}
}
