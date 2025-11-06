local var0_0 = class("IslandManageAgecny", import(".IslandBaseAgency"))

var0_0.UPDATE_RESTAURANT = "IslandManageAgecny.UPDATE_RESTAURANT"
var0_0.ADD_RESTAURANT = "IslandManageAgecny.ADD_RESTAURANT"
var0_0.ADD_ASSISTANT = "IslandManageAgecny.ADD_ASSISTANT"
var0_0.ON_DAILY_REFRESH = "IslandManageAgecny.ON_DAILY_REFRESH"

function var0_0.OnInit(arg0_1, arg1_1)
	local var0_1 = arg1_1.trade_sys or {}

	arg0_1.restaurants = {}

	for iter0_1, iter1_1 in ipairs(var0_1.trade_list or {}) do
		local var1_1 = IslandRestaurant.New(iter1_1)

		arg0_1.restaurants[iter1_1.id] = var1_1
	end

	arg0_1:InitEventData(var0_1)
	arg0_1:InitRemainCnt(var0_1.today_num)
	arg0_1:InitEstimateData(var0_1.presell_list)
end

function var0_0.InitEventData(arg0_2, arg1_2)
	local var0_2 = arg1_2.today_event or 0
	local var1_2 = arg1_2.today_trade or 0
	local var2_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.effect or {}) do
		var2_2[iter1_2.food_id] = iter1_2.add_per / 100
	end

	for iter2_2, iter3_2 in pairs(arg0_2.restaurants) do
		if iter3_2.id == var1_2 then
			iter3_2:InitEventData(var0_2, var2_2)
		else
			iter3_2:InitEventData(0, {})
		end
	end
end

function var0_0.InitRemainCnt(arg0_3, arg1_3)
	local var0_3 = {}

	for iter0_3, iter1_3 in ipairs(arg1_3 or {}) do
		var0_3[iter1_3.trade_id] = iter1_3.num
	end

	for iter2_3, iter3_3 in pairs(arg0_3.restaurants) do
		iter3_3:InitRemainCnt(var0_3[iter3_3.id] or 0)
	end
end

function var0_0.InitEstimateData(arg0_4, arg1_4)
	local var0_4 = {}

	for iter0_4, iter1_4 in ipairs(arg1_4 or {}) do
		var0_4[iter1_4.trade_id] = iter1_4
	end

	for iter2_4, iter3_4 in pairs(arg0_4.restaurants) do
		iter3_4:InitEstimateData(var0_4[iter3_4.id] or {})
	end
end

function var0_0.GetRestaurants(arg0_5)
	return arg0_5.restaurants
end

function var0_0.GetRestaurantList(arg0_6)
	return underscore.values(arg0_6.restaurants)
end

function var0_0.GetRestaurant(arg0_7, arg1_7)
	return arg0_7.restaurants[arg1_7]
end

function var0_0.GetCntByRestLevel(arg0_8, arg1_8)
	local var0_8 = 0

	for iter0_8, iter1_8 in pairs(arg0_8.restaurants) do
		if arg1_8 <= iter1_8:GetRankLevel() then
			var0_8 = var0_8 + 1
		end
	end

	return var0_8
end

function var0_0.UpdataRestaurant(arg0_9, arg1_9)
	arg0_9.restaurants[arg1_9.id] = arg1_9

	arg0_9:DispatchEvent(var0_0.UPDATE_RESTAURANT)
end

function var0_0.UnlockNewRestaurant(arg0_10, arg1_10)
	local var0_10 = IslandRestaurant.New({
		id = arg1_10
	})

	var0_10:InitEventData(0, {})
	var0_10:InitRemainCnt(0)

	arg0_10.restaurants[var0_10.id] = var0_10

	arg0_10:DispatchEvent(var0_0.ADD_RESTAURANT)
end

function var0_0.UnlockNewAssistant(arg0_11, arg1_11)
	local var0_11 = pg.island_manage_assistant[arg1_11].restaurant

	assert(arg0_11.restaurants[var0_11], string.format("未解锁%d餐厅,提前解锁了%d餐厅岗位", var0_11, arg1_11))
	arg0_11.restaurants[var0_11]:UnlockNewAssistant(arg1_11)
	arg0_11:DispatchEvent(var0_0.ADD_ASSISTANT)
end

function var0_0.DailyRefresh(arg0_12, arg1_12)
	arg0_12:InitEventData(arg1_12)
	arg0_12:InitRemainCnt({})
	arg0_12:DispatchEvent(var0_0.ON_DAILY_REFRESH)
end

function var0_0.UnlockDailyEvent(arg0_13, arg1_13)
	arg0_13:InitEventData(arg1_13)
end

function var0_0.GetTipInfos(arg0_14)
	local var0_14 = 0
	local var1_14 = 0
	local var2_14 = {}

	for iter0_14, iter1_14 in ipairs(pg.island_set.post_manage_operate.key_value_varchar) do
		local var3_14 = arg0_14.restaurants[iter1_14]

		if var3_14 then
			local var4_14 = var3_14:GetStatus()

			if var4_14 == IslandRestaurant.STATUS.CLOSE then
				var0_14 = var0_14 + 1
			elseif var4_14 == IslandRestaurant.STATUS.PREPARE then
				var1_14 = var1_14 + #var3_14:GetAssistants()
			elseif var4_14 == IslandRestaurant.STATUS.OPENING then
				table.insert(var2_14, var3_14:GetEndTime())
			end
		end
	end

	return {
		awardCnt = var0_14,
		emptyCnt = var1_14,
		timestamps = var2_14
	}
end

return var0_0
