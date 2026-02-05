local var0_0 = class("IslandItem", import("model.vo.BaseVO"))

var0_0.TYPE_MATERIAL = 1
var0_0.TYPE_PROP = 2
var0_0.TYPE_SPECIAL_PROP = 3
var0_0.TYPE_SHIP_EXP_BOOK = 5
var0_0.GOLD_ID = 1
var0_0.PEARL_ID = 9900

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.count = arg1_1.num or arg1_1.number or arg1_1.count or 1
	arg0_1.time = arg1_1.time or 0
end

function var0_0.GetNumberOfSlotsOccupied(arg0_2)
	if not arg0_2:IsMaterial() then
		return 0
	end

	if arg0_2.count <= 0 then
		return 0
	end

	local var0_2 = arg0_2:getConfig("group_max")

	if var0_2 == 0 then
		return 1
	else
		return math.ceil(arg0_2.count / var0_2)
	end
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_item_data_template
end

function var0_0.GetCount(arg0_4)
	return arg0_4.count
end

function var0_0.CanRemove(arg0_5, arg1_5)
	return arg1_5 <= arg0_5:GetCount()
end

function var0_0.ReduceCount(arg0_6, arg1_6)
	arg0_6.count = arg0_6.count - arg1_6
end

function var0_0.IncreaseCount(arg0_7, arg1_7)
	arg0_7.count = arg0_7.count + arg1_7
end

function var0_0.IsNotOwned(arg0_8)
	return arg0_8.count <= 0
end

function var0_0.IsInvitationLetter(arg0_9)
	return var0_0.StaticGetUsageType(arg0_9.configId) == IslandItemUsage.usage_island_invitation
end

function var0_0.GetName(arg0_10)
	return arg0_10:getConfig("name")
end

function var0_0.GetType(arg0_11)
	return arg0_11:getConfig("type")
end

function var0_0.GetRarity(arg0_12)
	return arg0_12:getConfig("rarity")
end

function var0_0.GetDesc(arg0_13)
	return arg0_13:getConfig("desc")
end

function var0_0.GetIcon(arg0_14)
	return arg0_14:getConfig("icon")
end

function var0_0.GetUseArg(arg0_15)
	return var0_0.StaticGetUsageArg(arg0_15.configId)
end

function var0_0.GetOwnTime(arg0_16)
	return arg0_16.time
end

function var0_0.IsMaterial(arg0_17)
	return arg0_17:GetType() == var0_0.TYPE_MATERIAL
end

function var0_0.IsProp(arg0_18)
	return arg0_18:GetType() == var0_0.TYPE_PROP or arg0_18:GetType() == var0_0.TYPE_SHIP_EXP_BOOK
end

function var0_0.IsSpecialProp(arg0_19)
	return arg0_19:GetType() == var0_0.TYPE_SPECIAL_PROP
end

function var0_0.IsFishingProp(arg0_20)
	return var0_0.StaticGetUsageType(arg0_20.configId) == IslandItemUsage.usage_fishing
end

function var0_0.GetMaterialFacility(arg0_21)
	if not arg0_21:IsMaterial() then
		return ""
	end

	return ""
end

function var0_0.CanConvert(arg0_22)
	return arg0_22:getConfig("convert") == 1
end

function var0_0.GetConvertPt(arg0_23)
	return arg0_23:getConfig("pt_num")
end

function var0_0.StaticGetMapUsageList(arg0_24)
	return pg.island_item_data_template.get_id_list_by_usage[arg0_24] or {}
end

function var0_0.StaticGetUsageArg(arg0_25)
	return pg.island_item_data_template[arg0_25].usage_arg
end

function var0_0.StaticGetUsageType(arg0_26)
	return pg.island_item_data_template[arg0_26].usage
end

function var0_0.GetAcquiringWay(arg0_27)
	local var0_27 = {}
	local var1_27 = pg.island_item_data_template[arg0_27.configId]

	for iter0_27, iter1_27 in ipairs(var1_27.jump_page) do
		table.insert(var0_27, iter1_27)
	end

	return var0_27
end

return var0_0
