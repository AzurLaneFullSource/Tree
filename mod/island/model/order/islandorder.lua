local var0_0 = class("IslandOrder", import("model.vo.BaseVO"))

var0_0.TYPE_NORMAL = 1
var0_0.TYPE_URGENCY = 2
var0_0.TYPE_FORM = 3

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:Flush(arg1_1)
end

function var0_0.Flush(arg0_2, arg1_2)
	arg0_2.id = arg1_2.dialog_id
	arg0_2.configId = arg0_2.id
	arg0_2.tendency = arg1_2.daily_select
	arg0_2.startTime = arg1_2.start_time
	arg0_2.submitTime = arg1_2.submit_time
	arg0_2.showFlag = arg1_2.view_flag
	arg0_2.consumeList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.cost or {}) do
		table.insert(arg0_2.consumeList, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_2.id,
			count = iter1_2.num
		})
	end

	arg0_2.awardList = {}

	local var0_2 = arg1_2.reward or {}

	for iter2_2, iter3_2 in ipairs(var0_2.item_list) do
		table.insert(arg0_2.awardList, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter3_2.id,
			count = iter3_2.num
		})
	end

	arg0_2.dropExp = var0_2.exp or 0
end

function var0_0.bindConfigTable(arg0_3)
	return pg.island_order_publish_random
end

function var0_0.GetExpValue(arg0_4)
	return pg.island_set.order_favor.key_value_int
end

function var0_0.GetTendency(arg0_5)
	return arg0_5.tendency
end

function var0_0.CanFinish(arg0_6)
	local var0_6 = arg0_6:GetConsume()

	return _.all(var0_6, function(arg0_7)
		return Drop.New({
			type = arg0_7.type,
			id = arg0_7.id
		}):getOwnedCount() >= arg0_7.count
	end)
end

function var0_0.GetDesc(arg0_8)
	return arg0_8:getConfig("desc")
end

function var0_0.GetConsume(arg0_9)
	return arg0_9.consumeList
end

function var0_0.GetDisplayAwards(arg0_10)
	if arg0_10.dropExp > 0 then
		local var0_10 = {}

		for iter0_10, iter1_10 in ipairs(arg0_10.awardList) do
			table.insert(var0_10, iter1_10)
		end

		table.insert(var0_10, {
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = arg0_10.dropExp
		})

		return var0_10
	else
		return arg0_10.awardList
	end
end

function var0_0.GetAwardItemAndExp(arg0_11)
	return arg0_11.awardList, arg0_11.dropExp
end

function var0_0.GetRoleIcon(arg0_12)
	local var0_12 = arg0_12:getConfig("npc_id")

	return IslandShip.StaticGetPrefab(var0_12)
end

function var0_0.GetRoleName(arg0_13)
	local var0_13 = arg0_13:getConfig("npc_id")
	local var1_13 = IslandShip.StaticGetShipGroup(var0_13)

	return ShipGroup.getDefaultShipConfig(var1_13).name
end

function var0_0.IsUrgency(arg0_14)
	return false
end

function var0_0.IsFirm(arg0_15)
	return false
end

function var0_0.GetTitle(arg0_16)
	return i18n1("普通订单")
end

function var0_0.IsEmpty(arg0_17)
	return arg0_17.showFlag == IslandOrderSlot.SHOW_FLAG_TOMORROW and arg0_17:IsLoading()
end

function var0_0.IsLoading(arg0_18)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_18.submitTime
end

function var0_0.CanReplace(arg0_19)
	return not arg0_19:IsEmpty() and not arg0_19:IsLoading()
end

function var0_0.GetTotalTime(arg0_20)
	return arg0_20.submitTime - arg0_20.startTime
end

function var0_0.GetDisappearTime(arg0_21)
	return -1
end

function var0_0.GetCanSubmitTime(arg0_22)
	return arg0_22.submitTime
end

return var0_0
