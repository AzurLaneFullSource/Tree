local var0_0 = class("IslandAblityAgency", import(".IslandBaseAgency"))

var0_0.UNLOCK_SYSTEM = "IslandAblityAgency:UNLOCK_SYSTEM"
var0_0.TYPE_SYSTEM = 1
var0_0.TYPE_PLACE = 2
var0_0.TYPE_FORMULA = 3
var0_0.TYPE_SHOP_NORMAL = 4
var0_0.TYPE_INVENTORY_MAXCNT = 6
var0_0.TYPE_SHOP_TEMPORARY = 7
var0_0.TYPE_ORDER = 8
var0_0.TYPE_SLOT = 9
var0_0.TYPE_MAP = 11
var0_0.TYPE_ANIMAL = 15
var0_0.TYPE_RESTAURANT = 17
var0_0.TYPE_ASSISTANT = 18
var0_0.TYPE_COLLECT_TOOL = 19
var0_0.TYPE_ORDER_DAILY_CNT = 20
var0_0.TYPE_SIGN_GIFT_CNT = 21
var0_0.TYPE_RECOVER_CAMP = 22
var0_0.TYPE_RECOVER_ORE = 23
var0_0.TYPE_SECOND_PRODUCT = 24
var0_0.TYPE_PRODUCT_FELLING = 26
var0_0.TYPE_PRODUCT_MINING = 27
var0_0.TYPE_ORDER_EXP = 31
var0_0.TYPE_POST_MANAGE = 37
var0_0.TYPE_PRODUCT_FARM = 38
var0_0.TYPE_PRODUCT_ORCHARD = 39
var0_0.TYPE_PRODUCT_GARDEN = 40
var0_0.TYPE_FISHING_ROD = 41
var0_0.TYPE_PRODUCT_FISH = 42
var0_0.ANIMATION_OP_ID = 40
var0_0.SET_MEAL_ID = 29001

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.abilitys = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.ability_list or {}) do
		table.insert(arg0_1.abilitys, iter1_1)
	end
end

function var0_0.AddAblity(arg0_2, arg1_2)
	table.insert(arg0_2.abilitys, arg1_2)

	if var0_0.GetAblityType(arg1_2) == var0_0.TYPE_SYSTEM then
		arg0_2:DispatchEvent(var0_0.UNLOCK_SYSTEM, arg1_2)
	end

	if var0_0.IsMapType(arg1_2) then
		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandUnlockMap(var0_0.GetEffect(arg1_2)))
		getProxy(IslandProxy):GetIsland():GetTechnologyAgency():TryAutoUnlock()
	end
end

function var0_0.IsUnlockOrderExp(arg0_3)
	return _.any(arg0_3.abilitys, function(arg0_4)
		return var0_0.IsOrderExpType(arg0_4)
	end)
end

function var0_0.IsUnlockPostManage(arg0_5)
	return _.any(arg0_5.abilitys, function(arg0_6)
		return var0_0.GetAblityType(arg0_6) == var0_0.TYPE_POST_MANAGE
	end)
end

function var0_0.IsUnlockMap(arg0_7, arg1_7)
	return _.any(arg0_7.abilitys, function(arg0_8)
		return var0_0.IsMapType(arg0_8) and var0_0.GetEffect(arg0_8) == arg1_7
	end)
end

function var0_0.IsUnlockShipOrder(arg0_9, arg1_9)
	return _.any(arg0_9.abilitys, function(arg0_10)
		return var0_0.IsOrderType(arg0_10) and var0_0.GetEffect(arg0_10) == arg1_9
	end)
end

function var0_0.IsUnlockFormuate(arg0_11, arg1_11)
	return _.any(arg0_11.abilitys, function(arg0_12)
		return var0_0.IsFormuateType(arg0_12) and var0_0.GetEffect(arg0_12) == arg1_11
	end)
end

function var0_0.IsUnlcokSecondProduct(arg0_13, arg1_13)
	return _.any(arg0_13.abilitys, function(arg0_14)
		return var0_0.IsSecondProductType(arg0_14) and var0_0.GetEffect(arg0_14) == arg1_13
	end)
end

function var0_0.IsUnlockCollectTool(arg0_15, arg1_15)
	return _.any(arg0_15.abilitys, function(arg0_16)
		return var0_0.IsCollectToolType(arg0_16) and var0_0.GetEffect(arg0_16) == arg1_15
	end)
end

function var0_0.IsUnlockAreaPlant(arg0_17)
	return _.any(arg0_17.abilitys, function(arg0_18)
		return var0_0.GetAblityType(arg0_18) == var0_0.TYPE_SYSTEM and var0_0.GetEffect(arg0_18) == 17
	end)
end

function var0_0.IsUnlockFishing(arg0_19)
	return _.any(arg0_19.abilitys, function(arg0_20)
		return var0_0.GetAblityType(arg0_20) == var0_0.TYPE_SYSTEM and var0_0.GetEffect(arg0_20) == 25
	end)
end

function var0_0.HasAbility(arg0_21, arg1_21)
	if arg1_21 == 0 then
		return true
	end

	return _.any(arg0_21.abilitys, function(arg0_22)
		return arg1_21 == arg0_22
	end)
end

function var0_0.GetOrderDailyCntAddition(arg0_23)
	local var0_23 = 0

	for iter0_23, iter1_23 in ipairs(arg0_23.abilitys) do
		if var0_0.IsOrderDailyCntType(iter1_23) then
			var0_23 = var0_23 + pg.island_ability_template[iter1_23].effect
		end
	end

	return var0_23
end

function var0_0.GetProductAdditionSpeedByAblityType(arg0_24, arg1_24)
	local var0_24 = 0

	for iter0_24, iter1_24 in ipairs(arg0_24.abilitys) do
		local var1_24 = pg.island_ability_template[iter1_24]

		if var1_24.type == arg1_24 then
			var0_24 = var0_24 + var1_24.effect
		end
	end

	return var0_24
end

function var0_0.GetAdditionEffectByAblityType(arg0_25, arg1_25)
	local var0_25 = 0

	for iter0_25, iter1_25 in ipairs(arg0_25.abilitys) do
		local var1_25 = pg.island_ability_template[iter1_25]

		if var1_25.type == arg1_25 then
			var0_25 = var0_25 + var1_25.effect
		end
	end

	return var0_25
end

function var0_0.GetSignInGiftAddition(arg0_26)
	local var0_26 = 0

	for iter0_26, iter1_26 in ipairs(arg0_26.abilitys) do
		if var0_0.IsSignInGiftType(iter1_26) then
			var0_26 = var0_26 + pg.island_ability_template[iter1_26].effect
		end
	end

	return var0_26
end

function var0_0.GetInventoryMaxCntAddition(arg0_27)
	local var0_27 = 0

	for iter0_27, iter1_27 in ipairs(arg0_27.abilitys) do
		if var0_0.IsInventoryMaxCntType(iter1_27) then
			var0_27 = var0_27 + pg.island_ability_template[iter1_27].effect
		end
	end

	return var0_27
end

function var0_0.IsInventoryMaxCntType(arg0_28)
	return pg.island_ability_template[arg0_28].type == var0_0.TYPE_INVENTORY_MAXCNT
end

function var0_0.IsSignInGiftType(arg0_29)
	local var0_29 = pg.island_ability_template[arg0_29]

	assert(var0_29, "island_ability_template" .. arg0_29)

	return var0_29.type == var0_0.TYPE_SIGN_GIFT_CNT
end

function var0_0.IsOrderDailyCntType(arg0_30)
	return pg.island_ability_template[arg0_30].type == var0_0.TYPE_ORDER_DAILY_CNT
end

function var0_0.IsMapType(arg0_31)
	local var0_31 = pg.island_ability_template[arg0_31]

	assert(var0_31, "island_ability_template >>>>" .. arg0_31)

	return var0_31.type == var0_0.TYPE_MAP
end

function var0_0.IsOrderType(arg0_32)
	return pg.island_ability_template[arg0_32].type == var0_0.TYPE_ORDER
end

function var0_0.IsShopTypeNormal(arg0_33)
	return pg.island_ability_template[arg0_33].type == var0_0.TYPE_SHOP_NORMAL
end

function var0_0.IsShopTypeTemporary(arg0_34)
	return pg.island_ability_template[arg0_34].type == var0_0.TYPE_SHOP_TEMPORARY
end

function var0_0.IsCommodityType(arg0_35)
	return pg.island_ability_template[arg0_35].type == var0_0.TYPE_COMMODITY
end

function var0_0.IsFormuateType(arg0_36)
	return pg.island_ability_template[arg0_36].type == var0_0.TYPE_FORMULA
end

function var0_0.IsSecondProductType(arg0_37)
	return pg.island_ability_template[arg0_37].type == var0_0.TYPE_SECOND_PRODUCT
end

function var0_0.IsCollectToolType(arg0_38)
	return pg.island_ability_template[arg0_38].type == var0_0.TYPE_COLLECT_TOOL
end

function var0_0.GetAblityType(arg0_39)
	return pg.island_ability_template[arg0_39].type
end

function var0_0.GetEffect(arg0_40)
	return pg.island_ability_template[arg0_40].effect
end

function var0_0.IsOrderExpType(arg0_41)
	return pg.island_ability_template[arg0_41].type == var0_0.TYPE_ORDER_EXP
end

return var0_0
