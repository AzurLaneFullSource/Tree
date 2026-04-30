pg = pg or {}
pg.child2_resource = rawget(pg, "child2_resource") or setmetatable({
	__name = "child2_resource"
}, confNEO)
pg.child2_resource.all = {
	1,
	2,
	3,
	4,
	301,
	302,
	303,
	304,
	305,
	306
}
pg.child2_resource.get_id_list_by_character = {
	{
		1,
		2,
		3,
		4
	},
	{
		301,
		302,
		303,
		304,
		305,
		306
	}
}
pg.base = pg.base or {}
pg.base.child2_resource = {}

;(function()
	pg.base.child2_resource[1] = {
		default_value = 50,
		name = "Funds",
		icon = "res_jinqian",
		type = 1,
		max_value = 99999,
		min_value = 0,
		desc = "Money that is used in all sorts of scenarios in Project Identity.",
		character = 1,
		id = 1,
		item_icon = "res_jinqian2"
	}
	pg.base.child2_resource[2] = {
		default_value = 50,
		name = "Mood",
		icon = "res_xinqing",
		type = 2,
		max_value = 100,
		min_value = 0,
		desc = "$1\nMood affects how many stats and Funds you get.\n0 - 19: Depressed - 40% less Funds\n20 to 39: Sad - 20% less Funds\n40 to 59: Normal - No effect\n60 to 100: Happy - 40% more Funds",
		character = 1,
		id = 2,
		item_icon = "res_xinqing2"
	}
	pg.base.child2_resource[3] = {
		default_value = 3,
		name = "Action points",
		icon = "res_xingdongli",
		type = 3,
		max_value = 3,
		min_value = 0,
		desc = "Used for going outside. Automatically recovers every turn.",
		character = 1,
		id = 3,
		item_icon = "res_xingdongli2"
	}
	pg.base.child2_resource[4] = {
		default_value = 50,
		name = "Affection",
		icon = "res_haogandu",
		type = 4,
		max_value = 500,
		min_value = 0,
		desc = "Having main screen conversations can increase your Affection.\nYou can get rewards from increasing your Affection as well.",
		character = 1,
		id = 4,
		item_icon = "res_haogandu2"
	}
	pg.base.child2_resource[301] = {
		default_value = 50,
		name = "Funds",
		icon = "res_jinqian",
		type = 1,
		max_value = 99999,
		min_value = 0,
		desc = "Money that is used in all sorts of scenarios in Project Identity.",
		character = 2,
		id = 301,
		item_icon = "res_jinqian2"
	}
	pg.base.child2_resource[302] = {
		default_value = 50,
		name = "Mood",
		icon = "res_xinqing",
		type = 2,
		max_value = 100,
		min_value = 0,
		desc = "$1\nMood affects how many stats and Funds you get.\n0 - 19: Depressed - 40% less Funds\n20 to 39: Sad - 20% less Funds\n40 to 59: Normal - No effect\n60 to 100: Happy - 40% more Funds",
		character = 2,
		id = 302,
		item_icon = "res_xinqing2"
	}
	pg.base.child2_resource[303] = {
		default_value = 3,
		name = "Action Points",
		icon = "res_xingdongli",
		type = 3,
		max_value = 99,
		min_value = 0,
		desc = "AP, used for going outside. Automatically recovers every turn.",
		character = 2,
		id = 303,
		item_icon = "res_xingdongli2"
	}
	pg.base.child2_resource[304] = {
		default_value = 50,
		name = "Affection",
		icon = "res_haogandu",
		type = 4,
		max_value = 500,
		min_value = 0,
		desc = "Having main screen conversations can increase your Affection.\nYou can get rewards from increasing your Affection as well.",
		character = 2,
		id = 304,
		item_icon = "res_haogandu2"
	}
	pg.base.child2_resource[305] = {
		default_value = 0,
		name = "Refreshes",
		icon = "res_refresh1",
		type = 5,
		max_value = 3,
		min_value = 0,
		desc = "Use refreshes at the Fortune Teller to change the lineup",
		character = 2,
		id = 305,
		item_icon = "res_refresh1"
	}
	pg.base.child2_resource[306] = {
		default_value = 5,
		name = "Redraws",
		icon = "res_refresh2",
		type = 6,
		max_value = 500,
		min_value = 0,
		desc = "Use redraws on the selection screen to change the tarot cards and the reading",
		character = 2,
		id = 306,
		item_icon = "res_refresh2"
	}
end)()
