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
end

function var0_0.InitEventData(arg0_2, arg1_2)
	local var0_2 = arg1_2.today_event or 0
	local var1_2 = arg1_2.today_trade or 0
	local var2_2 = {}

	for iter0_2, iter1_2 in ipairs(arg1_2.effect or {}) do
		var2_2[iter1_2.food_id] = iter1_2.add_per
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

function var0_0.GetRestaurants(arg0_4)
	return arg0_4.restaurants
end

function var0_0.GetRestaurantList(arg0_5)
	return underscore.values(arg0_5.restaurants)
end

function var0_0.GetRestaurant(arg0_6, arg1_6)
	return arg0_6.restaurants[arg1_6]
end

function var0_0.GetCntByRestLevel(arg0_7, arg1_7)
	local var0_7 = 0

	for iter0_7, iter1_7 in pairs(arg0_7.restaurants) do
		if arg1_7 <= iter1_7:GetRankLevel() then
			var0_7 = var0_7 + 1
		end
	end

	return var0_7
end

function var0_0.UpdataRestaurant(arg0_8, arg1_8)
	arg0_8.restaurants[arg1_8.id] = arg1_8

	arg0_8:DispatchEvent(var0_0.UPDATE_RESTAURANT)
end

function var0_0.UnlockNewRestaurant(arg0_9, arg1_9)
	local var0_9 = IslandRestaurant.New({
		id = arg1_9
	})

	var0_9:InitEventData(0, {})
	var0_9:InitRemainCnt(0)

	arg0_9.restaurants[var0_9.id] = var0_9

	arg0_9:DispatchEvent(var0_0.ADD_RESTAURANT)
end

function var0_0.UnlockNewAssistant(arg0_10, arg1_10)
	local var0_10 = pg.island_manage_assistant[arg1_10].restaurant

	assert(arg0_10.restaurants[var0_10], string.format("未解锁%d餐厅,提前解锁了%d餐厅岗位", var0_10, arg1_10))
	arg0_10.restaurants[var0_10]:UnlockNewAssistant(arg1_10)
	arg0_10:DispatchEvent(var0_0.ADD_ASSISTANT)
end

function var0_0.DailyRefresh(arg0_11, arg1_11)
	arg0_11:InitEventData(arg1_11)
	arg0_11:InitRemainCnt({})
	arg0_11:DispatchEvent(var0_0.ON_DAILY_REFRESH)
end

function var0_0.UnlockDailyEvent(arg0_12, arg1_12)
	arg0_12:InitEventData(arg1_12)
end

function var0_0.GetTipInfos(arg0_13)
	local var0_13 = 0
	local var1_13 = 0
	local var2_13 = {}

	for iter0_13, iter1_13 in ipairs(pg.island_set.post_manage_operate.key_value_varchar) do
		local var3_13 = arg0_13.restaurants[iter1_13]

		if var3_13 then
			local var4_13 = var3_13:GetStatus()

			if var4_13 == IslandRestaurant.STATUS.CLOSE then
				var0_13 = var0_13 + 1
			elseif var4_13 == IslandRestaurant.STATUS.PREPARE then
				var1_13 = var1_13 + #var3_13:GetAssistants()
			elseif var4_13 == IslandRestaurant.STATUS.OPENING then
				table.insert(var2_13, var3_13:GetEndTime())
			end
		end
	end

	return {
		awardCnt = var0_13,
		emptyCnt = var1_13,
		timestamps = var2_13
	}
end

return var0_0
