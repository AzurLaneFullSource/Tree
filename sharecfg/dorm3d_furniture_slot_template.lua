pg = pg or {}
pg.dorm3d_furniture_slot_template = {
	[100101] = {
		id = 100101,
		name = "卧室桌子",
		type = 3,
		default_furniture = 0,
		room_id = 1,
		furniture_name = "pre_db_chandelier07",
		zone_id = 1001
	},
	[100102] = {
		id = 100102,
		name = "卧室床",
		type = 4,
		default_furniture = 4,
		room_id = 1,
		furniture_name = "pre_db_bed01",
		zone_id = 1001
	},
	[100201] = {
		id = 100201,
		name = "餐厅桌子",
		type = 3,
		default_furniture = 0,
		room_id = 1,
		furniture_name = "pre_db_electrical03",
		zone_id = 1002
	},
	[100202] = {
		id = 100202,
		name = "餐厅椅子",
		type = 6,
		default_furniture = 1,
		room_id = 1,
		furniture_name = "pre_db_chair05_01",
		zone_id = 1002
	},
	[100301] = {
		id = 100301,
		name = "客厅沙发",
		type = 5,
		default_furniture = 3,
		room_id = 1,
		furniture_name = "pre_db_chair01",
		zone_id = 1003
	},
	[100402] = {
		id = 100402,
		name = "换衣间置物架",
		type = 3,
		default_furniture = 0,
		room_id = 1,
		furniture_name = "pre_db_decoration03 (1)",
		zone_id = 1004
	},
	[120101] = {
		id = 120101,
		name = "卧室床边摆件",
		type = 3,
		default_furniture = 0,
		room_id = 2,
		furniture_name = "pre_db_nh_vase01",
		zone_id = 2001
	},
	[120102] = {
		id = 120102,
		name = "卧室床头摆件",
		type = 3,
		default_furniture = 0,
		room_id = 2,
		furniture_name = "pre_db_nh_toy02",
		zone_id = 2001
	},
	[120103] = {
		id = 120103,
		name = "卧室床",
		type = 4,
		default_furniture = 201,
		room_id = 2,
		furniture_name = "pre_db_bed02",
		zone_id = 2001
	},
	[120201] = {
		id = 120201,
		name = "餐厅桌子摆件",
		type = 3,
		default_furniture = 0,
		room_id = 2,
		furniture_name = "pre_db_nh_tableware02",
		zone_id = 2002
	},
	[120202] = {
		id = 120202,
		name = "餐厅墙上装饰",
		type = 3,
		default_furniture = 207,
		room_id = 2,
		furniture_name = "pre_db_nh_decoration03",
		zone_id = 2002
	},
	[120203] = {
		id = 120203,
		name = "餐厅椅子",
		type = 6,
		default_furniture = 202,
		room_id = 2,
		furniture_name = "pre_db_table05a",
		zone_id = 2002
	},
	[120301] = {
		id = 120301,
		name = "客厅窗边盆栽",
		type = 3,
		default_furniture = 208,
		room_id = 2,
		furniture_name = "pre_db_nh_flowerpot02",
		zone_id = 2003
	},
	[120302] = {
		id = 120302,
		name = "客厅柜子摆件",
		type = 3,
		default_furniture = 0,
		room_id = 2,
		furniture_name = "pre_db_nh_vase02",
		zone_id = 2003
	},
	[120303] = {
		id = 120303,
		name = "客厅沙发",
		type = 5,
		default_furniture = 203,
		room_id = 2,
		furniture_name = "pre_db_chair07",
		zone_id = 2003
	},
	get_id_list_by_room_id = {
		{
			100101,
			100102,
			100201,
			100202,
			100301,
			100402
		},
		{
			120101,
			120102,
			120103,
			120201,
			120202,
			120203,
			120301,
			120302,
			120303
		}
	},
	get_id_list_by_zone_id = {
		[1001] = {
			100101,
			100102
		},
		[1002] = {
			100201,
			100202
		},
		[1003] = {
			100301
		},
		[1004] = {
			100402
		},
		[2001] = {
			120101,
			120102,
			120103
		},
		[2002] = {
			120201,
			120202,
			120203
		},
		[2003] = {
			120301,
			120302,
			120303
		}
	},
	all = {
		100101,
		100102,
		100201,
		100202,
		100301,
		100402,
		120101,
		120102,
		120103,
		120201,
		120202,
		120203,
		120301,
		120302,
		120303
	}
}
