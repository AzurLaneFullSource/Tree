pg = pg or {}
pg.island_storage_filter_template = rawget(pg, "island_storage_filter_template") or setmetatable({
	__name = "island_storage_filter_template"
}, confNEO)
pg.island_storage_filter_template.all = {
	101,
	1011,
	10111,
	10112,
	10113,
	10114,
	1012,
	10121,
	10122,
	10123,
	10124,
	10125,
	10132,
	10133,
	10126,
	10127,
	10128,
	10129,
	10130,
	10131,
	10140,
	102,
	1021,
	10211,
	10212,
	10213,
	103,
	1031,
	10311,
	10312,
	10313,
	1010,
	104
}
pg.island_storage_filter_template.get_id_list_by_belong_filter_id = {
	[0] = {
		101,
		102,
		103,
		1010
	},
	[101] = {
		1011,
		1012
	},
	[102] = {
		1021
	},
	[103] = {
		1031
	},
	[1010] = {
		104
	},
	[1011] = {
		10111,
		10112,
		10113,
		10114
	},
	[1012] = {
		10121,
		10122,
		10123,
		10124,
		10125,
		10132,
		10133,
		10126,
		10127,
		10128,
		10129,
		10130,
		10131,
		10140
	},
	[1021] = {
		10211,
		10212,
		10213
	},
	[1031] = {
		10311,
		10312,
		10313
	}
}
pg.base = pg.base or {}
pg.base.island_storage_filter_template = {}

;(function()
	pg.base.island_storage_filter_template[101] = {
		belong_filter_id = 0,
		filter_level = 1,
		name = "Resources",
		id = 101,
		args = "",
		res = "",
		sort_id = 1010
	}
	pg.base.island_storage_filter_template[1011] = {
		belong_filter_id = 101,
		filter_level = 2,
		name = "Category",
		id = 1011,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10111] = {
		belong_filter_id = 1011,
		filter_level = 3,
		name = "Basic Resource",
		id = 10111,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10112] = {
		belong_filter_id = 1011,
		filter_level = 3,
		name = "Product",
		id = 10112,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10113] = {
		belong_filter_id = 1011,
		filter_level = 3,
		name = "Produce",
		id = 10113,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10114] = {
		belong_filter_id = 1011,
		filter_level = 3,
		name = "Misc.",
		id = 10114,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[1012] = {
		belong_filter_id = 101,
		filter_level = 2,
		name = "Location",
		id = 1012,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10121] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Faircrop Fields",
		id = 10121,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10122] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Laidback Ranch",
		id = 10122,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10123] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Rockheap Mine",
		id = 10123,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10124] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Verdant Woods",
		id = 10124,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10125] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Sweetscent Orchard",
		id = 10125,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10132] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Newsprout Nursery",
		id = 10132,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10133] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Manjuu Fish Hatchery",
		id = 10133,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10126] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Café Manjuu",
		id = 10126,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10127] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Golden Koi Restaurant",
		id = 10127,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10128] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Polar Bear Teahouse",
		id = 10128,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10129] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Manjuu Eatery",
		id = 10129,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10130] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Fin-'n'-Feather Grill",
		id = 10130,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10131] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Base Factory",
		id = 10131,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10140] = {
		belong_filter_id = 1012,
		filter_level = 3,
		name = "Misc.",
		id = 10140,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[102] = {
		belong_filter_id = 0,
		filter_level = 1,
		name = "Consumables",
		id = 102,
		args = "",
		res = "",
		sort_id = 1010
	}
	pg.base.island_storage_filter_template[1021] = {
		belong_filter_id = 102,
		filter_level = 2,
		name = "Category",
		id = 1021,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10211] = {
		belong_filter_id = 1021,
		filter_level = 3,
		name = "Growth",
		id = 10211,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10212] = {
		belong_filter_id = 1021,
		filter_level = 3,
		name = "Buff",
		id = 10212,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10213] = {
		belong_filter_id = 1021,
		filter_level = 3,
		name = "Misc.",
		id = 10213,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[103] = {
		belong_filter_id = 0,
		filter_level = 1,
		name = "Special",
		id = 103,
		args = "",
		res = "",
		sort_id = 1010
	}
	pg.base.island_storage_filter_template[1031] = {
		belong_filter_id = 103,
		filter_level = 2,
		name = "Category",
		id = 1031,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10311] = {
		belong_filter_id = 1031,
		filter_level = 3,
		name = "Mission",
		id = 10311,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10312] = {
		belong_filter_id = 1031,
		filter_level = 3,
		name = "Funds",
		id = 10312,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[10313] = {
		belong_filter_id = 1031,
		filter_level = 3,
		name = "Misc.",
		id = 10313,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[1010] = {
		belong_filter_id = 0,
		filter_level = 2,
		name = "Sort",
		id = 1010,
		args = "",
		res = "",
		sort_id = 0
	}
	pg.base.island_storage_filter_template[104] = {
		belong_filter_id = 1010,
		filter_level = 3,
		name = "Rarity",
		id = 104,
		args = "GetRarity",
		res = "",
		sort_id = 0
	}
end)()
