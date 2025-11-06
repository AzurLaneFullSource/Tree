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
	arg0_1:SetAssistants(arg1_1.post_list)
	arg0_1:SetEndTime(arg1_1.end_time or 0, arg1_1.speed_time or 0)
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

	if arg1_7 then
		for iter0_7, iter1_7 in ipairs(arg1_7) do
			table.insert(arg0_7.assistants, {
				id = iter1_7.post_id,
				shipId = iter1_7.ship_id
			})
		end
	else
		local var0_7 = getProxy(IslandProxy):GetIsland():GetAblityAgency()

		for iter2_7, iter3_7 in ipairs(arg0_7:getConfig("assistant_slot")) do
			local var1_7 = pg.island_manage_assistant[iter3_7].unlock_type

			if var0_7:HasAbility(var1_7) then
				table.insert(arg0_7.assistants, {
					shipId = 0,
					id = iter3_7
				})
			end
		end
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

function var0_0.SetEndTime(arg0_10, arg1_10, arg2_10)
	arg0_10.endTime = arg1_10 - (arg2_10 or 0)
end

function var0_0.UpdateEndTime(arg0_11, arg1_11)
	arg0_11.endTime = arg0_11.endTime - arg1_11
end

function var0_0.GetEndTime(arg0_12)
	return arg0_12.endTime
end

function var0_0.InitRemainCnt(arg0_13, arg1_13)
	arg0_13.remainCnt = arg0_13:getConfig("opening_number") - arg1_13
end

function var0_0.ReduceRemainCnt(arg0_14)
	arg0_14.remainCnt = arg0_14.remainCnt - 1
end

function var0_0.GetRemainCnt(arg0_15)
	return arg0_15.remainCnt
end

function var0_0.InitEstimateData(arg0_16, arg1_16)
	arg0_16.estimateData = {
		cntMin = arg1_16.sell_num_min or 0,
		cntMax = arg1_16.sell_num_max or 0,
		salesMin = arg1_16.sell_money_min or 0,
		salesMax = arg1_16.sell_money_max or 0
	}
end

function var0_0.GetEstimateData(arg0_17)
	return arg0_17.estimateData
end

function var0_0.InitEventData(arg0_18, arg1_18, arg2_18)
	arg0_18.eventId = arg1_18
	arg0_18.eventEffects = arg2_18
	arg0_18.eventInfluence = 0

	if arg0_18.eventId ~= 0 then
		arg0_18.eventInfluence = pg.island_manage_event[arg0_18.eventId].influence_bonus / 100
	end
end

function var0_0.GetEventInfo(arg0_19)
	return arg0_19.eventId, arg0_19.eventEffects, arg0_19.eventInfluence
end

function var0_0.GetStatus(arg0_20)
	if arg0_20.endTime ~= 0 then
		return pg.TimeMgr.GetInstance():GetServerTime() > arg0_20.endTime and var0_0.STATUS.CLOSE or var0_0.STATUS.OPENING
	else
		return arg0_20.remainCnt > 0 and var0_0.STATUS.PREPARE or var0_0.STATUS.END
	end
end

function var0_0.AddSales(arg0_21)
	local var0_21 = 0

	for iter0_21, iter1_21 in pairs(arg0_21.sellCommodities) do
		var0_21 = var0_21 + iter1_21.price
	end

	IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.RESTAURANT_SALES, arg0_21.id, var0_21)

	arg0_21.sales = arg0_21.sales + var0_21

	return arg0_21:CheckUpgrade()
end

function var0_0.GetSales(arg0_22)
	return arg0_22.sales
end

function var0_0.CheckUpgrade(arg0_23)
	local var0_23 = arg0_23:GetCanUpgradeExp()

	if var0_23 ~= 0 and var0_23 <= arg0_23.sales then
		arg0_23.level = arg0_23.level + 1
		arg0_23.rankCfg = pg.island_manage_rank[arg0_23.level]

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandRestUpgrade(arg0_23.id, arg0_23.level))
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.RESTAURANT_RANK)

		return true
	end

	return false
end

function var0_0.UnlockNewAssistant(arg0_24, arg1_24)
	table.insert(arg0_24.assistants, {
		shipId = 0,
		id = arg1_24
	})
end

function var0_0.GetRankLevel(arg0_25)
	return arg0_25.level
end

function var0_0.GetShelfCnt(arg0_26)
	return arg0_26.rankCfg.slot_num[1]
end

function var0_0.GetBaseShelfCapacity(arg0_27)
	return arg0_27.rankCfg.slot_num[2]
end

function var0_0.GetRandomSaleCntBound(arg0_28)
	local var0_28 = math.huge
	local var1_28 = -math.huge

	for iter0_28, iter1_28 in ipairs(arg0_28.rankCfg.random_range) do
		if iter1_28 < var0_28 then
			var0_28 = iter1_28
		end

		if var1_28 < iter1_28 then
			var1_28 = iter1_28
		end
	end

	return var0_28, var1_28
end

function var0_0.GetCanUpgradeExp(arg0_29)
	return underscore.detect(arg0_29.rankCfg.level_up_exp, function(arg0_30)
		return arg0_30[1] == arg0_29.id
	end)[2]
end

function var0_0.GetRankFactor(arg0_31)
	return arg0_31.rankCfg.bonus_coefficient / 100
end

function var0_0.GetRankIcon(arg0_32)
	return arg0_32.rankCfg.icon
end

function var0_0.UpdateData(arg0_33, arg1_33)
	arg0_33.level = arg1_33.lv or 1
	arg0_33.rankCfg = pg.island_manage_rank[arg0_33.level] or 1
	arg0_33.sales = arg1_33.total_sell or 0

	arg0_33:SetCommodities(arg1_33.sell_list or {}, arg1_33.rest_list or {})
	arg0_33:SetAssistants(arg1_33.post_list or {})
	arg0_33:SetEndTime(arg1_33.end_time or 0)
end

function var0_0.IsPostTip(arg0_34)
	local var0_34 = arg0_34:GetStatus()

	return var0_34 == var0_0.STATUS.PREPARE or var0_34 == var0_0.STATUS.CLOSE
end

function var0_0.GET_RNAK_EXPS(arg0_35)
	local var0_35 = {}
	local var1_35 = pg.island_manage_rank

	for iter0_35, iter1_35 in ipairs(var1_35.all) do
		var0_35[iter1_35] = underscore.detect(var1_35[iter1_35].level_up_exp, function(arg0_36)
			return arg0_36[1] == arg0_35
		end)[2]
	end

	return var0_35
end

return var0_0
