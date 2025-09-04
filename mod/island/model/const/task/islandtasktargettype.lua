local var0_0 = class("IslandTaskTargetType")

var0_0.INTERACTION = 1
var0_0.APPROACH = 2
var0_0.ORDER = 3
var0_0.RECYCLE = 4
var0_0.OBTAIN = 5
var0_0.HAND_GATHER = 6
var0_0.PRODUCTION = 7
var0_0.TECHNOLOGY = 8
var0_0.ISLAND_LV = 9
var0_0.FRAGMENT = 10
var0_0.UNLOCK_SHIP = 11
var0_0.SHIP_ORDER = 12
var0_0.SIGN_IN = 13
var0_0.HAND_PROD = 14
var0_0.FURNITURE = 15
var0_0.COMMANDER_DRESS = 16
var0_0.SHIP_DRESS = 17
var0_0.SHIP_SKIN = 18
var0_0.SKIN_ALL_COLOR = 19
var0_0.SKIN_COLOR = 20
var0_0.ACHIEVEMENT = 21
var0_0.TASK = 22
var0_0.TASK_TYPE = 23
var0_0.HAND_PROD_PLUS = 24
var0_0.GIVE_GIFT = 25
var0_0.PRDO_ITEM = 26
var0_0.RESTAURANT_SHELVE = 27
var0_0.RESTAURANT_SELL = 28
var0_0.RESTAURANT_SALES = 29
var0_0.RESTAURANT_RANK = 30
var0_0.RESTAURANT_OPEN = 31
var0_0.SHIP_EXP_BOOK = 32
var0_0.SHIP_SKILL_UPGRADE = 33
var0_0.STORY = 34

function var0_0.GetRuntimeTypes()
	return {
		var0_0.RECYCLE,
		var0_0.ISLAND_LV,
		var0_0.FURNITURE,
		var0_0.COMMANDER_DRESS,
		var0_0.SHIP_DRESS,
		var0_0.SHIP_SKIN,
		var0_0.SKIN_ALL_COLOR,
		var0_0.SKIN_COLOR,
		var0_0.ACHIEVEMENT,
		var0_0.TASK,
		var0_0.RESTAURANT_RANK,
		var0_0.STORY
	}
end

function var0_0.GetClientTypes()
	return {
		var0_0.INTERACTION,
		var0_0.APPROACH
	}
end

function var0_0.GetObjectLinkTypes()
	return {
		var0_0.INTERACTION,
		var0_0.APPROACH
	}
end

return var0_0
