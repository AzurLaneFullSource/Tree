local var0_0 = class("IslandOrder", import("model.vo.BaseVO"))

var0_0.TYPE_NORMAL = 1
var0_0.TYPE_URGENCY = 2
var0_0.TYPE_FORM = 4

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1:Flush(arg1_1)
end

function var0_0.Flush(arg0_2, arg1_2)
	arg0_2.id = arg1_2.dialog_id
	arg0_2.configId = arg0_2.id
	arg0_2.tendency = arg1_2.cur_select
	arg0_2.startTime = arg1_2.start_time
	arg0_2.submitTime = arg1_2.submit_time
	arg0_2.reduceTime = 0
	arg0_2.showFlag = arg1_2.view_flag
	arg0_2.consumeList = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.cost or {}) do
		table.insert(arg0_2.consumeList, {
			type = DROP_TYPE_ISLAND_ITEM,
			id = iter1_2.id,
			count = iter1_2.num
		})
	end

	arg0_2.orderLevel = arg1_2.order_lv or 1
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
	local var0_10, var1_10 = arg0_10:GetAwardItemAndExp()

	if var1_10 > 0 then
		table.insert(var0_10, {
			id = 2,
			type = DROP_TYPE_ISLAND_ITEM,
			count = var1_10
		})
	end

	return var0_10
end

function var0_0.GetAwardConfigByTendency(arg0_11, arg1_11)
	local var0_11 = pg.island_order_price[arg1_11]

	assert(var0_11, "order config not found, level: " .. arg1_11)

	local var1_11 = arg0_11:GetTendency()

	if arg0_11:IsUrgency() then
		return var0_11.order_award_special
	end

	if IslandOrderSlot.TENDENCY_TYPE_COMMON == var1_11 then
		return var0_11.order_award
	elseif IslandOrderSlot.TENDENCY_TYPE_EASY == var1_11 then
		return var0_11.order_easy_award
	elseif IslandOrderSlot.TENDENCY_TYPE_HARD == var1_11 then
		return var0_11.order_award_challenge
	end

	assert(false, "unknown order tendency: " .. arg1_11 .. tostring(var1_11))
end

function var0_0.GenAwards(arg0_12, arg1_12)
	local var0_12 = arg1_12[1]
	local var1_12 = {}

	table.insert(var1_12, {
		id = 1,
		type = DROP_TYPE_ISLAND_ITEM,
		count = arg1_12[2]
	})

	return var1_12, var0_12
end

function var0_0.GetAwardItemAndExp(arg0_13)
	local var0_13 = arg0_13:GetAwardConfigByTendency(arg0_13.orderLevel)

	return arg0_13:GenAwards(var0_13)
end

function var0_0.GetRoleIcon(arg0_14)
	local var0_14 = arg0_14:getConfig("npc_id")

	return pg.island_unit_character[var0_14].IslandShipIcon
end

function var0_0.GetRoleName(arg0_15)
	local var0_15 = arg0_15:getConfig("npc_id")

	return pg.island_unit_character[var0_15].name
end

function var0_0.IsUrgency(arg0_16)
	return false
end

function var0_0.IsActivity(arg0_17)
	return false
end

function var0_0.IsFirm(arg0_18)
	return false
end

function var0_0.GetTitle(arg0_19)
	return i18n("island_order_type_1")
end

function var0_0.IsEmpty(arg0_20)
	return arg0_20.showFlag == IslandOrderSlot.SHOW_FLAG_TOMORROW and arg0_20:IsLoading()
end

function var0_0.IsLoading(arg0_21)
	return pg.TimeMgr.GetInstance():GetServerTime() < arg0_21:GetCanSubmitTime()
end

function var0_0.CanReplace(arg0_22)
	return not arg0_22:IsEmpty() and not arg0_22:IsLoading()
end

function var0_0.GetTotalTime(arg0_23)
	return arg0_23.submitTime - arg0_23.startTime
end

function var0_0.GetDisappearTime(arg0_24)
	return -1
end

function var0_0.GetCanSubmitTime(arg0_25)
	return arg0_25.submitTime - arg0_25.reduceTime
end

function var0_0.SetReduceTime(arg0_26, arg1_26)
	arg0_26.reduceTime = arg1_26
end

function var0_0.AddReduceTime(arg0_27, arg1_27)
	arg0_27.reduceTime = arg0_27.reduceTime + arg1_27
end

return var0_0
