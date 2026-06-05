pg = pg or {}
pg.island_main_btns = rawget(pg, "island_main_btns") or setmetatable({
	__name = "island_main_btns"
}, confNEO)
pg.island_main_btns.all = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	10,
	11,
	12,
	13,
	14,
	15,
	16,
	17,
	18,
	19,
	20
}
pg.island_main_btns.get_id_list_by_main_type = {
	{
		2,
		3,
		4,
		5,
		11,
		12
	},
	{
		1,
		6,
		7,
		8,
		9,
		10,
		13,
		14,
		15,
		16,
		17,
		18,
		19
	},
	{
		20
	}
}
pg.base = pg.base or {}
pg.base.island_main_btns = {}

;(function()
	pg.base.island_main_btns[1] = {
		main_type = 2,
		name = "Warehouse",
		order = 1,
		open_page = "IslandInventoryPage",
		id = 1,
		icon = "inventory",
		ability_id = 9,
		btn_name = "inventory",
		page_param = {}
	}
	pg.base.island_main_btns[2] = {
		main_type = 1,
		name = "Characters",
		order = 5,
		open_page = "IslandShipMainPage",
		id = 2,
		icon = "char",
		ability_id = 28,
		btn_name = "char",
		page_param = {}
	}
	pg.base.island_main_btns[3] = {
		main_type = 1,
		name = "Map",
		order = 2,
		open_page = "IslandMapPage",
		id = 3,
		icon = "map",
		ability_id = 6,
		btn_name = "map",
		page_param = {}
	}
	pg.base.island_main_btns[4] = {
		main_type = 1,
		name = "Shop",
		order = 1,
		open_page = "IslandShopPage",
		id = 4,
		icon = "shop",
		ability_id = 35,
		btn_name = "shop",
		page_param = {
			{
				1,
				2,
				3,
				4,
				5,
				6
			},
			{
				90001,
				10019,
				10109,
				10130,
				10031,
				50111
			},
			1
		}
	}
	pg.base.island_main_btns[5] = {
		main_type = 1,
		name = "Equipment",
		order = 6,
		open_page = "IslandDevicePage",
		id = 5,
		icon = "device",
		ability_id = 2,
		btn_name = "device",
		page_param = {}
	}
	pg.base.island_main_btns[6] = {
		main_type = 2,
		name = "Island Request",
		order = 2,
		open_page = "IslandOrderPage",
		id = 6,
		icon = "order",
		ability_id = 7,
		btn_name = "order",
		page_param = {}
	}
	pg.base.island_main_btns[7] = {
		main_type = 2,
		name = "Transport Job",
		order = 3,
		open_page = "IslandShipOrderPage",
		id = 7,
		icon = "ship_order",
		ability_id = 32,
		btn_name = "ship_order",
		page_param = {}
	}
	pg.base.island_main_btns[8] = {
		main_type = 2,
		name = "Assignments",
		order = 4,
		open_page = "IslandPostManagePage",
		id = 8,
		icon = "post_manage",
		ability_id = 37001,
		btn_name = "post_manage",
		page_param = {}
	}
	pg.base.island_main_btns[9] = {
		main_type = 2,
		name = "Combo Guide",
		order = 5,
		open_page = "IslandSetMealHandbookPage",
		id = 9,
		icon = "collection",
		ability_id = 29001,
		btn_name = "collection",
		page_param = {}
	}
	pg.base.island_main_btns[10] = {
		main_type = 2,
		name = "Achievements",
		order = 6,
		open_page = "IslandAchvDetailPage",
		id = 10,
		icon = "achievement",
		ability_id = 30,
		btn_name = "achievement",
		page_param = {}
	}
	pg.base.island_main_btns[11] = {
		main_type = 1,
		name = "Seasonal",
		order = 3,
		open_page = "IslandSeasonPage",
		id = 11,
		icon = "season",
		ability_id = 31,
		btn_name = "season",
		page_param = {}
	}
	pg.base.island_main_btns[12] = {
		main_type = 1,
		name = "Tech Research",
		order = 4,
		open_page = "IslandTechnologyPage",
		id = 12,
		icon = "technology",
		ability_id = 28,
		btn_name = "technology",
		page_param = {}
	}
	pg.base.island_main_btns[13] = {
		main_type = 2,
		name = "Friends",
		order = 7,
		open_page = "IslandFriendPage",
		id = 13,
		icon = "friend",
		ability_id = 27,
		btn_name = "friend",
		page_param = {}
	}
	pg.base.island_main_btns[14] = {
		main_type = 2,
		name = "Outfits",
		order = 8,
		open_page = "IslandShipIslandCommanderMainPage",
		id = 14,
		icon = "commander",
		ability_id = 33,
		btn_name = "commander",
		page_param = {}
	}
	pg.base.island_main_btns[15] = {
		main_type = 2,
		name = "Planning",
		order = 9,
		open_page = "Island3dTaskPage",
		id = 15,
		icon = "task",
		ability_id = 2,
		btn_name = "task",
		page_param = {}
	}
	pg.base.island_main_btns[16] = {
		main_type = 2,
		name = "Mail",
		order = 10,
		open_page = "IslandMailPage",
		id = 16,
		icon = "mail",
		ability_id = 0,
		btn_name = "mail",
		page_param = {}
	}
	pg.base.island_main_btns[17] = {
		main_type = 2,
		name = "Settings",
		order = 11,
		open_page = "IslandSettingsPage",
		id = 17,
		icon = "setting",
		ability_id = 0,
		btn_name = "setting",
		page_param = {}
	}
	pg.base.island_main_btns[18] = {
		main_type = 2,
		name = "Collection",
		order = 12,
		open_page = "IslandBookPage",
		id = 18,
		icon = "book",
		ability_id = 0,
		btn_name = "book",
		page_param = {}
	}
	pg.base.island_main_btns[19] = {
		main_type = 2,
		name = "Photo",
		order = 13,
		open_page = "IslandPhotoMainPage",
		id = 19,
		icon = "photo",
		ability_id = 41,
		btn_name = "photo",
		page_param = {}
	}
	pg.base.island_main_btns[20] = {
		main_type = 3,
		name = "Fish Collection",
		order = 14,
		open_page = "IslandBookFishPage",
		id = 20,
		icon = "book_fish",
		ability_id = 47,
		btn_name = "book_fish",
		page_param = {}
	}
end)()
