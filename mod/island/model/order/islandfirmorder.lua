local var0_0 = class("IslandFirmOrder", import(".IslandOrder"))

var0_0.FIRM_ORDER_TYPE_COMMON = 1
var0_0.FIRM_ORDER_TYPE_URGENCY = 2
var0_0.FIRM_ORDER_TYPE_ACT = 3

function var0_0.IsFirm(arg0_1)
	return true
end

function var0_0.CanReplace(arg0_2)
	return false
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_order
end

function var0_0.IsEmpty(arg0_4)
	return arg0_4.showFlag == IslandOrderSlot.SHOW_FLAG_TOMORROW
end

function var0_0.GetAwardItemAndExp(arg0_5)
	local var0_5 = arg0_5:getConfig("award")
	local var1_5, var2_5 = arg0_5:GenAwards(var0_5)
	local var3_5 = arg0_5:GenPtAwards()

	if var3_5 then
		table.insert(var1_5, var3_5)
	end

	return var1_5, var2_5
end

function var0_0.GenPtAwards(arg0_6)
	local var0_6 = arg0_6:getConfig("season_pt_num")

	if var0_6 > 0 then
		return {
			id = 0,
			type = VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT,
			count = var0_6 or 0
		}
	end

	return nil
end

function var0_0.GetActivityId(arg0_7)
	return arg0_7:getConfig("activity_id")
end

function var0_0.GetGroupId(arg0_8)
	return arg0_8:getConfig("group_id")
end

return var0_0
