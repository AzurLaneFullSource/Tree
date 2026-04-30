pg = pg or {}
pg.world_port_data = rawget(pg, "world_port_data") or setmetatable({
	__name = "world_port_data"
}, confNEO)
pg.world_port_data.all = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	20,
	30,
	100,
	301
}
pg.base = pg.base or {}
pg.base.world_port_data = {}

;(function()
	pg.base.world_port_data[1] = {
		port_bg = "port_niuyue",
		name = "NY City",
		port_camp = 1,
		port_entrance_icon = "port_niuyue",
		id = 1,
		scan_desc = "A port in Eagle Union territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[2] = {
		port_bg = "port_liwupu",
		name = "Liverpool",
		port_camp = 1,
		port_entrance_icon = "port_liwupu",
		id = 2,
		scan_desc = "A port in Royal Navy territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[3] = {
		port_bg = "port_zhibuluotuo",
		name = "Gibraltar ",
		port_camp = 1,
		port_entrance_icon = "port_zhibuluotuo",
		id = 3,
		scan_desc = "A port in Royal Navy territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[4] = {
		port_bg = "port_shenbidebao",
		name = "St. Petersburg",
		port_camp = 1,
		port_entrance_icon = "port_shenbidebao",
		id = 4,
		scan_desc = "A port in Northern Parliament territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[5] = {
		port_bg = "port_jier",
		name = "Kiel",
		port_camp = 2,
		port_entrance_icon = "port_jier",
		id = 5,
		scan_desc = "A port in Iron Blood territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[6] = {
		port_bg = "port_talantuo",
		name = "Taranto",
		port_camp = 2,
		port_entrance_icon = "port_talantuo",
		id = 6,
		scan_desc = "A port in Sardegna Empire territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[7] = {
		port_bg = "port_buleisite",
		name = "Brest",
		port_camp = 2,
		port_entrance_icon = "port_buleisite",
		id = 7,
		scan_desc = "A port in Vichya Dominion territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[8] = {
		port_bg = "port_dakaer",
		name = "Dakar",
		port_camp = 2,
		port_entrance_icon = "port_dakaer",
		id = 8,
		scan_desc = "A port in Vichya Dominion territory.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[20] = {
		port_bg = "port_zuozhangangkou",
		name = "Forward Base ",
		port_camp = 1,
		port_entrance_icon = "",
		id = 20,
		scan_desc = "A forward base for the fleets participating in Operation Siren. ",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[30] = {
		port_bg = "port_zuozhangangkou",
		name = "NA Ocean Core Sector Forward Base",
		port_camp = 1,
		port_entrance_icon = "",
		id = 30,
		scan_desc = "Your forward base for the counteroffensive in the NA Ocean Core Sector.",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[100] = {
		port_bg = "port_chuanwu1",
		name = "Future Content ",
		port_camp = 0,
		port_entrance_icon = "",
		id = 100,
		scan_desc = "",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
	pg.base.world_port_data[301] = {
		port_bg = "port_chongdong",
		name = "Future Content ",
		port_camp = 0,
		port_entrance_icon = "",
		id = 301,
		scan_desc = "",
		open_condition = {
			{
				1,
				0
			},
			{
				2,
				0
			}
		}
	}
end)()
