pg = pg or {}
pg.chapter_suggestion_formation = rawget(pg, "chapter_suggestion_formation") or setmetatable({
	__name = "chapter_suggestion_formation"
}, confNEO)
pg.chapter_suggestion_formation.all = {
	1,
	2,
	3,
	4,
	5,
	6
}
pg.chapter_suggestion_formation.get_id_list_by_chapter = {
	[13] = {
		1,
		2,
		3
	},
	[14] = {
		4,
		5,
		6
	}
}
pg.chapter_suggestion_formation.get_id_list_by_type = {
	{
		1,
		4
	},
	{
		2,
		5
	},
	{
		3,
		6
	}
}
pg.base = pg.base or {}
pg.base.chapter_suggestion_formation = {}

;(function()
	pg.base.chapter_suggestion_formation[1] = {
		type = 1,
		chapter = 13,
		describe = "Recommended Formation: Circular Defense. The Vanguard fleet should include ships with high AA, while the Main Fleet should consist of 3 CVs. ",
		describe_title = "Recommended Fleet",
		id = 1,
		page_title = "Fleetbuilding Guide - Chapter 13",
		teamid = {
			1301,
			1302,
			1303
		},
		teamid1 = {
			1304,
			1305,
			1306
		}
	}
	pg.base.chapter_suggestion_formation[2] = {
		type = 2,
		chapter = 13,
		describe = "Recommended Formation: Circular Defense. The Vanguard fleet should include 2 ships with high AA and survival capabilities, and one ship with superior AA capabilities. The Main Fleet should consist of 1 BB and 2 CVs.",
		describe_title = "Recommended Fleet",
		id = 2,
		page_title = "Fleetbuilding Guide - Chapter 13",
		teamid = {
			1311,
			1312,
			1313
		},
		teamid1 = {
			1314,
			1315,
			1316
		}
	}
	pg.base.chapter_suggestion_formation[3] = {
		type = 3,
		chapter = 13,
		describe = "It is highly recommended to use a well-developed SS fleet.",
		describe_title = "Recommended Fleet",
		id = 3,
		page_title = "Fleetbuilding Guide - Chapter 13",
		teamid1 = "",
		teamid = {
			1331,
			1332,
			1333
		}
	}
	pg.base.chapter_suggestion_formation[4] = {
		type = 1,
		chapter = 14,
		describe = "Recommended Formation: Double Line Advance. The Vanguard fleet should consist of a highly survivable ship such as a CA or CB in the frontmost position, followed by 2 supporting ships (CL or DD) capable of handling ASW. The Main Fleet should consist of a highly-durable BB and 2 CVs with healing capabilities.",
		describe_title = "Recommended Fleet",
		id = 4,
		page_title = "Fleetbuilding Guide - Chapter 14",
		teamid = {
			1401,
			1402,
			1403
		},
		teamid1 = {
			1404,
			1405,
			1406
		}
	}
	pg.base.chapter_suggestion_formation[5] = {
		type = 2,
		chapter = 14,
		describe = "Recommended Formation: Double Line Advance. The Vanguard fleet should consist of 3 highly survivable ships. The Main Fleet should consist of 1 CV with healing capabilities, and 2 BBs with high damage output.",
		describe_title = "Recommended Fleet",
		id = 5,
		page_title = "Fleetbuilding Guide - Chapter 14",
		teamid = {
			1411,
			1412,
			1413
		},
		teamid1 = {
			1414,
			1415,
			1416
		}
	}
	pg.base.chapter_suggestion_formation[6] = {
		type = 3,
		chapter = 14,
		describe = "It is highly recommended to use a well-developed SS fleet.",
		describe_title = "Recommended Fleet",
		id = 6,
		page_title = "Fleetbuilding Guide - Chapter 14",
		teamid1 = "",
		teamid = {
			1431,
			1432,
			1433
		}
	}
end)()
