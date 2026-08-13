local var0_0 = {}

var0_0.GAME_ID = 89
var0_0.menu_bgm = "story-richang-6"
var0_0.game_bgm = "story-richang-6"
var0_0.ui_atlas = "ui/minigameui/crossroadgameui_atlas"
var0_0.game_ui = "CrossRoadGameUI"
var0_0.RECODE_NONE = "你怎么还一把没玩过/n快去启动！！！"
var0_0.RECODE_NORMAL = "你上次记录的分数是"
var0_0.GET_SCORE = "CrossRoadGameScene:GET_SCORE"
var0_0.HIT_ROLER = "CrossRoadGameScene:HIT_ROLER"
var0_0.GET_HONGCHA = "CrossRoadGameScene: GET_HONGCHA"
var0_0.BACK_ROAD_NAME = "back_raod_name"
var0_0.SCENE_ROAD_NAME = "scene_road_name"
var0_0.FRONT_ROAD_NAME = "front_road_name"
var0_0.SP_ROAD_NAME = "sp_raod_name"
var0_0.NEW_ROUND = "NEW_ROUND"
var0_0.MAKE_BING_MIAN = "make bing mian"
var0_0.MAKE_XUAN_WO = "make xuan wo"
var0_0.ADD_ROLE = "add role"
var0_0.DISPOSE_BIN = "dispose bin"
var0_0.XINZEXI = 102
var0_0.BING_MIAN = 3
var0_0.XUAN_WO = 2
var0_0.EPS = 0.001
var0_0.GAME_TIME = 2400000
var0_0.GAME_TRACK_COUNT = 6
var0_0.FIRST_CAR_TIQIAN_TIME = -5
var0_0.START_CAR_SCALE = 0.5
var0_0.ADD_CAR_SCALE = 0.7
var0_0.WALKER_LINE_UNNDER = 250
var0_0.WALKER_GO_AGIN_TIME = 5
var0_0.CAR_SPEED_SCALE = 0.4
var0_0.PLAYER_DISTANCE = 200
var0_0.SHOW_GROUP_TIME = 5
var0_0.PLAYER_SELECT_TIME = 0.5
var0_0.CAN_ANGRY_TIME = 5
var0_0.ONCE_ANGRY_TIME = 2
var0_0.XUANWO_STOP_PERCENT = 40
var0_0.HONGCHA_PERCENT = 100
var0_0.SP_CAR_ID = {
	[101] = true,
	[102] = true
}
var0_0.SHIP_TPL = {
	"aierdeliqi_tpl",
	"edu_tpl",
	"huoli_tpl",
	"kunibeierdi_tpl",
	"lemaer_tpl",
	"maoyue_tpl",
	"muyue_tpl",
	"nubiyaren_tpl",
	"shuiwuyue_tpl",
	"wanpi_tpl",
	"xiaotiane_tpl",
	"yanusi_tpl",
	"yinghuochong_tpl",
	"z19_tpl"
}
var0_0.CAR_TPL = {
	"daqinghuayu_tpl",
	"xinzexi_tpl",
	"zibao_tpl",
	"jinbi_tpl",
	"yulei_tpl",
	"weixiu_tpl"
}
var0_0.ITEM_TPL = {
	"hongcha_tpl",
	"xuanwo_tpl",
	"bingmian_tpl"
}
var0_0.CAR_STATE = {
	going = 4,
	needDestroy = 6,
	goEnd = 5,
	goTrack = 2,
	showBack = 1,
	goSideWalk = 3
}
var0_0.SHIP_STATE = {
	walk = 2,
	stop = 1,
	crash = 5,
	select = 4,
	angry = 3
}
var0_0.SHIP_STATE_ACTION = {
	normal = "normal",
	crash = "crash",
	walk = "walk"
}
var0_0.PLAYER_STATE = {
	stop_walk = "stop_walk",
	stop = "stop",
	crash = "crash",
	walk = "walk",
	sign = "sign",
	sign_walk = "sign_walk",
	normal = "normal",
	recover = "recover"
}
var0_0.SP_CAR_MOVE = {
	moveEnd = 4,
	start = 1,
	mid = 2
}
var0_0.COMOBO_TIME = 3
var0_0.ROLE_COMOBO_LV = {
	2,
	3,
	4
}
var0_0.SCORE_LIST = {
	50,
	100,
	150,
	200,
	250,
	300,
	350,
	400,
	450,
	500,
	550,
	600,
	650,
	700,
	750,
	800,
	850,
	900
}
var0_0.TIME_MOVE_SPEED_UP = 1e-05

local function var1_0(arg0_1, arg1_1)
	local var0_1 = pg.gameset[arg0_1]

	return var0_1 and var0_1.key_value or arg1_1
end

local function var2_0(arg0_2, arg1_2)
	local var0_2 = pg.gameset[arg0_2]

	return var0_2 and var0_2.description or arg1_2
end

var0_0.LIFE_COUNT = var1_0("minigame_crossroad_dead", 5)
var0_0.CHILD_SPEED = var1_0("minigame_crossroad_child_speed", 100)
var0_0.CHILD_RUSH_SPEED = var1_0("crossroad_speed_down", 33)
var0_0.MAKE_CAR_TIME = var2_0("minigame_crossroad_ship_appears", {
	8,
	7.8,
	7.5,
	7,
	6.5,
	6
})
var0_0.CAR_SPEED_SCALE = var2_0("minigame_crossroad_speed_up", {
	0.2,
	0.4,
	0.6,
	0.8,
	1,
	1.2,
	1.4,
	1.6,
	1.8,
	2
})
var0_0.CHILD_ANGER_TIME = var2_0("minigame_crossroad_child_time", {
	3,
	5
})
var0_0.SCORE_ONE = var1_0("minigame_crossroad_points3", 50)
var0_0.SCORE_GROUP = var1_0("minigame_crossroad_points2", 300)
var0_0.SCORE_BASE = var1_0("minigame_crossroad_points1", 100)
var0_0.PLAYER_SPEED = var1_0("minigame_crossroad_command_speed", 300)
var0_0.XUANWO_LIFE_TIME = var1_0("minigame_crossroad_prop1_time", 5)
var0_0.XUANWO_MAKE_PROBABILITY = var1_0("minigame_crossroad_prop1_probability", 30)
var0_0.HONGCHA_GET_LIFE = var1_0("minigame_crossroad_prop2_recover", 1)
var0_0.HONGCHA_MISS_TIME = var1_0("minigame_crossroad_prop2_time", 5)
var0_0.BINGMIAN_DISTANCE = var1_0("minigame_crossroad_prop3_distance", 170)
var0_0.BINGMIAN_LIFE_TIME = var1_0("minigame_crossroad_prop3_time", 6)
var0_0.BINGMIAN_MAKE_PROBABILITY = var1_0("minigame_crossroad_prop3_probability", 30)
var0_0.ANGRY_PERCENT = var1_0("minigame_crossroad_child_impulse", 40)

return ((function(arg0_3)
	local function var0_3(arg0_4)
		local var0_4 = {}
		local var1_4 = {
			__index = arg0_4,
			__newindex = function(arg0_5, arg1_5, arg2_5)
				error("attempt to modify a read-only table", 2)
			end,
			__pairs = function()
				return pairs(arg0_3)
			end,
			__ipairs = function()
				return ipairs(arg0_3)
			end,
			__len = function()
				return #arg0_3
			end,
			__tostring = function()
				return "read-only table"
			end
		}

		setmetatable(var0_4, var1_4)

		for iter0_4, iter1_4 in pairs(arg0_4) do
			if type(iter1_4) == "table" then
				var0_3(iter1_4)
			end
		end

		return var0_4
	end

	return var0_3(arg0_3)
end)(var0_0))
