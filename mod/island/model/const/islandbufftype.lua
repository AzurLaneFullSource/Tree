local var0_0 = class("IslandBuffType")

var0_0.SHIP_ATTR = 1
var0_0.SHIP_POWER_RECOVER = 2
var0_0.SHIP_PRODUCT_EXTRA = 101
var0_0.SHIP_PRODUCT_RATIO = 102
var0_0.SHIP_PRODUCT_POWER_COST = 103
var0_0.SHIP_MANAGE_SELL_PRICE = 601
var0_0.SHIP_MANAGE_SELL_NUM = 602
var0_0.GLOBAL_MANAGE_SELL_PRICE = 603
var0_0.GLOBAL_MANAGE_SELL_NUM = 604
var0_0.SHIP_POWER_RECOVER_BY_GREETING = 701
var0_0.SHIP_AWARD_BY_GREETING = 702

function var0_0.GetGlobalTypes()
	return {
		var0_0.GLOBAL_MANAGE_SELL_PRICE,
		var0_0.GLOBAL_MANAGE_SELL_NUM
	}
end

function var0_0.IsGlobalType(arg0_2)
	return table.contains(var0_0.GetGlobalTypes(), arg0_2)
end

function var0_0.GetLimitPlaceTypes()
	return {
		var0_0.SHIP_PRODUCT_EXTRA,
		var0_0.SHIP_PRODUCT_RATIO,
		var0_0.SHIP_PRODUCT_POWER_COST
	}
end

function var0_0.IsLimitPlaceType(arg0_4)
	return table.contains(var0_0.GetLimitPlaceTypes(), arg0_4)
end

function var0_0.GetLimitRestaurantTypes()
	return {
		var0_0.SHIP_MANAGE_SELL_PRICE,
		var0_0.SHIP_MANAGE_SELL_NUM,
		var0_0.GLOBAL_MANAGE_SELL_PRICE,
		var0_0.GLOBAL_MANAGE_SELL_NUM
	}
end

function var0_0.IsLimitRestaurantType(arg0_6)
	return table.contains(var0_0.GetLimitRestaurantTypes(), arg0_6)
end

function var0_0.GetGreetingTypes()
	return {
		var0_0.SHIP_POWER_RECOVER_BY_GREETING,
		var0_0.SHIP_AWARD_BY_GREETING
	}
end

function var0_0.IsGreetingType(arg0_8)
	return table.contains(var0_0.GetGreetingTypes(), arg0_8)
end

return var0_0
