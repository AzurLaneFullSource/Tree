pg = pg or {}
pg.island_activity_template = rawget(pg, "island_activity_template") or setmetatable({
	__name = "island_activity_template"
}, confNEO)
pg.island_activity_template.all = {
	990001,
	990002,
	990003,
	990004,
	990005,
	990006,
	990007,
	990008,
	990011,
	990013,
	990014,
	990015
}
pg.base = pg.base or {}
pg.base.island_activity_template = {}

;(function()
	pg.base.island_activity_template[990001] = {
		ability_id = 33001,
		title_res_tag = "Autumn Specialties",
		id = 990001,
		config_id = 0,
		is_show = 99,
		page_info = {
			class_name = "IslandActivitySpecialOrderPage",
			ui_name = "IslandActivitySpecialOrderPage"
		}
	}
	pg.base.island_activity_template[990002] = {
		page_info = "",
		ability_id = 34001,
		title_res_tag = "",
		id = 990002,
		config_id = 0,
		is_show = 0
	}
	pg.base.island_activity_template[990003] = {
		page_info = "",
		ability_id = 35001,
		title_res_tag = "",
		id = 990003,
		config_id = 0,
		is_show = 0
	}
	pg.base.island_activity_template[990004] = {
		page_info = "",
		ability_id = 36001,
		title_res_tag = "",
		id = 990004,
		config_id = 0,
		is_show = 0
	}
	pg.base.island_activity_template[990005] = {
		ability_id = 33001,
		title_res_tag = "Spring Specialties",
		id = 990005,
		config_id = 0,
		is_show = 99,
		page_info = {
			class_name = "IslandActivitySpecialOrderS2Page",
			ui_name = "IslandActivitySpecialOrderS2Page"
		}
	}
	pg.base.island_activity_template[990006] = {
		page_info = "",
		ability_id = 34001,
		title_res_tag = "",
		id = 990006,
		config_id = 0,
		is_show = 0
	}
	pg.base.island_activity_template[990007] = {
		page_info = "",
		ability_id = 35001,
		title_res_tag = "",
		id = 990007,
		config_id = 0,
		is_show = 0
	}
	pg.base.island_activity_template[990008] = {
		page_info = "",
		ability_id = 36001,
		title_res_tag = "",
		id = 990008,
		config_id = 0,
		is_show = 0
	}
	pg.base.island_activity_template[990011] = {
		ability_id = 33001,
		title_res_tag = "Pearl Trade",
		id = 990011,
		config_id = 0,
		is_show = 99,
		page_info = {
			class_name = "IslandTradeActivityPage",
			ui_name = "IslandTradeActivityPage"
		}
	}
	pg.base.island_activity_template[990013] = {
		page_info = "",
		ability_id = 2,
		title_res_tag = "",
		id = 990013,
		config_id = 0,
		is_show = 0
	}
	pg.base.island_activity_template[990014] = {
		ability_id = 2,
		title_res_tag = "Tactical Simulation",
		id = 990014,
		config_id = 0,
		is_show = 1,
		page_info = {
			class_name = "IslandActivityCheateTavernDailySignPage",
			ui_name = "IslandActivityCheateTavernDailySignPage"
		}
	}
	pg.base.island_activity_template[990015] = {
		ability_id = 2,
		title_res_tag = "Simulation Rewards",
		id = 990015,
		config_id = 1,
		is_show = 1,
		page_info = {
			class_name = "IslandCheaterTavernPTPage",
			ui_name = "IslandCheaterTavernPTPage"
		}
	}
end)()
