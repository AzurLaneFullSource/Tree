local var0_0 = class("IslandRestaurant", import("model.vo.BaseVO"))

var0_0.STATUS = {
	PREPARE = "prepare",
	END = "end",
	OPENING = "opening",
	CLOSE = "close"
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.level = arg1_1.lv or 1
	arg0_1.rankCfg = pg.island_manage_rank[arg0_1.level] or 1
	arg0_1.sales = arg1_1.total_sell or 0

	arg0_1:SetCommodities(arg1_1.sell_list or {}, arg1_1.rest_list or {})
	arg0_1:SetAssistants(arg1_1.post_list or {})
	arg0_1:SetEndTime(arg1_1.end_time or 0)
end

function var0_0.bindConfigTable(arg0_2)
	return pg.island_manage_restaurant
end

function var0_0.SetCommodities(arg0_3, arg1_3, arg2_3)
	arg0_3.commodities = {}
	arg0_3.sellCommodities = {}
	arg0_3.remainCommodities = {}

	for iter0_3, iter1_3 in ipairs(arg1_3) do
		local var0_3 = iter1_3.food_id
		local var1_3 = iter1_3.num
		local var2_3 = iter1_3.sell_money

		table.insert(arg0_3.sellCommodities, {
			id = var0_3,
			num = var1_3,
			price = var2_3
		})

		arg0_3.commodities[var0_3] = {
			id = var0_3,
			num = var1_3
		}
	end

	for iter2_3, iter3_3 in ipairs(arg2_3) do
		local var3_3 = iter3_3.food_id
		local var4_3 = iter3_3.num

		table.insert(arg0_3.remainCommodities, {
			id = var3_3,
			num = var4_3
		})

		local var5_3 = arg0_3.commodities[var3_3] and arg0_3.commodities[var3_3].num or 0

		arg0_3.commodities[var3_3] = {
			id = var3_3,
			num = var4_3 + var5_3
		}
	end
end

function var0_0.GetCommondities(arg0_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in pairs(arg0_4.commodities) do
		table.insert(var0_4, iter1_4)
	end

	return var0_4
end

function var0_0.GetSellCommondities(arg0_5)
	return arg0_5.sellCommodities
end

function var0_0.GetRemainCommodities(arg0_6)
	return arg0_6.remainCommodities
end

function var0_0.SetAssistants(arg0_7, arg1_7)
	arg0_7.assistants = {}

	for iter0_7, iter1_7 in ipairs(arg1_7) do
		table.insert(arg0_7.assistants, {
			id = iter1_7.post_id,
			shipId = iter1_7.ship_id
		})
	end
end

function var0_0.GetAssistants(arg0_8)
	return arg0_8.assistants
end

function var0_0.ClearAssistantShips(arg0_9)
	for iter0_9, iter1_9 in ipairs(arg0_9.assistants) do
		iter1_9.shipId = 0
	end
end

function var0_0.SetEndTime(arg0_10, arg1_10)
	arg0_10.endTime = arg1_10
end

function var0_0.GetEndTime(arg0_11)
	return arg0_11.endTime
end

function var0_0.InitRemainCnt(arg0_12, arg1_12)
	arg0_12.remainCnt = arg0_12:getConfig("opening_number") - arg1_12
end

function var0_0.ReduceRemainCnt(arg0_13)
	arg0_13.remainCnt = arg0_13.remainCnt - 1
end

function var0_0.GetRemainCnt(arg0_14)
	return arg0_14.remainCnt
end

function var0_0.InitEventData(arg0_15, arg1_15, arg2_15)
	arg0_15.eventId = arg1_15
	arg0_15.eventEffects = arg2_15
	arg0_15.eventInfluence = 0

	if arg0_15.eventId ~= 0 then
		arg0_15.eventInfluence = pg.island_manage_event[arg0_15.eventId].influence_bonus / 100
	end
end

function var0_0.GetEventInfo(arg0_16)
	return arg0_16.eventId, arg0_16.eventEffects, arg0_16.eventInfluence
end

function var0_0.GetStatus(arg0_17)
	if arg0_17.endTime ~= 0 then
		return pg.TimeMgr.GetInstance():GetServerTime() > arg0_17.endTime and var0_0.STATUS.CLOSE or var0_0.STATUS.OPENING
	else
		return arg0_17.remainCnt > 0 and var0_0.STATUS.PREPARE or var0_0.STATUS.END
	end
end

function var0_0.AddSales(arg0_18)
	local var0_18 = 0

	for iter0_18, iter1_18 in pairs(arg0_18.sellCommodities) do
		var0_18 = var0_18 + iter1_18.price
	end

	IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.RESTAURANT_SALES, arg0_18.id, var0_18)

	arg0_18.sales = arg0_18.sales + var0_18

	return arg0_18:CheckUpgrade()
end

function var0_0.GetSales(arg0_19)
	return arg0_19.sales
end

function var0_0.CheckUpgrade(arg0_20)
	local var0_20 = arg0_20:GetCanUpgradeExp()

	if var0_20 ~= 0 and var0_20 <= arg0_20.sales then
		arg0_20.level = arg0_20.level + 1
		arg0_20.rankCfg = pg.island_manage_rank[arg0_20.level]

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandRestUpgrade(arg0_20.id, arg0_20.level))
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.RESTAURANT_RANK)

		return true
	end

	return false
end

function var0_0.UnlockNewAssistant(arg0_21, arg1_21)
	table.insert(arg0_21.assistants, {
		shipId = 0,
		id = arg1_21
	})
end

function var0_0.GetRankLevel(arg0_22)
	return arg0_22.level
end

function var0_0.GetShelfCnt(arg0_23)
	return arg0_23.rankCfg.slot_num[1]
end

function var0_0.GetBaseShelfCapacity(arg0_24)
	return arg0_24.rankCfg.slot_num[2]
end

function var0_0.GetRandomSaleCntBound(arg0_25)
	local var0_25 = math.huge
	local var1_25 = -math.huge

	for iter0_25, iter1_25 in ipairs(arg0_25.rankCfg.random_range) do
		if iter1_25 < var0_25 then
			var0_25 = iter1_25
		end

		if var1_25 < iter1_25 then
			var1_25 = iter1_25
		end
	end

	return var0_25, var1_25
end

function var0_0.GetCanUpgradeExp(arg0_26)
	return underscore.detect(arg0_26.rankCfg.level_up_exp, function(arg0_27)
		return arg0_27[1] == arg0_26.id
	end)[2]
end

function var0_0.GetRankFactor(arg0_28)
	return arg0_28.rankCfg.bonus_coefficient / 100
end

function var0_0.GetRankIcon(arg0_29)
	return arg0_29.rankCfg.icon
end

function var0_0.UpdateData(arg0_30, arg1_30)
	arg0_30.level = arg1_30.lv or 1
	arg0_30.rankCfg = pg.island_manage_rank[arg0_30.level] or 1
	arg0_30.sales = arg1_30.total_sell or 0

	arg0_30:SetCommodities(arg1_30.sell_list or {}, arg1_30.rest_list or {})
	arg0_30:SetAssistants(arg1_30.post_list or {})
	arg0_30:SetEndTime(arg1_30.end_time or 0)
end

function var0_0.GET_RNAK_EXPS(arg0_31)
	local var0_31 = {}
	local var1_31 = pg.island_manage_rank

	for iter0_31, iter1_31 in ipairs(var1_31.all) do
		var0_31[iter1_31] = underscore.detect(var1_31[iter1_31].level_up_exp, function(arg0_32)
			return arg0_32[1] == arg0_31
		end)[2]
	end

	return var0_31
end

return var0_0
