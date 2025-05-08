local var0_0 = class("IslandAblityAgency", import(".IslandBaseAgency"))

var0_0.UNLCOK_SYSTEM = "IslandAblityAgency:UNLCOK_SYSTEM"
var0_0.TYPE_SYSTEM = 1
var0_0.TYPE_PLACE = 2
var0_0.TYPE_FORMULA = 3
var0_0.TYPE_SHOP_NORMAL = 4
var0_0.TYPE_SHOP_TEMPORARY = 7
var0_0.TYPE_ORDER = 8
var0_0.TYPE_SLOT = 9
var0_0.TYPE_MAP = 11

function var0_0.OnInit(arg0_1, arg1_1)
	arg0_1.abilitys = {}

	for iter0_1, iter1_1 in ipairs(arg1_1.ability_list or {}) do
		table.insert(arg0_1.abilitys, iter1_1)
	end
end

function var0_0.AddAblity(arg0_2, arg1_2)
	table.insert(arg0_2.abilitys, arg1_2)

	if var0_0.GetAblityType(arg1_2) == var0_0.TYPE_SYSTEM then
		arg0_2:DispatchEvent(var0_0.UNLCOK_SYSTEM, arg1_2)
	end
end

function var0_0.IsUnlockMap(arg0_3, arg1_3)
	return _.any(arg0_3.abilitys, function(arg0_4)
		return var0_0.IsMapType(arg0_4) and var0_0.GetEffect(arg0_4) == arg1_3
	end)
end

function var0_0.IsUnlockShipOrder(arg0_5, arg1_5)
	return _.any(arg0_5.abilitys, function(arg0_6)
		return var0_0.IsOrderType(arg0_6) and var0_0.GetEffect(arg0_6) == arg1_5
	end)
end

function var0_0.IsUnlockFormuate(arg0_7, arg1_7)
	return _.any(arg0_7.abilitys, function(arg0_8)
		return var0_0.IsFormuateType(arg0_8) and var0_0.GetEffect(arg0_8) == arg1_7
	end)
end

function var0_0.HasAbility(arg0_9, arg1_9)
	return _.any(arg0_9.abilitys, function(arg0_10)
		return arg1_9 == arg0_10
	end)
end

function var0_0.IsMapType(arg0_11)
	return pg.island_ability_template[arg0_11].type == var0_0.TYPE_MAP
end

function var0_0.IsOrderType(arg0_12)
	return pg.island_ability_template[arg0_12].type == var0_0.TYPE_ORDER
end

function var0_0.IsShopTypeNormal(arg0_13)
	return pg.island_ability_template[arg0_13].type == var0_0.TYPE_SHOP_NORMAL
end

function var0_0.IsShopTypeTemporary(arg0_14)
	return pg.island_ability_template[arg0_14].type == var0_0.TYPE_SHOP_TEMPORARY
end

function var0_0.IsCommodityType(arg0_15)
	return pg.island_ability_template[arg0_15].type == var0_0.TYPE_COMMODITY
end

function var0_0.IsFormuateType(arg0_16)
	return pg.island_ability_template[arg0_16].type == var0_0.TYPE_FORMULA
end

function var0_0.GetAblityType(arg0_17)
	return pg.island_ability_template[arg0_17].type
end

function var0_0.GetEffect(arg0_18)
	return pg.island_ability_template[arg0_18].effect
end

return var0_0
