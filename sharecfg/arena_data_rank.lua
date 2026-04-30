pg = pg or {}
pg.arena_data_rank = rawget(pg, "arena_data_rank") or setmetatable({
	__name = "arena_data_rank"
}, confNEO)
pg.arena_data_rank.all = {
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
	14
}
pg.base = pg.base or {}
pg.base.arena_data_rank = {}

;(function()
	pg.base.arena_data_rank[1] = {
		battle_award = 50,
		name = "Seaman",
		point = 0,
		refresh_limit = 5,
		k_value = 50,
		id = 1,
		order = 0,
		award_list = {},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[2] = {
		battle_award = 60,
		name = "Petty Officer",
		point = 100,
		refresh_limit = 5,
		k_value = 45,
		id = 2,
		order = 0,
		award_list = {
			{
				1,
				3,
				200
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[3] = {
		battle_award = 70,
		name = "Ensign",
		point = 200,
		refresh_limit = 5,
		k_value = 40,
		id = 3,
		order = 0,
		award_list = {
			{
				1,
				3,
				600
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[4] = {
		battle_award = 70,
		name = "Lieutenant Junior Grade",
		point = 300,
		refresh_limit = 5,
		k_value = 35,
		id = 4,
		order = 0,
		award_list = {
			{
				1,
				3,
				600
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[5] = {
		battle_award = 70,
		name = "Lieutenant",
		point = 400,
		refresh_limit = 5,
		k_value = 30,
		id = 5,
		order = 0,
		award_list = {
			{
				1,
				3,
				600
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[6] = {
		battle_award = 80,
		name = "Lieutenant Commander",
		point = 550,
		refresh_limit = 5,
		k_value = 30,
		id = 6,
		order = 0,
		award_list = {
			{
				1,
				3,
				1000
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[7] = {
		battle_award = 80,
		name = "Commander",
		point = 700,
		refresh_limit = 5,
		k_value = 30,
		id = 7,
		order = 0,
		award_list = {
			{
				1,
				3,
				1000
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[8] = {
		battle_award = 80,
		name = "Captain",
		point = 850,
		refresh_limit = 5,
		k_value = 25,
		id = 8,
		order = 0,
		award_list = {
			{
				1,
				3,
				1000
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[9] = {
		battle_award = 90,
		name = "Rear Admiral Lower Half",
		point = 1050,
		refresh_limit = 5,
		k_value = 20,
		id = 9,
		order = 1000,
		award_list = {
			{
				1,
				3,
				1500
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[10] = {
		battle_award = 90,
		name = "Rear Admiral",
		point = 1250,
		refresh_limit = 5,
		k_value = 20,
		id = 10,
		order = 600,
		award_list = {
			{
				1,
				3,
				1500
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[11] = {
		battle_award = 90,
		name = "Vice Admiral",
		point = 1450,
		refresh_limit = 5,
		k_value = 20,
		id = 11,
		order = 300,
		award_list = {
			{
				1,
				3,
				1500
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[12] = {
		battle_award = 90,
		name = "Admiral",
		point = 1650,
		refresh_limit = 5,
		k_value = 20,
		id = 12,
		order = 100,
		award_list = {
			{
				1,
				3,
				1500
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[13] = {
		battle_award = 90,
		name = "Fleet Admiral",
		point = 1900,
		refresh_limit = 5,
		k_value = 20,
		id = 13,
		order = 50,
		award_list = {
			{
				1,
				3,
				1500
			}
		},
		refresh_price = {
			0
		}
	}
	pg.base.arena_data_rank[14] = {
		battle_award = 100,
		name = "Admiral of the Navy",
		point = 2200,
		refresh_limit = 5,
		k_value = 20,
		id = 14,
		order = 10,
		award_list = {
			{
				1,
				3,
				2500
			}
		},
		refresh_price = {
			0
		}
	}
end)()
