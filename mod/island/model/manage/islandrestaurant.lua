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

function var0_0.InitEventData(arg0_16, arg1_16, arg2_16)
	arg0_16.eventId = arg1_16
	arg0_16.eventEffects = arg2_16
	arg0_16.eventInfluence = 0

	if arg0_16.eventId ~= 0 then
		arg0_16.eventInfluence = pg.island_manage_event[arg0_16.eventId].influence_bonus / 100
	end
end

function var0_0.GetEventInfo(arg0_17)
	return arg0_17.eventId, arg0_17.eventEffects, arg0_17.eventInfluence
end

function var0_0.GetStatus(arg0_18)
	if arg0_18.endTime ~= 0 then
		return pg.TimeMgr.GetInstance():GetServerTime() > arg0_18.endTime and var0_0.STATUS.CLOSE or var0_0.STATUS.OPENING
	else
		return arg0_18.remainCnt > 0 and var0_0.STATUS.PREPARE or var0_0.STATUS.END
	end
end

function var0_0.AddSales(arg0_19)
	local var0_19 = 0

	for iter0_19, iter1_19 in pairs(arg0_19.sellCommodities) do
		var0_19 = var0_19 + iter1_19.price
	end

	IslandAchievementHelper.UpdateRecordWithAdd(IslandAchievementType.RESTAURANT_SALES, arg0_19.id, var0_19)

	arg0_19.sales = arg0_19.sales + var0_19

	return arg0_19:CheckUpgrade()
end

function var0_0.GetSales(arg0_20)
	return arg0_20.sales
end

function var0_0.CheckUpgrade(arg0_21)
	local var0_21 = arg0_21:GetCanUpgradeExp()

	if var0_21 ~= 0 and var0_21 <= arg0_21.sales then
		arg0_21.level = arg0_21.level + 1
		arg0_21.rankCfg = pg.island_manage_rank[arg0_21.level]

		pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandRestUpgrade(arg0_21.id, arg0_21.level))
		IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.RESTAURANT_RANK)

		return true
	end

	return false
end

function var0_0.UnlockNewAssistant(arg0_22, arg1_22)
	table.insert(arg0_22.assistants, {
		shipId = 0,
		id = arg1_22
	})
end

function var0_0.GetRankLevel(arg0_23)
	return arg0_23.level
end

function var0_0.GetShelfCnt(arg0_24)
	return arg0_24.rankCfg.slot_num[1]
end

function var0_0.GetBaseShelfCapacity(arg0_25)
	return arg0_25.rankCfg.slot_num[2]
end

function var0_0.GetRandomSaleCntBound(arg0_26)
	local var0_26 = math.huge
	local var1_26 = -math.huge

	for iter0_26, iter1_26 in ipairs(arg0_26.rankCfg.random_range) do
		if iter1_26 < var0_26 then
			var0_26 = iter1_26
		end

		if var1_26 < iter1_26 then
			var1_26 = iter1_26
		end
	end

	return var0_26, var1_26
end

function var0_0.GetCanUpgradeExp(arg0_27)
	return underscore.detect(arg0_27.rankCfg.level_up_exp, function(arg0_28)
		return arg0_28[1] == arg0_27.id
	end)[2]
end

function var0_0.GetRankFactor(arg0_29)
	return arg0_29.rankCfg.bonus_coefficient / 100
end

function var0_0.GetRankIcon(arg0_30)
	return arg0_30.rankCfg.icon
end

function var0_0.UpdateData(arg0_31, arg1_31)
	arg0_31.level = arg1_31.lv or 1
	arg0_31.rankCfg = pg.island_manage_rank[arg0_31.level] or 1
	arg0_31.sales = arg1_31.total_sell or 0

	arg0_31:SetCommodities(arg1_31.sell_list or {}, arg1_31.rest_list or {})
	arg0_31:SetAssistants(arg1_31.post_list or {})
	arg0_31:SetEndTime(arg1_31.end_time or 0)
end

function var0_0.IsPostTip(arg0_32)
	local var0_32 = arg0_32:GetStatus()

	return var0_32 == var0_0.STATUS.PREPARE or var0_32 == var0_0.STATUS.CLOSE
end

function var0_0.GET_RNAK_EXPS(arg0_33)
	local var0_33 = {}
	local var1_33 = pg.island_manage_rank

	for iter0_33, iter1_33 in ipairs(var1_33.all) do
		var0_33[iter1_33] = underscore.detect(var1_33[iter1_33].level_up_exp, function(arg0_34)
			return arg0_34[1] == arg0_33
		end)[2]
	end

	return var0_33
end

return var0_0
